class AddUpVotesToSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :submissions, :upVotes, :integer, default: 0
  end
end
