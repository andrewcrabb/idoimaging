json.extract! image_format, :id, :name, :description, :search_level, :created_at, :updated_at
json.url author_url(image_format, format: :json)