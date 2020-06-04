class TkcsController < ApplicationController
  def index
    i = 1
    # file_path = "tkcs-#{Time.zone.now.strftime('%Y%m%d%S')}.slp"
    file_path = Tempfile.new  #Tempfileを使うと、ダウンロード後、ファイルが残らない。

    CSV.open(file_path, 'wb', col_sep: "\t") do |csv|
       #売掛金データ作成   [0]:cust_id [1]:amount [2]:memo
        Account.tkc_export(params[:id]).each do |acco|
          make_file(i,acco[0], acco[1].to_i, acco[2])  
          csv << @buff 
          i += 1
        end
    end
  
    test_arr = ["test" , 999, 20200630]  
    
    flash[:notice] = "ＴＫＣ会計システム取込用仕訳ファイルが作成されました。"
    redirect_to("/")

    send_file file_path , filename: "tkcs-#{Time.zone.now.strftime('%Y%m%d%S')}.slp"

   

  end

  def make_file(i, cust_cd, amount, memo)  
    @buff = []
    @buff << "99"  # 関与先コード
    @buff << "999" # データ作成システム区分
    @buff << i # レコード番号
    @buff << "20200630"  # 取引年月日
    @buff << 0  # 伝票番号
    @buff << nil #　証憑書番号
    @buff << 0  #  課税区分
    @buff << nil # 事業区分
    @buff << "1111" # 借方科目コード
    @buff << "2222" # 借方補助コード
    @buff << "3333" # 貸方科目コード
    @buff << "4444" # 貸方補助コード
    @buff << nil  #　小切手番号
    @buff << 0    #  Filler
    @buff << amount  # 金額
    @buff << 0    # 消費税額
    @buff << cust_cd  # 取引先コード
    @buff << "AAA"  # 取引先名
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

end
