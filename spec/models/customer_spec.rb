require 'rails_helper'

RSpec.describe Customer, type: :model do
    describe 'validations' do
        it { should validate_presence_of(:first_name) }
        it { should validate_presence_of(:last_name) }
        it { should validate_presence_of(:email) }
        it { should validate_presence_of(:address) }

        it { should allow_value('user@example.com').for(:email) }
        it { should_not allow_value('invalid_email').for(:email) }

        it { should have_many(:subscriptions) }
    end

    it "ensures email uniqueness case insensitively" do
        customer1 = Customer.create!(first_name: "Blonk", last_name: "Donk", email: "blonkdonk@gmail.com", address: "123 Donkus Lane")
        customer2 = Customer.create!(first_name: "Blonk", last_name: "Donk", email: "BLONKDONK@gmail.com", address: "123 Donkus Lane")

        expect(customer2).not_to be_valid
        expect(customer2.errors[:email]).to include('has already been taken')
    end
end