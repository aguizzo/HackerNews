json.extract! user, :id, :username, :email, :password, :uid, :provider, :about, :created_at, :updated_at
json.url user_url(user, format: :json)
