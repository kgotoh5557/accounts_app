class AccountsController < ApplicationController
  before_action :ensure_corrent_user

  def index
   
   @sales_year = params[:year]
   @sales_month = params[:month]
   @cust_id= params[:cust_id]

   @accounts = Account.new.single_month(@sales_year, @sales_month, @cust_id)
   @cust = Customer.find_by(id: params[:cust_id])

   common_proc1
    
  end

  def index_select
    @custs = Customer.where(user_id: current_user.id)  
  end
  
  def index2
    require "date"

    @sales_year = params[:year]
    @sales_month = params[:month]
    @sales_year2 = params[:year2]
    @sales_month2 = params[:month2]

    s = Date.new(params[:year].to_i, params[:month].to_i,1) #月初
    e = Date.new(params[:year2].to_i, params[:month2].to_i,-1) #月末

    # @sales_day = params[:day]
    @accounts = Account.where(cust_id: params[:cust_id] ,sales_date: s..e).order(sales_date: :desc)
    @cust = Customer.find_by(id: params[:cust_id])
    
    common_proc1
    
  end

  def index_select2
    @custs = Customer.where(user_id: current_user.id)  
  end 

  def new
    #売掛金入力画面表示
    @custs = Customer.where(user_id: params[:id])   
    @account =Account.new #ダミー
  end

  
  def index_select_summary
    #全取引先サマリー　検索月選択画面

  end

  def index_summary
    #全取引先サマリー　画面表示
    @sales_year = params[:year]
    @sales_month = params[:month]    
    s = Date.new(params[:year].to_i, params[:month].to_i,1) #月初
    e = Date.new(params[:year].to_i, params[:month].to_i,-1) #月末

    @cust_code, @cust_name, @cust_sales, @deposit_amounts,
    @transfers, @notes, @temporarys, @total_deposits =
    Account.new.sum_all(s, e, current_user)

  end

  def create
    #売掛金データ登録
    require "date"

    @account=Account.new
    @account.cust_id = params[:cust_id]
    @account.sales_date = Date.new( params[:year].to_i, params[:month].to_i, params[:day].to_i)
    @account.amount = params[:amount]
    @account.user_id = current_user.id
    @account.memo = params[:memo]
    cust=Customer.find_by(id:params[:cust_id])
    
    if @account.save
      flash[:notice] = "#{cust.cust_name}の売上が登録されました。"
      redirect_to("/")
    else
      flash[:notice] = "登録に失敗しました。"
      @custs = Customer.where(user_id: params[:id])  
      render "accounts/new"
    end  

  end

  def common_proc1

    @custs, @sales_dates, @amounts, @deposit_amounts,  @transfers,
    @notes, @temporarys,  @total_deposits =
    Deposit.new.sum(@accounts, @cust)

  end

 def ensure_corrent_user
  if current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません。"
      redirect_to("/")
  end
 end

 def csv_test
     
     send_data Account.generate_csv(params[:id]), filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv"
     
 end

end
