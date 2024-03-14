require 'rails_helper'

RSpec.describe 'Subscriptions Request API' do
    describe "Subscription Create" do
        describe "happy path" do
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

                require 'pry'; binding.pry

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
    end
end