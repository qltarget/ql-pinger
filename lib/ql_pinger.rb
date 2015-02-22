require 'dbi'
require 'mysql'
require 'dbd'
require 'yaml'

class QLPinger
  def initialize(name, ip, interval)
    @name = name
    @ip = ip
    @interval = interval
    config
  end

  def ping
    set_time
    value = %x( ping -c 2 #{@ip} )
    ping = value.match(/((\d+.\d+\/){3}\d+.\d+)/).to_a
    ping = ping[1].split('/')
    @ping = ping[2]
  end

  def save_to_db
    sql = 'INSERT INTO ping (name, value, date) VALUES (?, ?, ?)'

    @dbi.prepare(sql) do |st|
      st.execute(@name, @ping, @time)
    end
  end

  def sleep
    Kernel::sleep(@interval)
  end

  private

  def set_time
    time = Time.new
    @time = time.strftime('%Y-%m-%d %H:%M:%S')
  end

  def config
    config = YAML.load_file('db/config.yml')
    config = config['standalone']
    @dbi = DBI.connect("DBI:#{config['driver']}:#{config['database']}", "#{config['username']}", "#{config['password']}")
  end

end