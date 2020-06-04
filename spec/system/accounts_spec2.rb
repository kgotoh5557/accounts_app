require 'rails_helper'

describe '売掛金管理', type: :system do
    #ログインを共通化
    let(:user_a){FactoryBot.create(:user)}
    let(:user_b){FactoryBot.create(:user, id: '2', email: 'test2@example.com', password: 'p@ssword')}

    before do
        #ユーザーAを作成しておく #ログインを共通化
        login_user.confirm #deviseは、メール認証している場合、これが無いとログイン出来ない。

        visit root_path
            click_on 'ログイン'
            fill_in 'メールアドレス', with: login_user.email
            fill_in 'パスワード', with: login_user.password
            click_button 'ログイン'
         
        #テストデータを作成しておく                
            customer_a = FactoryBot.create(:customer, id: 1 )
            customer_b = FactoryBot.create(:customer, user_id: 2, cust_name: 'test_customer2', id: 2 )
            customer_a2 = FactoryBot.create(:customer, user_id: 1, cust_name: 'test_customerA2', id: 12 )
                 
           
            account = FactoryBot.create(:account, user_id: 1, id: 1)
            account2 = FactoryBot.create(:account, user_id: 1, amount: 12346, id: 2)
            account3 = FactoryBot.create(:account, user_id: 2, amount: 777, cust_id: 2, id: 3)
            account12 = FactoryBot.create(:account, user_id: 1, amount: 999999, cust_id: 12, id: 4)


            deposit1 = FactoryBot.create(:deposit, deposit_amount:1001, notes_rec:10001, transfer_fee:100011, temporary_pay:1001000 )
            deposit2 = FactoryBot.create(:deposit, deposit_amount:1002, notes_rec:10002, transfer_fee:100012, temporary_pay:1002000 )
            deposit3 = FactoryBot.create(:deposit, deposit_amount:1003, notes_rec:10003, transfer_fee:100013, temporary_pay:1003000 )
            deposit4 = FactoryBot.create(:deposit, deposit_amount:1004, notes_rec:10004, transfer_fee:100014, temporary_pay:1004000, account_id:2 )
            deposit5 = FactoryBot.create(:deposit, deposit_amount:3001, notes_rec:30001, transfer_fee:300011, temporary_pay:3001000, account_id:3 )
            deposit6 = FactoryBot.create(:deposit, deposit_amount:3002, notes_rec:30002, transfer_fee:300012, temporary_pay:3002000, account_id:3, user_id:2 )

    end

    describe '売掛金入力' do
        before do
            visit "/accounts/#{login_user.id}/new"
        end
        context '売掛金入力画面を表示' do
            let(:login_user){ user_a } 
            before do
              
            end
            it '売掛金入力画面が表示される' do
                expect(page).to have_content '売掛金入力画面'               
            end
        end
        context '売掛金を入力する' do
            let(:login_user){ user_a } 
            before do
                fill_in 'amount', with: '12345'
                fill_in 'memo', with: 'test comment'
                click_button '登録'
            end
            it '売掛金が登録される' do
                expect(page).to have_content '登録されました'               
            end
        end
        context '売掛金を入力する。金額がない。' do
            let(:login_user){ user_a } 
            before do
                fill_in 'memo', with: 'test comment'
                click_button '登録'
            end
            it '売掛金が登録されない' do
                expect(page).not_to have_content '登録されました'  
                expect(page).to have_content '金額を入力してください'              
            end
        end
        context '他人のビューを表示する。' do
            let(:login_user){ user_a } 
            before do
                visit "/accounts/100/new"
            end
            it '表示されない' do
                expect(page).to have_content '権限がありません'
            end
        end

    end


    describe '得意先明細機能' do
        before do
            visit "/accounts/#{login_user.id}/index_select"
        end
        context 'ユーザーＡがログインしている時' do
            let(:login_user){ user_a } 
            before do
               
               #visit 'accounts/1/index_select'               
               click_button '検索'
               #click_on 'ログアウト'
            end
            it 'ユーザーＡが作成した売掛金が表示される' do
                expect(page).to have_content '売掛金関連'
                #expect(page).to have_content '売掛金入力画面'
                expect(page).to have_content '取引先別売掛金明細'
                expect(page).to have_content '回収状況'
                expect(page).to have_content '12,345'
                expect(page).to have_content '24,691' #売掛金合計
                expect(page).to have_content '4,010' #振込金額合計
                expect(page).to have_content '40,010' #手形金額合計
                expect(page).to have_content '400,050' #手数料金額合
                expect(page).to have_content '4,010,000' #手数料金額合

            end
        end
        context 'ユーザーＡがログインしている時（範囲検索）' do
            let(:login_user){ user_a } 
            before do
               
               #visit 'accounts/1/index_select'  
               click_on '範囲検索'             
               click_button '検索'
               #click_on 'ログアウト'
            end
            it 'ユーザーＡが作成した売掛金が表示される' do
                expect(page).to have_content '売掛金関連'
                #expect(page).to have_content '売掛金入力画面'
                expect(page).to have_content '取引先別売掛金明細'
                expect(page).to have_content '回収状況'
                expect(page).to have_content '12,345'
                expect(page).to have_content '24,691' #売掛金合計
                expect(page).to have_content '4,010' #振込金額合計
                expect(page).to have_content '40,010' #手形金額合計
                expect(page).to have_content '400,050' #手数料金額合
                expect(page).to have_content '4,010,000' #手数料金額合

            end
        end
        context 'ユーザーＡがログインしている時（得意先切り替え）' do
            let(:login_user){ user_a } 
            before do
               
               #visit 'accounts/1/index_select'  
               select "test_customerA2" , from: "cust_id"          
               click_button '検索'
               #click_on 'ログアウト'
            end
            it 'ユーザーＡが作成した売掛金が表示される' do

                expect(page).to have_content '売掛金関連'
                #expect(page).to have_content '売掛金入力画面'
                expect(page).to have_content '取引先別売掛金明細'
                expect(page).to have_content '回収状況'
                expect(page).to have_content '999,999'
                #expect(page).to have_content '24,691' #売掛金合計
                #expect(page).to have_content '4,010' #振込金額合計
                #expect(page).to have_content '40,010' #手形金額合計
                #expect(page).to have_content '400,050' #手数料金額合
                #expect(page).to have_content '4,010,000' #手数料金額合

            end
        end

        context 'ユーザーＡがログインしている時' do
            let(:login_user){ user_a } 
            before do
               
               visit 'accounts/2/index_select'               
               
            end
            it '他のユーザーのビューを表示出来ない' do
                expect(page).to have_content '権限がありません'
               
            end
        end

        context 'ユーザーＡがログアウトする時' do
            let(:login_user){ user_a } 
            before do
               click_on 'ログアウト'

            end
            it 'ログインする前の状態になる' do
                expect(page).to have_content 'ログイン'
               
            end
        end
        
        context 'ユーザーＢがログインする。' do
            let(:login_user){ user_b } 
            before do
                click_button '検索'
            end

            it 'ユーザーＡの作成したデータが表示されない。' do
                expect(page).to have_content '売掛金関連'
                expect(page).to have_content 'test2@example.com'
                expect(page).to have_content '取引先別売掛金明細'
                expect(page).not_to have_content '12,345'
                expect(page).to have_content '777'
                expect(page).to have_content '6,003'
                expect(page).to have_content '60,003'
                expect(page).to have_content '600,023'
                expect(page).to have_content '6,003,000'

            end

        end


    end


    describe '得意先合計機能' do
        before do
            visit "/accounts/#{login_user.id}/index_select_summary"
        end
        context 'ユーザーＡがログインしている時' do
            let(:login_user){ user_a } 
            before do
               #click_button '検索'
            end
            it '取引先合計画面が表示される' do
                #expect(page).to have_content '回収状況'
                expect(page).to have_content '全取引先売掛金合計'
            end
        end
        context 'ユーザーＡがログインしている時' do
            let(:login_user){ user_a } 
            before do
                click_button '検索'
            end
            it '取引先合計画面が表示される' do
                expect(page).to have_content '全取引先売掛金合計'
                expect(page).to have_content '24,691'
                expect(page).to have_content '999,999'
                expect(page).to have_content '1,024,690'
                expect(page).to have_content '24,691' #売掛金合計
                expect(page).to have_content '4,010' #振込金額合計
                expect(page).to have_content '40,010' #手形金額合計
                expect(page).to have_content '400,050' #手数料金額合
                expect(page).to have_content '4,010,000' #手数料金額合

            end

        end
        context 'ユーザーＡがログインしている時' do
            let(:login_user){ user_a } 
   
            before do                    
                visit "/accounts/100/index_select_summary"
            end
            it '他人のビューは表示されない' do
                expect(page).to have_content '権限がありません'
            end
        end
        context 'ユーザーＢがログインしている時' do
            let(:login_user){ user_b } 
   
            before do                    
                click_button '検索'
            end
            it 'ユーザーＢのデータが表示される' do
                expect(page).to have_content '全取引先売掛金合計'
                expect(page).not_to have_content '12,345'
                expect(page).to have_content '777'
                expect(page).to have_content '6,003'
                expect(page).to have_content '60,003'
                expect(page).to have_content '600,023'
                expect(page).to have_content '6,003,000'
            end
        end
    end

end 