class Subscription < ApplicationRecord
    validates :title, :price, :frequency, :status, presence: :true

    enum status: ["cancelled", "active"]

    belongs_to :customer
    belongs_to :tea
end