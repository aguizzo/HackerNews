class User < ApplicationRecord
    has_many :submissions
    has_many :votes
    has_many :comments
    has_many :votecs
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

    def upvotec(comment)
        votecs.create(upvotec: 1, comment: comment)
    end

    def upvotecd?(comment)
        votecs.exists?(upvotec: 1, comment: comment)
    end
      
    def remove_votec(comment)
        votecs.find_by(comment: comment).destroy
    end
end
