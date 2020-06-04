FactoryBot.define do
  factory :journal do
    user_id { 1 }
    involve_cd { 1 }
    debit_cd { 1 }
    debit_supple { 1 }
    credit_cd { 1 }
    credit_supple { 1 }
    tax_type { 1 }
    journal_type { 1 }
  end
end
