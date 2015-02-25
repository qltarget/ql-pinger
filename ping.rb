require_relative 'lib/signal_handler'
require_relative 'lib/ql_pinger'

sigint = SignalHandler.new('INT')
pinger = QLPinger.new(
    {
        :ql_de => '91.198.152.137',
        :schnellno_de => '80.255.2.7',
        :indivisus_pl => '5.39.83.138'
    },
    900
)

loop do
  pinger.ping

  sigint.dont_interrupt { pinger.save_to_db }

  pinger.sleep
end