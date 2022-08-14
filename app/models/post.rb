class Post < ApplicationRecord
    has_many :likes, dependent: :delete_all
    belongs_to :user
    has_one_attached :image, :dependent => :destroy
    validates :image, attached: false, size: { less_than: 10.megabytes, message: "file too large" }
    after_validation :log_errors, :if => Proc.new {|m| m.errors}
    #attr_accessor :user, :image, :id, :content, :mod, :changelog, :content
    def log_errors
        Rails.logger.debug self.errors.full_messages.join("\n")
    end
end
