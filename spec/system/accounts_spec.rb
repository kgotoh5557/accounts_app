require 'rails_helper'

describe '売掛金管理', type: :system do
    describe '一覧表示機能' do
        before do
            #ユーザーAを作成しておく
            user_a = FactoryBot.create(:user)
            user_a.confirm
            visit root_path
                click_on 'ログイン'
                fill_in 'メールアドレス', with: user_a.email
                fill_in 'パスワード', with: user_a.password
                click_button 'ログイン'

                
            #作成者がユーザーＡである売掛データを作成しておく                
                customer = FactoryBot.create(:customer )
                account = FactoryBot.create(:account, user_id: 1)
                visit "/accounts/#{user_a.id}/index_select"
        end
        context 'ユーザーＡがログインしている時' do
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
            end
        end
        context 'ユーザーＡがログインしている時' do
            before do
               
               visit 'accounts/2/index_select'               
               
            end
            it '他のユーザーのビューを表示出来ない' do
                expect(page).to have_content '権限がありません'
               
            end
        end

        context 'ユーザーＡがログアウトする時' do
            before do
               click_on 'ログアウト'

            end
            it '他のユーザーのビューを表示出来ない' do
                expect(page).to have_content 'ログイン'
               
            end
        end

        
        context 'ユーザーＢがログインする。' do
            before do
                click_on 'ログアウト' #ユーザーＡ　ログアウト

                user_b = FactoryBot.create(:user, id: '2', email: 'test2@example.com', password: 'p@ssword')
                user_b.confirm
    
                visit root_path
                visit 'users/sign_in'
    
                #click_on 'ログイン'
                fill_in 'メールアドレス', with: user_b.email
                fill_in 'パスワード', with: user_b.password
                click_button 'ログイン'
    
                customer_b = FactoryBot.create(:customer, id: 2, cust_name: 'test_customer2', cust_code: 2 )
    
                visit "/accounts/#{user_b.id}/index_select"
            end

            it 'ユーザーＡの作成したデータが表示されない。' do
                expect(page).to have_content '売掛金関連'
                expect(page).to have_content 'test2@example.com'
            end

        end


    end
end 