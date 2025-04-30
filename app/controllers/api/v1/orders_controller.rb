class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    orders = current_user.orders.includes(:items, :orders_descriptions)
    render json: orders.as_json(include: { 
      items: { only: [:id, :name, :price] },
      orders_descriptions: { only: [:item_id, :quantity] }
    })
  end

  def create
    @order = current_user.orders.new(amount: calculate_total)

    if @order.save
      create_order_descriptions(@order)
      render json: { order: @order, items: @order.items }, status: :created
    else
      render json: { errors: @order.errors }, status: :unprocessable_entity
    end
  end

  private

  def calculate_total
    params[:items].sum do |item|
      item_record = Item.find_by(id: item[:id])
      item_record ? item_record.price * item[:quantity].to_i : 0
    end
  end

  def create_order_descriptions(order)
    params[:items].each do |item|
      order.orders_descriptions.create!(
        item_id: item[:id],
        quantity: item[:quantity]
      )
    end
  end
end
