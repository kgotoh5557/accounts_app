class TkcsController < ApplicationController
  def index
    i = 1
    # file_path = "tkcs-#{Time.zone.now.strftime('%Y%m%d%S')}.slp"
    file_path = Tempfile.new  #Tempfileを使うと、ダウンロード後、ファイルが残らない。

    # 仕訳情報取得
    

    CSV.open(file_path, 'wb', col_sep: "\t") do |csv|
       #売掛金データ作成  
        journal_info_set( Journal.info(params[:id], 1) )
        Account.where(user_id: params[:id]).each do |acco|
          make_file(i,acco.cust_id, acco.amount.to_i, acco.memo, acco.reduced_tax)  
          csv << @buff 
          i += 1
        end

        jour2 = Journal.info(params[:id], 2) # 手数料仕訳
        jour3 = Journal.info(params[:id], 3) # 手形入金仕訳
        jour4 = Journal.info(params[:id], 4) # その他仕訳
        #入金データ作成 [0]:notes_rec [1]:transfer_fee [2]:temporary_pay [3]:memo [4]:account_id [5]:reduced_tax
        Deposit.tkc_export(params[:id]).each do |depo|
          # 関連する売掛金情報を取得する
          acco = Account.find_by(id: depo[4])
          0.upto(2) do |j|
            if depo[j] != 0 && depo[j] != nil
              journal_info_set(Journal.info(params[:id], j + 2  ))
              make_file(i, acco.cust_id, depo[j].to_i, depo[3], depo[5] )
              #make_file(i, acco.cust_id, 10000, depo[3] )
              csv << @buff
              i += 1
            end
          end
        end  
    end
  
    test_arr = ["test" , 999, 20200630]  
    
    flash[:notice] = "ＴＫＣ会計システム取込用仕訳ファイルが作成されました。"
    redirect_to("/")

    send_file file_path , filename: "tkcs-#{Time.zone.now.strftime('%Y%m%d%S')}.slp"

   

  end

  def make_file(i, cust_cd, amount, memo, reduced_tax)  
    @buff = []
    @buff << @involve_cd  # 関与先コード
    @buff << "999" # データ作成システム区分
    @buff << i # レコード番号
    @buff << "20190301"  # 取引年月日
    @buff << 0  # 伝票番号
    @buff << nil #　証憑書番号
    @buff << @tax_type  #  課税区分
    @buff << nil # 事業区分
    @buff << @debit_cd # 借方科目コード
    @buff << @debit_supple # 借方補助コード
    @buff << @credit_cd # 貸方科目コード
    @buff << @credit_supple # 貸方補助コード
    @buff << nil  #　小切手番号
    @buff << 0    #  Filler
    @buff << amount  # 金額
    
    if @tax_type == 0
      @buff << 0      # 消費税額 
      @buff << 0      # 税額入力区分
    else
      if reduced_tax == 1
        @buff << (amount * 8 / 108).to_i    # 消費税額（軽減税率）
      else
        @buff << (amount * 10 / 110).to_i    # 消費税額（標準税率）
      end
      @buff << 1      # 税額入力区分
    end 
    if reduced_tax == 1
      @buff << 800   # 消費税率（軽減税率）
    else
      @buff << 1000  # 消費税率（標準税率）
    end
    
    @buff << cust_cd  # 取引先コード
    cust = Customer.find_by(id: cust_cd)

    @buff << cust.cust_name  # 取引先名
    @buff << 0    # 実際の仕入れ日入力パターン
    @buff << 0    # 実際の仕入れ開始年月日
    @buff << 0    # 実際の仕入れ終了日
    @buff << memo # 備考
    @buff << nil  # Filler
    @buff << 0    # 資金大区分
    @buff << 0    # 資金小区分
    @buff << nil  # 部門コード
    @buff << nil  # 部門数
    @buff << 0    # 部門金額入力区分
    @buff << 0    # Filler
    @buff << 0    # 自動仕訳番号
    @buff << 0    # 支払予定日
    @buff << 0    # 回収予定日

  end

  def journal_info_set(jour)
    @involve_cd = jour.involve_cd
    @tax_type = jour.tax_type
    @debit_cd = jour.debit_cd
    @debit_supple = jour.debit_supple
    @credit_cd = jour.credit_cd
    @credit_supple = jour.credit_supple
  end

end
