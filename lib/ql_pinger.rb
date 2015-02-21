require 'dbi'

class QLPinger
  def initialize(name, ip, interval)
    @name = name
    @ip = ip
    @interval = interval
  end

  def ping
    value = %x( ping -c 2 #{@ip} )
    ping = value.match(/((\d+.\d+\/){3}\d+.\d+)/).to_a
    ping = ping[1].split('/')
    @ping = ping[2]
  end

  def set_time
    time = Time.new
    @time = time.strftime('%Y-%m-%d %H:%M:%S')
  end

  def save_to_db
    DBI.connect('DBI:Mysql:quake_live:localhost', 'ql', 'ql') do |dbh|
      dbh.do('CREATE TABLE ping(name varchar(20), date datetime, value float(4,2);') rescue puts 'TABLE ping already exists.'

      sql = 'INSERT INTO ping (name, value, date) VALUES (?, ?, ?)'

      dbh.prepare(sql) do |st|
        st.execute(@name, @ping, @time)
      end
    end
  end

  def sleep
    Kernel::sleep(@interval)
  end

end