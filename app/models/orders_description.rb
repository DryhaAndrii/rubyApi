class OrdersDescription < ApplicationRecord
  belongs_to :order
  belongs_to :item
end