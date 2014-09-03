module PaymentGatewayCheck
  @available = nil
  MUTEX = Mutex.new

  TASK = PeriodicTask.new(every: 5.seconds, run_immediately: !Rails.env.test?) do
    begin
      result = HTTParty.get ENV['PAYMENT_GATEWAY_PING_ENDPOINT']
      MUTEX.synchronize { @available = result.success? }
    rescue SystemCallError
      MUTEX.synchronize { @available = false }
    end
  end

  def available?
    MUTEX.synchronize { @available }
  end

  %i<run stop>.each { |m| define_method(m) { TASK.send(m) } }

  extend self
end
