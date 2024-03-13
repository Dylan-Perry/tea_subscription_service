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
                    title: "#{@tea1.name}",
                    price: 6.00,
                    frequency: 2
                }
                headers = { 
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                }
                
                post api_v1_subscriptions_path, headers: headers, params: JSON.generate(params)

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
                expect(result[:data][:attributes][:frequency]).to be_a(Integer)

                expect(result[:data][:attributes][:title]).to eq(@tea1.title)
                expect(result[:data][:attributes][:price]).to eq(@tea1.price)
                expect(result[:data][:attributes][:status]).to eq(@tea1.status)
                expect(result[:data][:attributes][:frequency]).to eq(@tea1.frequency)
            end
        end
    end
end