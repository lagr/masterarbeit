json.array!(@activities) do |activity|
  json.extract! activity, :id, :name, :type, :process_definition_id, :input_schema, :output_schema, :activity_configuration, :x, :y
  json.url activity_url(activity, format: :json)
end
