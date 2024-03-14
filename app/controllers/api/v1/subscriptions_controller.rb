class Api::V1::SubscriptionsController < ApplicationController

    # POST /customers/customer_id/subscriptions
    def create
        customer = find_customer_by_email(params[:customer_email])

        if customer
            # subscription = Subscription.new(subscription_params)
            subscription = customer.subscriptions.new(subscription_params)

            if subscription.save
                render json: SubscriptionSerializer.new(subscription), status: :created
            else
                render json: subscription.errors, status: :unauthorized
            end
        else
            raise ActiveRecord::RecordNotFound
        end
    end

    private

    def subscription_params
        params.permit(:title, :price, :frequency, :status)
    end
end