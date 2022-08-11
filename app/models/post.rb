class Post < ApplicationRecord
    has_many :likes, dependent: :delete_all
    belongs_to :user
    has_one_attached :image, :dependent => :destroy
end
