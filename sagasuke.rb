
require 'nokogiri'
require 'open-uri'
require 'csv'


# urls = %w(
#   http://qiita.com/search?q=ruby,
#   http://qiita.com/search?q=php,
#   http://qiita.com/search?q=swift
# )
# https://www.ekiten.jp/cat_seitai/chiba/
# index_p2.html

# /chiba /tokyo /kanagawa バージョンも作成する。


PAGE_LAST_INDEX = 50

range = 1..PAGE_LAST_INDEX

index = 1

# イテレーション方法 A. マジックナンバー50を使う。 B. 全◯◯件という数字を取得して、回す。
# 実装方法 Bで進めていく。

range.each { |val|

  p val


  
}

def scrape_store_url(index)

  base_url = "https://www.ekiten.jp"
  total_data = []
  charset = nil

  url = "https://www.ekiten.jp/cat_seitai/chiba/index_p#{index}.html"

  html = open(url) do |f|
    charset = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)

  doc.css('.box_head_title_body').each_with_index do |node, i|
    store_data = []

    # 店の名前を取得
    store_name = node.content.gsub(/(\t|\s|\n|\r|\f|\v)/,"")

    # 店の住所を取得
    store_address = doc.css('.fa-map-marker + span')[i].content

    # 店のリンクを取得
    store_url = doc.css('.box_head_title_body > a')[i][:href]
    store_tel_url = base_url + store_url + 'tel/'
    p store_tel_url

    # 店のtelを取得
    store_tel_html = open(store_tel_url) do |f|
      charset = f.charset
      f.read
    end

    tel_doc = Nokogiri::HTML.parse(store_tel_html, nil, charset)
    store_tel_number = tel_doc.css('.emphasis_text05')[0].content.gsub(/(\t|\s|\n|\r|\f|\v)/,"")

    p store_tel_number

    store_data.push(store_tel_number)
    store_data.push(store_name)
    store_data.push(store_address)
    total_data.push(store_data)
  end

  puts total_data

end

p scrape_store_url(index)
index += 1
p scrape_store_url(index)


# やりたい事は、全ページ取得後に、index_p[n]に移行する。

# eife
