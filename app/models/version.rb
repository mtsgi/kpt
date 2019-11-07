class Version < ApplicationRecord
    generate_public_uid

    belongs_to :app

    validates :name, presence: true, uniqueness: { scope: :app_id }
    validates :path, presence: true, uniqueness: { scope: :app_id }
end
