json.array!(@workflows) do |workflow|
  json.extract! workflow, :id, :name, :user_id
  json.url workflow_url(workflow, format: :json)
end
