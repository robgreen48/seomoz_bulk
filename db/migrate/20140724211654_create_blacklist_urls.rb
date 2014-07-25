class CreateBlacklistUrls < ActiveRecord::Migration
  def change
    create_table :blacklist_urls do |t|
      t.string :domain

      t.timestamps
    end
  end
end
