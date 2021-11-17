class Comment < ApplicationRecord
  belongs_to :submission
  belongs_to :user
  belongs_to :parent, class_name: 'comment', optional: true
  has_many :comments, foreign_key: :parent_id
  has_many :votecs
  validates :content, presence:true

  def upvotecs
    votecs.sum(:upvotec)
  end
end

