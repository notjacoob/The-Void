class User < ApplicationRecord
    has_many :likes, :dependent => :destroy
    has_many :posts, :dependent => :destroy
end
