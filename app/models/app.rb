class App < ApplicationRecord
    belongs_to :user

    validates :name, presence: true
    validates :appid, presence: true, uniqueness: true
end
