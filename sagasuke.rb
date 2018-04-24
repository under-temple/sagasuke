
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'rubyXL'


# urls = %w(
#   http://qiita.com/search?q=ruby,
#   http://qiita.com/search?q=php,
#   http://qiita.com/search?q=swift
# )
# https://www.ekiten.jp/cat_seitai/chiba/

# /chiba /tokyo /kanagawa バージョンも作成する。

class FetchStoreData

  # ワークシートの作成
  @@workbook = RubyXL::Workbook.new
  @@worksheet = @@workbook[0]
  @@worksheet.sheet_name = 'SearchedStoreData'
  @PAGE_LAST_INDEX = 1

  def initialize(index = 50)
    @PAGE_LAST_INDEX = index
  end

  # TODO: 全◯◯件表示の部分から数値を取得する方法に変更する。

  def scrape_store_url()

    @PAGE_LAST_INDEX.times { |i|

      puts "#{i}回目のクローリング"
      base_url = "https://www.ekiten.jp"
      total_data = []
      charset = nil

      # ここで、カテゴリを選択する。
      url = "https://www.ekiten.jp/cat_seitai/chiba/index_p#{i + 1}.html"

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

        store_data.push(store_tel_number)
        store_data.push(store_name)
        store_data.push(store_address)
        total_data.push(store_data)
      end

      puts total_data

      # EXCELにデータを保存する
      # total_dataの要素数が20で止まってしまっている。
      total_data.each_with_index { |store_data, row|

        p store_data[0]
        p store_data[2]
        p row

        # @@worksheet.add_cell(row, 0, store_data[0])
        # @@worksheet.add_cell(row, 1, store_data[1])
        # @@worksheet.add_cell(row, 2, store_data[2])
      }
    }



    @@worksheet.add_cell(row, 0, store_data[0])
    @@worksheet.add_cell(row, 1, store_data[1])
    @@worksheet.add_cell(row, 2, store_data[2])
    @@workbook.write('test_store_data.xlsx')
  end
end

# @@PAGE_LAST_INDEX = 50
# @@page_range = 1..PAGE_LAST_INDEX

fetchData = FetchStoreData.new(3)
fetchData.scrape_store_url()


# page_range.each { |index|
#   p fetchData.scrape_store_url(index)
# }


# やりたい事は、全ページ取得後に、index_p[n]に移行する。

# eife
