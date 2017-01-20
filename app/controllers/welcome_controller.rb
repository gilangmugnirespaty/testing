class WelcomeController < ApplicationController
  def index
    @products = Product.all
  end

  def index2
    @products = Product.all
  end

  def index3
    @products = Product.all
  end
end
