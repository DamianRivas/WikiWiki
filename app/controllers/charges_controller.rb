class ChargesController < ApplicationController
  before_action :authenticate_user!
  
  def new
    authorize :charge, :new?
    
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "WikiWiki Premium - #{current_user.email}",
      amount: Amount.default
    }
  end
  
  def create
    # Creates a Stripe Customer object, for associating with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )
      
    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: Amount.default,
      description: "WikiWiki Premium - #{current_user.email}",
      currency: 'usd'
    )
    
    current_user.premium!
    flash[:notice] = "Thank you for upgrading to premium!"
    redirect_to edit_user_registration_path
    
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_charge_path
  end
end
