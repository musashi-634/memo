require "csv" # CSVファイルを扱うためのライブラリを読み込み

p "1 → 新規でメモを作成する / 2 → 既存のメモを編集する"
memo_type = gets.to_i # ユーザーの入力値を取得し、数字へ変換
puts ""

case memo_type
when 1  # 新規作成する場合
  # ファイル名の入力
  p "拡張子を除いたファイル名を入力してください"
  file_name = gets.chomp + ".csv"
  puts ""
  
  # 同名ファイルの検索
  Dir.glob(file_name) do
    puts "同名のcsvファイルが存在します"
    exit
  end
  
  # メモに記載する内容の入力
  p "メモしたい内容を入力してください"
  p "完了したら「Ctrl + D」を入力してください"
  CSV.open(file_name, "w", :quote_char => "") do |file|
    input = readlines.map(&:chomp)
    for i in 0...input.length do
      file << [input[i]]
    end
  end
  
when 2  # 既存のメモを編集する場合
  # 既存ファイル名のリストの出力
  files = []
  begin
    Dir.glob("*.csv") do |file|
      files.push(file)
    end
    
    if files == []  # csvファイルがなかった場合
      p "既存のcsvファイルはありません"
      exit
    else
      p "既存のcsvファイル一覧は次の通りです"
      p files
      puts ""
    end
  rescue
    p "csvファイル一覧の取得に失敗しました"
  end
  
  # 編集するファイルの選択
  p "編集したいファイルの名称を、拡張子を除いて入力してください"
  file_name = gets.chomp + ".csv"
  puts ""
  
  # ファイルの検索
  have_file = false
  Dir.glob(file_name) do
    have_file = true
  end
    
  if have_file  # 指定したファイルがある場合
    # メモの内容の表示
    p "メモの内容は以下の通りです"
    CSV.foreach(file_name, col_sep: "¥n") do |row|
      puts row
    end
    puts ""
    
    # メモに追記する内容の入力
    p "追記したい内容を入力してください"
    p "完了したら「Ctrl + D」を入力してください"
    CSV.open(file_name, "a", :quote_char => "") do |file|
      input = readlines.map(&:chomp)
      for i in 0...input.length do
        file << [input[i]]
      end
    end
    
  else  # 指定したファイルがない場合
    p "指定したcsvファイルは存在しません"
  end
  
else  # 1と2以外が入力された場合
  puts "1または2を選択してください"
end