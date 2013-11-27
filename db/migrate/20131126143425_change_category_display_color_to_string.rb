class ChangeCategoryDisplayColorToString < ActiveRecord::Migration
 
  def self.up
    change_table :categories do |t|
      t.change :display_color, :string, :limit => 6
    end
  end

  def self.down
    change_table :categories do |t|
      t.change :display_color, :integer
    end
  end
end