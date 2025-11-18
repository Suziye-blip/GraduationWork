class Question < ApplicationRecord
    has_many :hints
    belongs_to :user
end
