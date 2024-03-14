class Subscription < ApplicationRecord
    after_create :activate_subscription

    validates :title, :price, :frequency, presence: :true

    enum status: { cancelled: 0, active: 1 }

    belongs_to :customer
    has_many :tea_subscriptions
    has_many :teas, through: :tea_subscriptions

    def activate_subscription
        self.status = 1
    end
end