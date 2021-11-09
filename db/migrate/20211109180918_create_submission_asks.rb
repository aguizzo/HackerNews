class CreateSubmissionAsks < ActiveRecord::Migration[6.1]
  def change
    create_table :submission_asks do |t|
      t.string :tittle
      t.text :content
      t.integer :punts
      

      t.timestamps
    end
  end
end
