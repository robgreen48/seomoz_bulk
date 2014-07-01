class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name
      t.string :site_url
      t.string :creator_email

      t.timestamps
    end
  end
end
