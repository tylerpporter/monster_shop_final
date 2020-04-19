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
  describe 'When I visit /merchant/bulk_discounts/:id/edit'
  it 'I can fill out a form to edit that bulk discount' do
    visit "/merchant/bulk_discounts/#{@discount1.id}/edit"

    fill_in 'Discount percentage', with: 35
    fill_in 'Item threshold', with: 40

    click_button 'Update Bulk discount'

    @discount1.reload

    expect(current_path).to eq('/merchant/bulk_discounts')
    expect(page).to have_content("Bulk discount with ID: #{@discount1.id} successfully updated")
    within "#discount-#{@discount1.id}" do
      expect(page).to have_content(35)
      expect(page).to have_content(40)
    end
  end
  it 'I get an error message if I do not fill out the form completely' do
    visit "/merchant/bulk_discounts/#{@discount1.id}/edit"

    fill_in 'Discount percentage', with: 40
    fill_in 'Item threshold', with: ""

    click_button 'Update Bulk discount'

    expect(page).to have_content("item_threshold: [\"can't be blank\"]")
    expect(page).to have_button('Update Bulk discount')
  end

end
