def make_dict(data)
  # dataは[読み、単語]の配列
  hash = {}
  data.each do |entry|
    hash[entry[0]] = [] unless hash.has_key?(entry[0])
    hash[entry[0]] << entry[1]
  end
  dict = hash.to_a.sort_by{|a| a[0]}
end

def escape(str, escape: :concat)
  if escape == :concat
    escaped_str = str.gsub(/[\\\/;]/, { "\\" => "\\\\", "/" => "\\057", ";" => "\\073" })
    escaped_str == str ? str : "(concat \"#{escaped_str}\")"
  elsif escape == :omit
    # 単純にエントリを削除する
    str.match?(/[\/;]/) ? "" : str
  elsif escape == :zenkaku
    # 妥協して全角に置換する
    # バックスラッシュが含まれる場合セットで\ｼﾞｬｰﾝ/みたいな表現であることがほぼ100%確実なので、そちらも全角に置換する
    str.match?(/[\/;]/) ? str.gsub(/[\\\/;]/, { "\\" => "＼", "/" => "／", ";" => "；" }) : str
  end
end

def normalize(str)
  str.gsub("ゔ", "う゛")
end

def output_dict(io, dict, escape_mode: :concat)
  io.puts(";;; -*- coding: utf-8 -*-")
  io.puts(";; okuri-ari entries.")
  io.puts(";; okuri-nasi entries.")
  dict.each do |entry|
    io.puts "#{normalize(entry[0])} /#{entry[1].map {|word| escape(word, escape: escape_mode) }.tap{_1.delete("")}.uniq.join("/")}/"
  end
end

data = []

File.foreach('dic-nico-intersection-pixiv.txt') do |line|
  next if line.start_with?("#")
  next if line.chomp.empty?
  data << line.chomp.split("\t").first(2)
end

dict = make_dict(data)

File.open("dict/SKK-JISYO.nico_pixiv", "w") do |f|
  output_dict(f, dict)
end

File.open("dict/SKK-JISYO.nico_pixiv_omit", "w") do |f|
  output_dict(f, dict, escape_mode: :omit)
end

File.open("dict/SKK-JISYO.nico_pixiv_zenkaku", "w") do |f|
  output_dict(f, dict, escape_mode: :zenkaku)
end

