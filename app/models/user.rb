class User < ApplicationRecord
    has_many :submissions
    has_many :votes
    has_secure_password
    
    def self.create_from_omniauth(auth)
        User.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
            u.username = auth['info']['first_name']
            u.email = auth['info']['email']
            u.password = SecureRandom.hex(16)
        end
    end

    def upvote(submission)
        votes.create(upvote: 1, submission: submission)
    end

    def upvoted?(submission)
        votes.exists?(upvote: 1, submission: submission)
    end
      
    def remove_vote(submission)
        votes.find_by(submission: submission).destroy
    end
end
