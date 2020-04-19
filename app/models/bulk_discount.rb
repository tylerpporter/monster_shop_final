class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :discount_percentage,
                        :item_threshold


end
