json.extract! submission_ask, :id, :tittle, :content, :punts, :created_at, :updated_at
json.url submission_ask_url(submission_ask, format: :json)
