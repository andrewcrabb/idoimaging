json.extract! author, :id, :name_last, :name_first, :institution, :email, :country, :created_at, :updated_at
json.url author_url(author, format: :json)