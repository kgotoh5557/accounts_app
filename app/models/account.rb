class Account < ApplicationRecord
    # self.primary_key='id'
    # has_many:deposits,:foreign_key=>'account_id'
    validates :cust_id, {presence: true}
    validates :sales_date, {presence: true}
    validates :amount, {presence: true, numericality: { only_integer: true }}
    validates :user_id, {presence: true}



    def single_month(y, m, c_id)
        require "date"

        s = Date.new(y.to_i, m.to_i,1) #月初
        e = Date.new(y.to_i, m.to_i,-1) #月末
    
        @accunts = Account.where(cust_id: c_id ,sales_date: s..e).order(sales_date: :desc)
        return @accunts
        
    end
    scope :s_d, -> s { where( "sales_date >= ?", s )} 
     
    def sum_all(s, e, current_user)
        #全取引先サマリー　画面表示
        
        t_sales = 0
        sum_sales = 0
        @cust_code=[]
        @cust_name=[]
        @cust_sales=[]

        @deposit_amounts=[]
        @transfers=[]
        @notes=[]
        @temporarys=[]

        @total_deposits=[]

        total_2=0.0
        total_3=0.0
        total_4=0.0
        total_5=0.0
        total_h=0.0

        @custs = Customer.where(user_id: current_user.id).order(:cust_code)
        @custs.each do |cust|
            @cust_code << cust.cust_code
            @cust_name << cust.cust_name
            t_sales = Account.where( cust_id: cust.id, sales_date: s..e).sum(:amount) 
            @cust_sales << t_sales

        
    #------------------------------------------------------ 

            deposit_amount = 0
            transfer_fee = 0
            notes_rec = 0
            temporary_pay = 0
            total_deposit = 0

            #入金情報を取得
            @accounts = Account.where(cust_id: cust.id ,sales_date: s..e)

            @accounts.each do |account|
                
                @deposits=Deposit.where(account_id: account.id)

                @deposits.each do |depo|
                if depo.deposit_amount != nil
                    deposit_amount += depo.deposit_amount 
                    total_deposit += depo.deposit_amount 
                    total_2 += depo.deposit_amount
                    total_h += depo.deposit_amount
                end
                if depo.transfer_fee != nil
                    transfer_fee += depo.transfer_fee
                    total_deposit += depo.transfer_fee
                    total_3 += depo.transfer_fee
                    total_h += depo.transfer_fee
                end
                if depo.notes_rec != nil
                    notes_rec += depo.notes_rec
                    total_deposit += depo.notes_rec
                    total_4 += depo.notes_rec
                    total_h += depo.notes_rec
                end
                if depo.temporary_pay != nil
                    temporary_pay += depo.temporary_pay
                    total_deposit += depo.temporary_pay
                    total_5 += depo.temporary_pay
                    total_h += depo.temporary_pay
                end  
                end
                        
                
            end
            
            @deposit_amounts << deposit_amount
            @transfers << transfer_fee
            @notes << notes_rec
            @temporarys << temporary_pay
            @total_deposits << total_deposit
            
        #------------------------------------------------------
            sum_sales += t_sales
        end
        @cust_code << ""
        @cust_name << "　　　　　総 　合 　計"
        @cust_sales << sum_sales
        @deposit_amounts << total_2
        @transfers << total_3
        @notes << total_4
        @temporarys << total_5
        @total_deposits << total_h

        return @cust_code, @cust_name, @cust_sales, @deposit_amounts,
        @transfers, @notes, @temporarys, @total_deposits


    end

    def self.csv_attributes
        ["cust_id", "sales_date", "amount", "user_id"]
    end

    def self.generate_csv(user_id)
        CSV.generate(headers: true) do |csv|
            csv << csv_attributes
            where(user_id: user_id).each do |task|
                csv << csv_attributes.map{|attr| task.send(attr)}
            end    
        end
    end

    def self.tkc_export(user_id)
        tkc = []
        where(user_id: user_id).each do |acco|
             tkc << [acco.cust_id, acco.amount, acco.memo]
        end
        
        return tkc
    end
end
