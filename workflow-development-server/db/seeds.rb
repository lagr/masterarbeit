# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

organization = Role.create(name: 'Organization')
it_department = Role.create(name: 'IT-Department', parent_role: organization)
accounting_department = Role.create(name: 'Accounting', parent_role: organization)
developer = Role.create(name: 'Developer', parent_role: it_department)
clerk = Role.create(name: 'Clerk', parent_role: accounting_department)

dev_user = User.create(first_name: 'David', last_name: 'Hasselhoff', role: developer) 
clerk_user = User.create(first_name: 'Bernhard Egon', last_name: 'Nutzer', role: clerk) 

wf = Workflow.create(name: 'Sachbearbeitung')
wfv = WorkflowVersion.create(version: 1, workflow: wf)
wfb = WorkflowBundle.create workflow_versions: [wfv]

# default data types
#BasicDataType.create(name: 'string')

# process
start_elem = StartElement.create 
end_elem = EndElement.create 
manual_activity = ManualActivity.create 

wfv.process_definition.process_elements.create! element: start_elem
wfv.process_definition.process_elements.create! element: end_elem
wfv.process_definition.process_elements.create! element: manual_activity

ControlFlow.create process_definition: wfv.process_definition, predecessor: start_elem, successor: manual_activity
ControlFlow.create process_definition: wfv.process_definition, successor: end_elem, predecessor: manual_activity
