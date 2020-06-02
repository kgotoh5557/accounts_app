class DepositsController < ApplicationController

  def index_select
    @custs = Customer.where(user_id: current_user.id)  
  end

  def index

    @sales_year = params[:year]
    @sales_month = params[:month]

    s = Date.new(params[:year].to_i, params[:month].to_i, 1)
    e = Date.new(params[:year].to_i, params[:month].to_i, -1)

    @accounts = Account.where(cust_id: params[:cust_id] , sales_date: s..e).order(sales_date: :desc)
    @cust = Customer.find_by(id: params[:cust_id])
    
  end

  def index_select2
    @custs = Customer.where(user_id: current_user.id)  
  end

  def index2

    @sales_year = params[:year]
    @sales_month = params[:month]
    @sales_year2 = params[:year2]
    @sales_month2 = params[:month2]

    s = Date.new(params[:year].to_i, params[:month].to_i, 1)
    e = Date.new(params[:year2].to_i, params[:month2].to_i, -1)

    @accounts = Account.where(cust_id: params[:cust_id] , sales_date: s..e).order(sales_date: :desc)
    @cust = Customer.find_by(id: params[:cust_id])
    
  end

  def index_select_payment
    @custs = Customer.where(user_id: current_user.id)  
  end

  def index_payment
    @sales_year = params[:year]
    @sales_month = params[:month]
        
    s = Date.new(params[:year].to_i, params[:month].to_i, 1)
    e = Date.new(params[:year].to_i, params[:month].to_i, -1)
    @depos = Deposit.where(cust_id: params[:cust_id] , payment_date: s..e)
    @cust = Customer.find_by(id: params[:cust_id])
    
  end

  def index_select_payment2
    @custs = Customer.where(user_id: current_user.id)  
  end

  def index_payment2
    @sales_year = params[:year]
    @sales_month = params[:month]
    @sales_year2 = params[:year2]
    @sales_month2 = params[:month2]
    
    s = Date.new(params[:year].to_i, params[:month].to_i, 1)
    e = Date.new(params[:year2].to_i, params[:month2].to_i, -1)
    @depos = Deposit.where(cust_id: params[:cust_id] , payment_date: s..e)
    @cust = Customer.find_by(id: params[:cust_id])
    
  end

  def index_select_sales
    @custs = Customer.where(user_id: current_user.id)  
  end

  def index_sales  

    @sales_year = params[:year]
    @sales_month = params[:month]
    
    s = Date.new(params[:year].to_i, params[:month].to_i, 1)
    e = Date.new(params[:year].to_i, params[:month].to_i, -1)

    @depos = Deposit.where(cust_id: params[:cust_id] , sales_date: s..e)
    @cust = Customer.find_by(id: params[:cust_id])


    #@accos=Account.where(cust_id: params[:cust_id] ,sales_date: s..e)
    #@cust = Customer.find_by(id: params[:cust_id])
    
  end

  def index_select_sales2
    @custs = Customer.where(user_id: current_user.id)  
  end

  def index_sales2  

    @sales_year = params[:year]
    @sales_month = params[:month]
    @sales_year2 = params[:year2]
    @sales_month2 = params[:month2]
    
    s = Date.new(params[:year].to_i, params[:month].to_i, 1)
    e = Date.new(params[:year2].to_i, params[:month2].to_i, -1)

    @depos = Deposit.where(cust_id: params[:cust_id] , sales_date: s..e)
    @cust = Customer.find_by(id: params[:cust_id])


    #@accos=Account.where(cust_id: params[:cust_id] ,sales_date: s..e)
    #@cust = Customer.find_by(id: params[:cust_id])
    
  end
  def show
      @acco = Account.find_by(id: params[:account_id] )
      @cust = Customer.find_by(id: @acco.cust_id)
      @depos = Deposit.where(account_id: @acco.id)

      # 対応する入金情報を読み取る
      @deposit_amount = 0
      @transfer_fee = 0
      @notes_rec = 0
      @temporary_pay = 0         
      @depos.each do |depo|
        if depo.deposit_amount != nil
         @deposit_amount += depo.deposit_amount 
        end
        if depo.transfer_fee != nil
         @transfer_fee += depo.transfer_fee
        end
        if depo.notes_rec != nil
         @notes_rec += depo.notes_rec
        end
        if depo.temporary_pay != nil
         @temporary_pay += depo.temporary_pay 
        end        
      end  
      
  end

  def create
    require "date"

    @acco = Account.find_by(id: params[:account_id] )
    @cust = Customer.find_by(id: @acco.cust_id)

    deposit=Deposit.new
    deposit.cust_id = @cust.id
    deposit.payment_date = Date.new( params[:year].to_i, params[:month].to_i, params[:day].to_i)
    deposit.deposit_amount = params[:deposit_amount]
    deposit.transfer_fee = params[:transfer_fee]
    deposit.notes_rec = params[:notes_rec]
    deposit.temporary_pay = params[:temporary_pay]
    deposit.account_id = params[:account_id]
    deposit.user_id = current_user.id
    deposit.sales_date = @acco.sales_date
    deposit.memo = params[:memo]

    if deposit.save

      flash[:notice] = "#{@cust.cust_name}の入金が登録されました。"
      redirect_to("/")
    end
  end

end
