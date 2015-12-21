
configuration = Configuration.create(
  name: 'Default Configuration',
  current: true,
  settings: {
    registry: ENV['IMAGE_REGISTRY'] || 'localhost:5000'
  }
)

organization = Role.create(name: 'Organization')

it_department         = organization.child_roles.create(name: 'IT-Department')
accounting_department = organization.child_roles.create(name: 'Accounting')
developer             = it_department.child_roles.create(name: 'Developer')
clerk                 = accounting_department.child_roles.create(name: 'Clerk')

dev_user    = User.create(first_name: 'David',         last_name: 'Hasselhoff', role: developer) 
clerk_user  = User.create(first_name: 'Bernhard Egon', last_name: 'Nutzer',     role: clerk) 

localhost        = Server.create(ip: '0.0.0.0', name: 'localhost', role: 'repository')
execution_server = Server.create(ip: '0.0.0.0', name: 'localhost', role: 'execution')
other_server     = Server.create(ip: '192.168.2.111', name: 'other', role: 'execution')

wf = Workflow.create(name: 'Sachbearbeitung', author: dev_user)
wf2 = Workflow.create(name: 'Regulation', author: dev_user)
wf3 = Workflow.create(name: 'Papierkram', author: dev_user)

wfb = WorkflowBundle.create workflows: [wf2, wf3], servers: [execution_server]

[wf, wf2].each do |workflow|
  wf_process_definition = workflow.process_definition
  wf_process_elements = wf_process_definition.process_elements

  start1      = wf_process_elements.create! element: StartElement.create
  start2      = wf_process_elements.create! element: StartElement.create
  join1       = wf_process_elements.create! element: OrJoinElement.create
  split1      = wf_process_elements.create! element: AndSplitElement.create
  activity    = wf_process_elements.create! element: ContainerActivity.create(image: 'alpine', parameters: ['ls']), process_element_representation: ProcessElementRepresentation.new(name: 'Date')
  m_activity  = wf_process_elements.create! element: ManualActivity.create, process_element_representation: ProcessElementRepresentation.new(name: 'Mark as finished')
  join2       = wf_process_elements.create! element: AndJoinElement.create
  end1        = wf_process_elements.create! element: EndElement.create

  m_activity.element.assignments.create assigned_role: clerk

  start1     .outgoing_control_flows.create! successor: join1
  start2     .outgoing_control_flows.create! successor: join1
  join1      .outgoing_control_flows.create! successor: split1
  split1     .outgoing_control_flows.create! successor: activity
  split1     .outgoing_control_flows.create! successor: m_activity
  activity   .outgoing_control_flows.create! successor: join2
  m_activity .outgoing_control_flows.create! successor: join2
  join2      .outgoing_control_flows.create! successor: end1
end

wf_process_definition = wf3.process_definition
wf_process_elements = wf_process_definition.process_elements

start1      = wf_process_elements.create! element: StartElement.create
subworkflow = wf_process_elements.create! element: SubWorkflowActivity.create(name: wf.name, sub_workflow: wf)
end1        = wf_process_elements.create! element: EndElement.create

start1      .outgoing_control_flows.create! successor: subworkflow
subworkflow .outgoing_control_flows.create! successor: end1

ProcessElement.all.each { |pe| pe.update_attributes input_schema: {} }
