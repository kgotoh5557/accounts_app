class CustomersController < ApplicationController
  def index
  end



  def new
    
  end

  def create
    @customer=Customer.new
    @customer.cust_code = params[:customer_cd]
    @customer.cust_name = params[:customer_name]
    @customer.user_id = current_user.id
    if  @customer.save
      flash[:notice]="得意先が登録されました"
      redirect_to("/customers/#{current_user.id}/new")
    else
      render("customers/new")
    end
  end

  def show
    @customers = Customer.where(user_id: current_user.id)
  end

  def edit
    @customer=Customer.find_by(id: params[:cust])
  end

  def update
    @customer=Customer.find_by(id: params[:cust] )
    @customer.cust_code = params[:customer_cd]
    @customer.cust_name = params[:customer_name]
    if  @customer.save
      flash[:notice]="得意先が更新されました"
      redirect_to("/customers/#{current_user.id}/#{@customer.id}/edit")
    else
      render("customers/edit")
    end
  end

end
