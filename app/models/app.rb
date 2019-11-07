class App < ApplicationRecord
    belongs_to :user
    has_many :versions, class_name: "Version", foreign_key: "app_id", dependent: :destroy

    validates :name, presence: true
    validates :appid, presence: true, uniqueness: true
end
