class Post < ApplicationRecord
    has_rich_text :content

    validates :title, length: { maximum: 22  }, presence: true
end
