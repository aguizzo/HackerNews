class Submission < ApplicationRecord
    belongs_to :user

    validates :title, presence: true
    validates :url, uniqueness: { case_sensitive: false }
end
