organization = Role.create name: 'Organization'

it_department = organization.child_roles.create(
  id: '439b4d4b-0324-4ce7-beb2-9189681f4e30',
  name: 'IT-Department'
)

accounting_department = organization.child_roles.create(
  id: '193414fe-d64e-4beb-af47-6fd113333aec',
  name: 'Accounting'
)

developer = it_department.child_roles.create(
  id: '290d0dfa-ef7b-407d-9920-98666fc66e6e',
  name: 'Developer'
)

clerk = accounting_department.child_roles.create(
  id: '5a373138-6d1d-4e7d-aaaf-3441dfef870d',
  name: 'Clerk'
)

dev_user = User.create(
  id: 'fc593e04-42bd-4216-b91e-cfa9df9e5284',
  first_name: 'David',
  last_name: 'Hasselhoff',
  role: developer
)

clerk_user = User.create(
  id: 'ffd29e34-0e2c-49e0-bd56-6498283bdc0e',
  first_name: 'Bernhard Egon',
  last_name: 'Nutzer',
  role: clerk
)

