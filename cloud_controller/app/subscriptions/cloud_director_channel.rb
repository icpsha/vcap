
EM.next_tick do

  # Create a command channel for the Health Manager to call us on
  # when they are requesting state changes to the system.
  # All CloudControllers will form a queue group to distribute
  # the requests.
  # NOTE: Currently it is assumed that all CloudControllers are
  # able to command the system equally. This will not be the case
  # if the staged application store is not 'shared' between all
  # CloudControllers.

  NATS.subscribe('clouddirector.scaledown') do |msg|
    begin
      payload = Yajl::Parser.parse(msg, :symbolize_keys => true)
      CloudController::UTILITY_FIBER_POOL.spawn do
        App.process_scale_down_message(payload)
      end
    rescue => e
      CloudController.logger.error("Exception processing cloud director request: '#{msg}'")
      CloudController.logger.error(e)
    end
  end
end
