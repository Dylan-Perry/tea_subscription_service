class ApplicationController < ActionController::API
    def find_customer_by_email(email)
        Customer.find_by(email: email)
    end
end
