class User < ApplicationRecord
    has_many :records
    has_many :questions
end
