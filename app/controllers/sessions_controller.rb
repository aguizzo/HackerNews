class SessionsController < ApplicationController

    def omniauth
        User.find_or_create_by(uid: auth['uid'], provider:auth['provider']) do |u|
            u.username = auth['info']['first_name']
            u.email = auth['info']['email']
            redirect_to newest_path 
        end 
    end

    private
    def auth
        request.env['omniauth.auth']
    end 
end