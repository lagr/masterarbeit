# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

developer = Role.create(name: 'Developer')
clerk = Role.create(name: 'Clerk')

dev_user = User.create(first_name: 'David', last_name: 'Hasselhoff', role: developer) 
clerk_user = User.create(first_name: 'Bernhard Egon', last_name: 'Nutzer', role: clerk) 

wf = Workflow.create(name: 'Sachbearbeitung')
wfv = WorkflowVersion.create(name: '1.0.0', workflow: wf)
wfb = WorkflowBundle.create workflow_versions: [wfv]

# default data types
#BasicDataType.create(name: 'string')

# process
start_elem = StartElement.create 
end_elem = EndElement.create 
manual_activity = ManualActivity.create 

wfv.workflow_elements.create! element: start_elem
wfv.workflow_elements.create! element: end_elem
wfv.workflow_elements.create! element: manual_activity

ControlFlow.create workflow_version: wfv, predecessor: start_elem, successor: manual_activity
ControlFlow.create workflow_version: wfv, successor: end_elem, predecessor: manual_activity
