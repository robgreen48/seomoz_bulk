class AddScrapeToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :description, :string
    add_column :urls, :twitter, :string
    add_column :urls, :http_status, :string
  end
end
