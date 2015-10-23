class AddAttachmentImageToGivings < ActiveRecord::Migration
  def self.up
    change_table :givings do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :givings, :image
  end
end
