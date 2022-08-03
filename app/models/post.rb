class Post < ApplicationRecord
    has_many :likes, dependent: :delete_all
    belongs_to :user
end
