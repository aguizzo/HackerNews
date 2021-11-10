class CreateSubmissions < ActiveRecord::Migration[6.1]
  def change
    create_table :submissions do |t|
      t.string :title
      t.string :url
      t.text :text
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
