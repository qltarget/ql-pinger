class Init < ActiveRecord::Migration
  def up
    execute 'CREATE TABLE ping(name varchar(20) NOT NULL, date datetime NOT NULL, value float(4,2) NOT NULL)'
  end

  def down
    execute 'DROP TABLE ping'
  end
end
