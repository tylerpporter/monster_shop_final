require 'rails_helper'

RSpec.describe 'As a merchant user' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Megans Marmalades',
                                  address: '123 Main St',
                                  city: 'Denver',
                                  state: 'CO',
                                  zip: 80218)
    @merchant_user = @merchant1.users.create(name: 'Megan',
                                              address: '123 Main St',
                                              city: 'Denver',
                                              state: 'CO',
                                              zip: 80218,
                                              email: 'megan@example.com',
                                              password: 'securepassword')
    @discount1 = BulkDiscount.create(discount_percentage: 5,
                                     item_threshold: 20,
                                     merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create(discount_percentage: 10,
                                     item_threshold: 30,
                                     merchant_id: @merchant1.id)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
  end
describe 'When I visit /merchant/bulk_discounts'
  it 'I see a link next to each discount to delete it' do
    visit '/merchant/bulk_discounts'

    within "#discount-#{@discount1.id}" do
      expect(page).to have_button("Delete")
    end

    within "#discount-#{@discount2.id}" do
      click_button "Delete"
    end

    expect(current_path).to eq('/merchant/bulk_discounts')
    expect(page).to_not have_css("section#discount-#{@discount2.id}")
  end

end
