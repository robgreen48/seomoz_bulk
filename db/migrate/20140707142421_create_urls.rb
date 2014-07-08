class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.integer :report_id
      t.string :uri
      t.integer :domain_authority
      t.integer :page_authority
      t.integer :ext_links
      t.integer :links
      t.string :canonical_url
      t.string :title

      t.timestamps
    end
  end
end
