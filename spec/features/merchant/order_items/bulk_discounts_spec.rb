require 'rails_helper'

RSpec.describe 'As a user' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Megans Marmalades',
                                  address: '123 Main St',
                                  city: 'Denver',
                                  state: 'CO',
                                  zip: 80218)
    @merchant2 = Merchant.create!(name: 'Pups4U',
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
    @giant = @merchant1.items.create!(name: 'Giant',
                                      description: "I'm a Giant!",
                                      price: 50,
                                      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw',
                                      active: true,
                                      inventory: 100 )
    @item = @merchant2.items.create!(name: 'Item',
                                      description: "I'm a Giant!",
                                      price: 50,
                                      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw',
                                      active: true,
                                      inventory: 100 )
    @ogre = @merchant1.items.create!(name: 'Ogre',
                                     description: "I'm an Ogre!",
                                     price: 20.25,
                                     image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw',
                                     active: true,
                                     inventory: 100 )

    # @order1 = @merchant_user.orders.create!
    # @order_item1 = @order1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 20)
    # @order_item2 = @order1.order_items.create!(item: @giant, price: @giant.price, quantity: 15)
    # @order_item3 = @order1.order_items.create!(item: @item, price: @item.price, quantity: 20)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    visit item_path(@giant)
    click_button 'Add to Cart'
    visit item_path(@ogre)
    click_button 'Add to Cart'
    visit cart_path
    18.times do
      within "#item-#{@giant.id}" do
        click_button('More of This!')
      end
    end
  end
  describe 'When my order items quantity reaches the threshold for a bulk discount' do
    it 'I see that bulk discount being applied in my cart' do
      visit cart_path

      within "#item-#{@giant.id}" do
        expect(page).to have_content('Quantity: 19')
        expect(page).to_not have_content("#{@discount1.discount_percentage}% discount applied to item: #{@giant.name}")
        click_button('More of This!')
        expect(page).to have_content('Quantity: 20')
        expect(page).to have_content("#{@discount1.discount_percentage}% discount applied to item: #{@giant.name}")
      end
    end
    it 'A discount is applied to my corresponding order item' do
      visit cart_path
      within "#item-#{@giant.id}" do
        click_button('More of This!')
      end
      click_button 'Check Out'
      order_item = @merchant1.orders.last.order_items.where(item_id: @giant.id).first

      expect(order_item.price).to eq(47.50)

      order2 = @merchant_user.orders.create!

      order_item2 = order2.order_items.create!(item: @item, price: @item.price, quantity: 20)
      
      expect(order_item2.price).to eq(50)
    end
  end
end
