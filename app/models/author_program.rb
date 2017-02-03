class AuthorProgram < ActiveRecord::Base
  belongs_to :author
  belongs_to :program
end
