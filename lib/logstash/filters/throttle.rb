require "logstash/filters/base"
require "logstash/namespace"

# The throttle filter is used to throttle event throughput based on system load 
class LogStash::Filters::Throttle < LogStash::Filters::Base
  config_name "throttle"
  plugin_status "experimental"

  # Load at which we should start delaying events
  config :load, :validate => :string

  # Seconds to sleep for when max load has been hit. You can pass subsecond 
  # parameters here, but it is not recommended
  config :delay, :validate => :string, :default => 5

  public
  def register
    require "sys/cpu"
  end #def register

  public
  def filter(event)
    return unless filter?(event)
    if Sys::CPU.load_avg[0] > @load.to_f
      sleep(@delay.to_f)
    end
    filter_matched(event)
  end # def filter

end # class LogStash::Filters::Throttle
