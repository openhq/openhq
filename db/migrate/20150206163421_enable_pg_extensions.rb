class EnablePgExtensions < ActiveRecord::Migration
  def self.up
    enable_extension("plpgsql")
    enable_extension("hstore")
    enable_extension("citext")
  end

  def self.down
  end
end
