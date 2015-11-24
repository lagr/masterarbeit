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

# default data types
#BasicDataType.create(name: 'string')

[wfv, wfv2, wfv3, wfv4].each do |workflow_version|
  # process
  start_elem = StartElement.create 
  end_elem = EndElement.create 
  manual_activity = ManualActivity.create
  
  workflow_version.process_definition.process_elements.create! element: start_elem
  workflow_version.process_definition.process_elements.create! element: end_elem
  workflow_version.process_definition.process_elements.create! element: manual_activity

  manual_activity.process_element_representation.name = "Name"
  manual_activity.assignments.create assigned_role: clerk

  workflow_version.process_definition.control_flows.create predecessor: start_elem, successor: manual_activity
  workflow_version.process_definition.control_flows.create successor: end_elem, predecessor: manual_activity
end

