class CreateWhitelistUrls < ActiveRecord::Migration
  def change
    create_table :whitelist_urls do |t|
      t.string :domain

      t.timestamps
    end
  end
end
