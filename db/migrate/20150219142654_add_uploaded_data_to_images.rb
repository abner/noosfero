class AddUploadedDataToImages < ActiveRecord::Migration
  def self.up
    change_table :images do |t|
      t.attachment :uploaded_data
    end
  end

  def self.down
    remove_attachment :images, :uploaded_data
  end
end
