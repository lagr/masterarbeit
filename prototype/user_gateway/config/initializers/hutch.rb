Hutch::Config.tap do |c|
  c.set :mq_host,     'wfms_mom_1'
  c.set :mq_api_host, 'wfms_mom_1'
  c.set :mq_exchange, 'wfms'
end
begin
  Hutch.connect
rescue
  sleep 5
  retry
end
