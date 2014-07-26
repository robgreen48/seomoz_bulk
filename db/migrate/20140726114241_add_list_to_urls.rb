class AddListToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :list, :string
  end
end
