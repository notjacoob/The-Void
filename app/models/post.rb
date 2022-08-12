class Post < ApplicationRecord
    has_many :likes, dependent: :delete_all
    belongs_to :user
    has_one_attached :image, :dependent => :destroy
    validates :image, attached: true, size: { less_than: 10.megabytes, message: "file too large" }
end
