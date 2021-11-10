class SessionsController < ApplicationController

    def omniauth  #log users in with omniauth
        user = User.create_from_omniauth(auth)
        
            session[:user_id] = user.id
            redirect_to newest_path
        
          
    end
   def destroy
    session[:user_id] = nil
    redirect_to newest_path
   end

    private
    def auth
        request.env['omniauth.auth']
    end 
end