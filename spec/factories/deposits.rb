FactoryBot.define do 
    factory :deposit do
        cust_id {1}
        payment_date {'2020-05-01'}
        user_id {1}
        account_id {1}
    end
end        