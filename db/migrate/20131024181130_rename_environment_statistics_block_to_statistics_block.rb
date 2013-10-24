class RenameEnvironmentStatisticsBlockToStatisticsBlock < ActiveRecord::Migration
  def self.up    
    out = IO.popen("#{File.dirname(__FILE__)}/../../script/noosfero-plugins enable statistics").readlines.first   
    raise "could not activate the statistics plugin" unless out.match(/enabled/) 
    update("update blocks set type = 'StatisticsBlock' where type = 'EnvironmentStat0isticsBlock'")
    
    Environment.all.each do |env|
      env.enable_plugin('StatisticsPlugin')
    end
  end

  def self.down    
    #say("Nothing to undo (cannot recover the data)")
  end
end
