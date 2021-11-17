class CreateVotecs < ActiveRecord::Migration[6.1]
  def change
    create_table :votecs do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :comment, null: false, foreign_key: true
      t.integer :upvotec
      t.integer :downvotec

      t.timestamps
    end
  end
end
