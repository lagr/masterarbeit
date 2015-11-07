# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(first_name: 'David', last_name: 'Hasselhoff') 
wf = Workflow.create(name: 'WF 1')
wfv = WorkflowVersion.create(name: 'WFV 1', workflow: wf)
