require 'rails_helper'

RSpec.describe 'Subscriptions Request API' do
    describe "Subscription Create" do
        before :each do
            @customer1 = Customer.create!(
                first_name: "General",
                last_name: "Iroh",
                email: "dragonofthewest@gmail.com",
                address: "123 Pi Cho Ct, Ba Sing Se"
                )

            @tea1 = Tea.create!(
                title: "Ginseng",
                description: "Ginseng has been used for improving overall health. It has also been used to strengthen the immune system and help fight off stress and disease.",
                temperature: "208°F",
                brew_time: "5 - 10 minutes"
            )
        end

        describe "happy path" do
            it "creates a subscription for a customer and tea" do
                params = {
                    customer_email: "#{@customer1.email}",
                    title: "#{@tea1.title}",
                    price: 6.00,
                    frequency: "1 week"
                }
                headers = { 
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                }
                
                post api_v1_customer_subscriptions_path(@customer1), headers: headers, params: JSON.generate(params)

                result = JSON.parse(response.body, symbolize_names: true)

                # Test response and status code
                expect(response).to be_successful
                expect(response.status).to eq(201)

                # Test correct JSON formatting
                expect(result[:data]).to be_a Hash

                # Test attribute correctness
                expect(result[:data][:attributes].count).to eq 4

                expect(result[:data][:attributes]).to have_key(:title)
                expect(result[:data][:attributes]).to have_key(:price)
                expect(result[:data][:attributes]).to have_key(:status)
                expect(result[:data][:attributes]).to have_key(:frequency)

                expect(result[:data][:attributes][:title]).to be_a(String)
                expect(result[:data][:attributes][:price]).to be_a(Float)
                expect(result[:data][:attributes][:status]).to be_a(String)
                expect(result[:data][:attributes][:frequency]).to be_a(String)

                expect(result[:data][:attributes][:title]).to eq(@tea1.title)
                expect(result[:data][:attributes][:price]).to eq(6.00)
                expect(result[:data][:attributes][:frequency]).to eq("1 week")
                expect(result[:data][:attributes][:status]).to eq("active")
            end
        end

        describe "sad path" do
            it "errors out if required params are not provided" do
                params = {
                    customer_email: "#{@customer1.email}",
                    frequency: "1 week"
                }
                headers = { 
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                }
                
                post api_v1_customer_subscriptions_path(@customer1), headers: headers, params: JSON.generate(params)

                result = JSON.parse(response.body, symbolize_names: true)

                # Test response and status code
                expect(response).to_not be_successful
                expect(response.status).to eq(401)

                # JSON formatting according to front end spec
                expect(result).to be_a(Hash)

                # Test missing attribute errors
                expect(result).to have_key(:title)
                expect(result).to have_key(:price)

                expect(result[:title]).to include("can't be blank")
                expect(result[:price]).to include("can't be blank")
            end

            it "errors out if provided email does not match a user" do
                params = {
                    customer_email: "borgus@borgus.com",
                    title: "#{@tea1.title}",
                    price: 6.00,
                    frequency: "1 week"
                }
                headers = { 
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                }
                
                post api_v1_customer_subscriptions_path(@customer1), headers: headers, params: JSON.generate(params)

                result = JSON.parse(response.body, symbolize_names: true)

                # Test response and status code
                expect(response).to_not be_successful
                expect(response.status).to eq(401)

                # JSON formatting according to front end spec
                expect(result).to be_a(Hash)

                expect(result[:error]).to eq("Sorry, your credentials are bad!")
            end
        end
    end

    describe "Subscription Update" do
        before :each do
            @customer1 = Customer.create!(
                first_name: "General",
                last_name: "Iroh",
                email: "dragonofthewest@gmail.com",
                address: "123 Pi Cho Ct, Ba Sing Se"
                )

            @tea1 = Tea.create!(
                title: "Ginseng",
                description: "Ginseng has been used for improving overall health. It has also been used to strengthen the immune system and help fight off stress and disease.",
                temperature: "208°F",
                brew_time: "5 - 10 minutes"
            )

            @subscription1 = @customer1.subscriptions.create!(
                title: "#{@tea1.title}",
                price: 6.00,
                frequency: "1 week"
            )
        end

        describe "happy path" do
            it "updates a subscription status to 'cancelled'" do
                params = {
                    subscription_id: @subscription1.id,
                    status: 0
                }
                headers = {
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                }
                
                patch api_v1_customer_subscription_path(@customer1, @subscription1), headers: headers, params: JSON.generate(params)

                result = JSON.parse(response.body, symbolize_names: true)

                # Test response and status code
                expect(response).to be_successful
                expect(response.status).to eq(200)

                expect(result[:data][:attributes][:status]).to eq("cancelled")
            end
        end

        describe "sad path" do
            it "errors out when subscription ID does not match" do
                params = {
                    subscription_id: 4,
                    status: 0
                }
                headers = {
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                }
                
                patch api_v1_customer_subscription_path(@customer1, @subscription1), headers: headers, params: JSON.generate(params)

                result = JSON.parse(response.body, symbolize_names: true)

                # Test response and status code
                expect(response).to_not be_successful
                expect(response.status).to eq(401)

                # JSON formatting according to front end spec
                expect(result).to be_a(Hash)

                expect(result[:error]).to eq("Sorry, your credentials are bad!")
            end
        end
    end
end