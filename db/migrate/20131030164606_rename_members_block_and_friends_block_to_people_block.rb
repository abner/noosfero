class RenameMembersBlockAndFriendsBlockToPeopleBlock < ActiveRecord::Migration
  def self.up
    out = IO.popen("#{File.dirname(__FILE__)}/../../script/noosfero-plugins enable people_block").readlines.first
    raise "could not activate the people block plugin" unless out.match(/enabled/)
    update("update blocks set type = 'PeopleBlock' where type in ('FriendsBlock','MembersBlock')")

    Environment.all.each do |env|
      env.enable_plugin('PeopleBlock')
    end
  end

  def self.down
    #say("Nothing to undo (cannot recover the data)")
  end
end
