Hutch::Config.tap do |c|
  c.set :mq_host, 'mom_service_1'
  c.set :mq_exchange, 'wfms'
  c.set :mq_api_host, 'mom_service_1'
end

begin
  Hutch.connect
rescue
  sleep 5
  retry
end
