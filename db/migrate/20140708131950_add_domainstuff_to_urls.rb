class AddDomainstuffToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :domain, :string
    add_column :urls, :public_suffix, :string
  end
end
