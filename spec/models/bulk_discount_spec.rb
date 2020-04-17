require 'rails_helper'

RSpec.describe BulkDiscount do

  describe 'relationships' do
    it {should belong_to :merchants}
  end

  describe 'validations' do
    it {should validate_presence_of :discount_percentage}
    it {should validate_presence_of :item_threshold}
  end

end
