class Workflow::ProcessDefinition
  def initialize
    file = File.read('/workflow/process_definition.json')
    hash = JSON.parse(file)
  end

  def elements
  end

  def successors_of(element)
  end
end
