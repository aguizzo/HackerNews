Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, 1005276579102-tthdnul518k1lpivginsgb8rvqf71uc9.apps.googleusercontent.com,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, :skip_jwt => true
  end