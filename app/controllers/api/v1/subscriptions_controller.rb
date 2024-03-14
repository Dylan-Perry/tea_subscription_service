class Api::V1::SubscriptionsController < ApplicationController

    # POST /customers/customer_id/subscriptions
    def create
        customer = find_customer_by_email(params[:customer_email])

        # if customer
            subscription = customer.subscriptions.new(subscription_params)

            if subscription.save
                render json: SubscriptionSerializer.new(subscription), status: :created
            else
                render json: subscription.errors, status: :unauthorized
            end
        # else
        #     require 'pry'; binding.pry
        #     raise ActiveRecord::RecordNotFound
        # end
    end

    # POST /customers/customer_id/subscriptions/subscription_id
    def update
        subscription = Subscription.find(params[:subscription_id])

        if subscription.update(subscription_params)
            render json: SubscriptionSerializer.new(subscription), status: :ok
        else
            render json: subscription.errors, status: :unprocessable_entity
        end
    end
    
    private

    def subscription_params
        params.permit(:title, :price, :frequency, :status)
    end
end