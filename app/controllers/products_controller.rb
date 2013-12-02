class ProductsController < ApplicationController
  include ApplicationHelper

  #before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1.json
  def show

    respond_to do |format|
      format.json do
        render json: {
            :name => 'Product Name',
            :image => 'R0lGODdhCgAKAOMAAMzMzJaWlqqqqre3t6Ojo7GxscXFxb6+vpycnAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACgAKAAAEGxDISau9mIpRC5FfIRRgaQTTNwKjABzIkc1ABAA7',
            :ingredients => [
                {
                    :id => '/ingredients/1',
                    :links => [
                        link('ingredient_info', 'GET', '/ingredients/1.json')
                    ]
                }
            ],
            :company => {
                :id => '/companies/1',
                :links => [
                    link('company_info', 'GET', '/companies/1.json')
                ]
            }
        }
      end
    end
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params[:product]
  end
end
