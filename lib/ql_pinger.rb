require 'dbi'
require 'mysql'
require 'dbd'
require 'yaml'

class QLPinger
  def initialize(ips, interval)
    @ips = ips
    @interval = interval
    @ping = {}
    config
  end

  def ping
    set_time
    @ips.each_pair do |name, ip|
      value = %x( ping -c 5 #{ip} )
      ping = value.match(/((\d+.\d+\/){3}\d+.\d+)/).to_a
      ping = ping[1].split('/')
      @ping[name] = ping[2]
    end
  end

  def save_to_db
    sql = 'INSERT INTO ping (name, value, date) VALUES (?, ?, ?)'

    @dbi.prepare(sql) do |st|
      @ping.each_pair do |name, ping|
        st.execute(name, ping, @time)
      end
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
    config = YAML.load_file("#{Dir.pwd}/db/config.yml")
    config = config['standalone']
    @dbi = DBI.connect("#{config['dsn']}", "#{config['username']}", "#{config['password']}")
  end

end