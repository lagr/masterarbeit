organization          = Role.create name: 'Organization'

it_department         = organization.child_roles.create name: 'IT-Department'
accounting_department = organization.child_roles.create name: 'Accounting'
developer             = it_department.child_roles.create name: 'Developer'
clerk                 = accounting_department.child_roles.create name: 'Clerk'

dev_user = User.create(
  first_name: 'David', last_name: 'Hasselhoff',
  role: developer
)

clerk_user = User.create(
  first_name: 'Bernhard Egon', last_name: 'Nutzer',
  role: clerk
)


def create_activity(workflow, data)
  activity_data = {
    activity_configuration: {
      input_schema:  {},
      output_schema: {},
      activity_configuration: {},
      representation: { x: 0, y: 0, name: data[:name] }
    }
  }.deep_merge(data)

  workflow.process_definition.activities.create!(activity_data)
end

def create_control_flow(from:, to:)
  from.outgoing_control_flows.create! successor: to
end

wf = Workflow.create(name: 'Sachbearbeitung', author: dev_user)
wf2 = Workflow.create(name: 'Regulation', author: dev_user)
wf3 = Workflow.create(name: 'Papierkram', author: dev_user)

[wf, wf2].each do |workflow|
  start1      = create_activity(workflow, activity_type: :start, name: 'Start 1')
  start2      = create_activity(workflow, activity_type: :start, name: 'Start 2')
  join1       = create_activity(workflow, activity_type: :orjoin)
  split1      = create_activity(workflow, activity_type: :andsplit)

  activity    = create_activity(workflow, activity_type: :container, name: 'List files',
    activity_configuration: {
      image: 'alpine',
      image_version: 'latest',
      cmd: ['cat', '/etc/hosts']
    }
  )

  m_activity  = create_activity(workflow, activity_type: :manual, name: 'Mark as finished')
  m_activity.assignments.create assignable: clerk

  join2       = create_activity(workflow, activity_type: :andjoin)
  end1        = create_activity(workflow, activity_type: :end)

  create_control_flow from: start1,      to: join1
  create_control_flow from: start2,      to: join1
  create_control_flow from: join1,       to: split1
  create_control_flow from: split1,      to: activity
  create_control_flow from: split1,      to: m_activity
  create_control_flow from: activity,    to: join2
  create_control_flow from: m_activity,  to: join2
  create_control_flow from: join2,       to: end1
end

start1      = create_activity(wf3, activity_type: :start, name: 'Start 1')
subworkflow = create_activity(wf3, activity_type: :subworkflow, name: wf.name, subworkflow: wf)
end1        = create_activity(wf3, activity_type: :end)

create_control_flow from: start1,      to: subworkflow
create_control_flow from: subworkflow, to: end1
