class TimetablesController < ApplicationController
  def index
    @custs = Customer.where(user_id: current_user.id)  
  end

  def index_1

    @sales_flg = 1 
    common_proc
   
  end    

  def index_deposit
    @custs = Customer.where(user_id: current_user.id)  
  end

  def index_2

    @sales_flg = 2
    common_proc
    
  end

  def common_proc
    @cust = Customer.find_by(id: params[:cust_id])
    if @cust == nil
      flash[:notice] = "検索できません"
    end
    @fiscal = Fiscal.find_by(user_id: current_user.id)

    require "date"
    s1 = @fiscal.fiscal_year
    s = Date.new(params[:year].to_i, s1.month, 1)

    
    @yyyymm = []
    @amount = []
    @deposit_amount =[]
    @transfer_fee =[]
    @notes_rec =[]
    @temporary_pay =[]
    @deposit_total=[] 


    #会計年度以前
    conditions = Account.arel_table
    @accounts_last = Account.where(conditions[:sales_date].lt(s).
                                and(conditions[:cust_id].eq(@cust.id)))

    conditions = Deposit.arel_table 

    if @sales_flg == 1                           
      @depos_last =Deposit.where(conditions[:sales_date].lt(s).
      and(conditions[:cust_id].eq(@cust.id)))
    else
      @depos_last =Deposit.where(conditions[:payment_date].lt(s).
      and(conditions[:cust_id].eq(@cust.id)))
    end
    

    @yyyymm << "前期繰越"
    @amount  << @accounts_last.sum(:amount)                      
    t_deposit_amount = @depos_last.sum(:deposit_amount)  
    t_transfer_fee = @depos_last.sum(:transfer_fee) 
    t_notes_rec = @depos_last.sum(:notes_rec) 
    t_temporary_pay = @depos_last.sum(:temporary_pay) 

                        
    @deposit_amount << t_deposit_amount
    @transfer_fee << t_transfer_fee
    @notes_rec << t_notes_rec
    @temporary_pay << t_temporary_pay
    @deposit_total << t_deposit_amount + t_transfer_fee + t_notes_rec + t_temporary_pay

    #会計期間
    
    @s = Date.new(params[:year].to_i, s1.month, 1)
    @e = Date.new(params[:year].to_i, @fiscal.fiscal_year.month, -1)
    
    

    12.times do |i|
      @yyyymm << @e

      @accounts= Account.where(sales_date: @s..@e,cust_id: @cust.id )

      if @sales_flg == 1                         
        @depos =Deposit.where(sales_date: @s..@e,cust_id: @cust.id )
      else
        @depos =Deposit.where(payment_date: @s..@e,cust_id: @cust.id )
      end

                          
      t_deposit_amount = @depos.sum(:deposit_amount)  
      t_transfer_fee = @depos.sum(:transfer_fee) 
      t_notes_rec = @depos.sum(:notes_rec) 
      t_temporary_pay = @depos.sum(:temporary_pay)   

      @amount << @accounts.sum(:amount) 

      @deposit_amount << t_deposit_amount  
      @transfer_fee << t_transfer_fee
      @notes_rec << t_notes_rec
      @temporary_pay << t_temporary_pay 

      @deposit_total << t_deposit_amount + t_transfer_fee + t_notes_rec + t_temporary_pay
      @s = @s.since(1.month)
      @e = Date.new(@s.year, @s.month, -1)

    end

  end


end
