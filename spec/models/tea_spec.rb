require 'rails_helper'

RSpec.describe Tea, type: :model do
    describe 'validations' do
        it { should validate_presence_of(:title) }
        it { should validate_presence_of(:description) }
        it { should validate_presence_of(:temperature) }
        it { should validate_presence_of(:brew_time) }

        it { should have_many(:subscriptions) }

        it "ensures title uniqueness case insensitively" do
            tea1 = Tea.create(title: "Blonk", description: "It's cool", temperature: "208°F", brew_time: "127 hours")
            tea2 = Tea.create(title: "BLONK", description: "It's cool", temperature: "208°F", brew_time: "127 hours")
    
            expect(tea2).not_to be_valid
            expect(tea2.errors[:title]).to include('has already been taken')
        end
    end
end