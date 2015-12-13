class Workflow::ProcessInstance
  attr_accessor :triggered_start_element, :logger, :process_definition, :fibers, :finished_end_elements, :activity_instances, :workdir
  def initialize(triggered_start_element:, logger:, process_definition:, workdir:)
    @triggered_start_element = triggered_start_element
    @logger = logger
    @process_definition = process_definition
    @fibers = {}
    @finished_end_elements = []
    @activity_instances = process_definition.activities.collect { |activity| ActivityInstance.new(activity, logger) }
    @process_definition.elements.map(&method(:register_fiber))
  end

  def start
    validate schema: workflow_input_schema, data_path: workflow_input_data_path
    ## TODO: Workflow::Mapper.map(mapping: workflow_input_mapping, data_path: workflow_input_data_path).map
    ## starte element, dass zum trigger gehört
    ## run([start_element])
    ## loop do
    ##   fibers.each do |element_id, fiber|
    ##     fiber.resume
    ##   end

    # Fiber.new do
    #   loop do 
    #     break if end_element_completed?

    #     activity_instances.each do |activity_instance|
    #       completed_predecessors
    #       state = activity_instance.update_state
          
    #       if state == :completed
    #         break if activity_instance.end_element?
    #       end
    #     end
    #   end 
    # end.resume

    ## start [triggered_start_element]
    ## warte auf container ende
    ## verwerte output
      ## wenn end element -> output zurück an aufrufer
      ## sonst output an nachfolger weiterreichen
    ## starte nachfolger
      ## wenn and_split, starte alle nachfolger
      ## wenn and_join
      ## wenn or_join, starte nachfolger
      ## wenn or_split, werte bedingung aus und starte passenden nachfolger

    ###threads.select(&:alive?).map!(&:join)
  end

  ## def start(elements: [])
  ##   return if elements.empty?
  ##   element_threads = elements.map do |element|
  ##     Thread.new do
  ##       prepare_workdir_for(element)
  ##       container = create_container_for(element)
  ##       container.start
  ##       container.wait
  ##     end
  ##   end

  ##   threads += element_threads
  ##   element_threads.map!(&:join)
  ##   end
  ## end

  def end_element_completed?
    finished_end_elements.empty?
  end

  def register_fiber(element)
    fibers[process_element.id] = Fiber.new do
      finished_predecessors = []
      loop do
        required_predecessors_finished?(element, finished_predecessors) ? break : finished_predecessors << Fiber.yield :inactive
      end

      element_container = create_container_for(element)
      
      loop { container_stopped?(element_container) ? break : Fiber.yield :active }

      fibers[process_element.id] = register_fiber(element) if finished_end_elements.empty?
    end
  end

  def required_predecessors_finished?(element, finished_predecessors)
    return true if element.id == triggered_start_element
    (required_predecessors(element) - finished_predecessors.compact).empty?
  end

  def required_predecessors(element)
    required_predecessors
  end

  def start_element(element)
    container = create_container_for(element)
    container.start!
  end

  def validate_data(of:, data_type:)
    element, type = of, data_type
    case type
    when :input
      validate schema: process_element_input_schema(element), data: process_element_input_data(element)
    when :output
      validate schema: process_element_output_schema(element), data: process_element_output_data(element)
    end
  end

  def validate(schema:, data_path:)
    Workflow::Validator.new(schema: schema, data_path: data_path).validate
  end

  def map(mapping:, data_path:)
    Workflow::Mapper.map(mapping: workflow_input_mapping, data_path: workflow_input_data_path).map
  end
end
