class Submission < ApplicationRecord
    belongs_to :user
    has_many :votes

    validates :title, presence: true
    validates :url, uniqueness: { case_sensitive: false }

    def upvotes
        votes.sum(:upvote)
    end

end
