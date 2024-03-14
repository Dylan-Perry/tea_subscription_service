class Api::V1::SubscriptionsController < ApplicationController
    # GET /customers/customer_id/subscriptions
    def index
        customer = Customer.find(params[:customer_id])

        render json: SubscriptionSerializer.new(customer.subscriptions)
    end
    
    # POST /customers/customer_id/subscriptions
    def create
        customer = find_customer_by_email(params[:customer_email])
        subscription = customer.subscriptions.new(subscription_params)

        if subscription.save
            render json: SubscriptionSerializer.new(subscription), status: :created
        else
            render json: subscription.errors, status: :unauthorized
        end
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