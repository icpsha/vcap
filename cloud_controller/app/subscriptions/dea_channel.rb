EM.next_tick do

  # Create a command channel for the Health Manager to call us on
  # when they are requesting state changes to the system.
  # All CloudControllers will form a queue group to distribute
  # the requests.
  # NOTE: Currently it is assumed that all CloudControllers are
  # able to command the system equally. This will not be the case
  # if the staged application store is not 'shared' between all
  # CloudControllers.

  NATS.subscribe('dea.monitoringbeat') do |msg|
    begin
      payload = Yajl::Parser.parse(msg, :symbolize_keys => true)
      if App.find_by_id(payload[:app_id])
      systemMetric = SystemMetric.new(:app_id =>payload[:app_id],:instance_index =>payload[:instance_index],:cpu =>payload[:cpu],:memory =>payload[:mem],:disk =>payload[:disk])
      systemMetric.save
      end 
    rescue => e
      CloudController.logger.error("Exception processing dea monitoring beat: '#{msg}'")
      CloudController.logger.error(e)
    end
  end
  
  NATS.subscribe('dea.routermetricbeat') do |msg|
    begin
      payload = Yajl::Parser.parse(msg, :symbolize_keys => true)
      if App.find_by_id(payload[:app_id])
      routerMetric = routerMetric.new(:app_id =>payload[:app_id],:avg_latency =>payload[:avg_latency],:timeout => payload[:timeout])
      routerMetric.save
      end 
    rescue => e
      CloudController.logger.error("Exception processing dea router metric beat: '#{msg}'")
      CloudController.logger.error(e)
    end
  end
  
  
end
