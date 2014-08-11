class AddCatsToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :is_blog, :boolean
    add_column :urls, :is_directory, :boolean
    add_column :urls, :is_forum, :boolean
    add_column :urls, :is_link_page, :boolean
    add_column :urls, :is_article, :boolean
    add_column :urls, :is_wiki, :boolean
    add_column :urls, :is_gov, :boolean
    add_column :urls, :is_pr, :boolean
    add_column :urls, :is_scraper, :boolean
  end
end
