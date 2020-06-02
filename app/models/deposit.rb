class Deposit < ApplicationRecord
    # self.primary_key='account_id'
    # belongs_to:accounts, :foreign_key=>'id'


    def sum(accounts, cust)
        
        custs=[]
        sales_dates=[]
        amounts=[]
        deposit_amounts=[]
        transfers=[]
        notes=[]
        temporarys=[]
        total_deposits=[]

        total_1=0
        total_2=0
        total_3=0
        total_4=0
        total_5=0
        total_h=0

        accounts.each do |account|
        custs << cust.cust_name
        sales_dates << account.sales_date
        amounts << account.amount
        deposits=Deposit.where(account_id: account.id)

        deposit_amount = 0
        transfer_fee = 0
        notes_rec = 0
        temporary_pay = 0
        total_deposit = 0

        deposits.each do |depo|
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
        deposit_amounts << deposit_amount
        transfers << transfer_fee
        notes << notes_rec
        temporarys << temporary_pay
        total_deposits << total_deposit

        if account.amount != nil
            total_1 += account.amount
        end
        
        end
        custs << "※※※"
        amounts << total_1    
        deposit_amounts << total_2
        transfers << total_3
        notes << total_4
        temporarys << total_5
        total_deposits << total_h

        return custs, sales_dates, amounts, deposit_amounts, transfers, 
        notes, temporarys, total_deposits

        
    end    
end
