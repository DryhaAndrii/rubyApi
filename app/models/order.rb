class Order < ApplicationRecord
  belongs_to :user
  has_many :orders_descriptions
  has_many :items, through: :orders_descriptions
  
  accepts_nested_attributes_for :orders_descriptions
end