class AddStatusToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :status, :string, :default => "not done"
  end
end
