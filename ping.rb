require_relative 'lib/signal_handler'
require_relative 'lib/ql_pinger'

sigint = SignalHandler.new('INT')
pinger = QLPinger.new('de', '91.198.152.137', 600)

loop do
  pinger.ping

  sigint.dont_interrupt{ pinger.save_to_db }

  pinger.sleep
end