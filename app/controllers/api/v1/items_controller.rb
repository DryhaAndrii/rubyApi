class Api::V1::ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, only: [:create]
  before_action :set_item, only: [:update] # Находим товар перед обновлением
  # GET /api/v1/items
  def index
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10
    offset = (page - 1) * per_page
  
    @items = Item.offset(offset).limit(per_page)
    render json: @items
  end

  # POST /api/v1/items
  def create
    @item = Item.new(item_params)
    if @item.save
      render json: @item, status: :created
    else
      render json: { errors: @item.errors }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/items/search
  def search
    query = params[:query].to_s.downcase
    @items = Item.where("LOWER(name) LIKE ?", "%#{query}%")
    render json: @items
  end

  # PATCH/PUT /api/v1/items/:id
  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: { errors: @item.errors }, status: :unprocessable_entity
    end
  end

  private

  # Находим товар по ID
  def set_item
    @item = Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Item not found' }, status: :not_found
  end
  

  private

  def item_params
    params.require(:item).permit(:name, :description, :price)
  end

  def check_admin
    unless current_user.admin?
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end
end