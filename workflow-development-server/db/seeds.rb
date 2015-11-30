# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

organization = Role.create(name: 'Organization')

it_department         = organization.child_roles.create(name: 'IT-Department')
accounting_department = organization.child_roles.create(name: 'Accounting')
developer             = it_department.child_roles.create(name: 'Developer')
clerk                 = accounting_department.child_roles.create(name: 'Clerk')

dev_user    = User.create(first_name: 'David',         last_name: 'Hasselhoff', role: developer) 
clerk_user  = User.create(first_name: 'Bernhard Egon', last_name: 'Nutzer',     role: clerk) 

localhost     = Server.create(ip: '0.0.0.0', name: 'localhost', role: 'repository')
other_server  = Server.create(ip: '192.168.2.123', name: 'other')

workflow = Workflow.create(name: 'Sachbearbeitung', author: dev_user)
wfv = workflow.workflow_versions.create(subsubversion: 1)
wfv2 = workflow.workflow_versions.create(subsubversion: 2)

workflow2 = Workflow.create(name: 'Regulation')
wfv3 = workflow2.workflow_versions.create(subsubversion: 1)
wfv4 = workflow2.workflow_versions.create(subsubversion: 2)

wfb = WorkflowBundle.create workflow_versions: [wfv, wfv3]

[wfv, wfv2, wfv3, wfv4].each do |workflow_version|
  wfv_process_definition = workflow_version.process_definition
  wfv_process_elements = wfv_process_definition.process_elements

  start1     = wfv_process_elements.create! element: StartElement.create
  start2     = wfv_process_elements.create! element: StartElement.create
  join1      = wfv_process_elements.create! element: OrJoinElement.create
  split1     = wfv_process_elements.create! element: AndSplitElement.create
  activity   = wfv_process_elements.create! element: ContainerizedActivity.create, process_element_representation: ProcessElementRepresentation.new(name: 'Date')
  m_activity = wfv_process_elements.create! element: ManualActivity.create, process_element_representation: ProcessElementRepresentation.new(name: 'Date')
  join2      = wfv_process_elements.create! element: AndJoinElement.create
  end1       = wfv_process_elements.create! element: EndElement.create

  m_activity.element.assignments.create assigned_role: clerk

  start1     .outgoing_control_flows.create! successor: join1
  start2     .outgoing_control_flows.create! successor: join1
  join1      .outgoing_control_flows.create! successor: split1
  split1     .outgoing_control_flows.create! successor: activity
  split1     .outgoing_control_flows.create! successor: m_activity
  activity   .outgoing_control_flows.create! successor: join2
  m_activity .outgoing_control_flows.create! successor: join2
  join2      .outgoing_control_flows.create! successor: end1
  # end1       .outgoing_control_flows.create! successor: end1
end

# puts ControlFlow.all.collect(&:predecessor).reject(&:valid?).map(&:errors).map(&:messages)
