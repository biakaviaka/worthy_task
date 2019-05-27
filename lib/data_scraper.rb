module DataScraper
  require 'net/http'
  require 'open-uri'


  DIAMONDS_TYPE = 4
  ATTRIBUTES = ["Shape", "Carat Weight", "Color", "Clarity", "Price"]
  DB_NAME = "db/worthy"

  def collect_recent_deals
    next_page = 1

    while (next_page && next_page < 100) do
      # get recent deals data
      parsed_data = []
      url = "https://www.worthy.com/api/recentdeals?page=#{next_page}&item_type=#{DIAMONDS_TYPE}"
      json_data = scrape_json_data(url)

      json_data["data"].each do |diamond|
        # go to item deal url and scrape required attributes
        deal_xml = Nokogiri::XML(open(diamond["get_deal"]["item_deal_url"]))
        diamond_data = Hash[ATTRIBUTES.collect { |item| [item.downcase.gsub(" ", "_"), nil] } ]

        attributes_table = deal_xml.at('table.normalLineHeight')
        attributes_table.search('tr').each do |tr|
          attributes_cells = tr.search('td')
          attribute_name = attributes_cells[0].text.gsub(':', '').strip

          if(ATTRIBUTES.include? attribute_name)
            attribute_value = attributes_cells[1].text.gsub(':', '').strip
            diamond_data[attribute_name.downcase.gsub(" ", "_")] = attribute_value
          end
        end
        diamond_data['price'] = deal_xml.css('div.evaluationSell').text.tr("$,\n", "")

        parsed_data << diamond_data
      end
      fill_db parsed_data
      next_page = json_data["next"]
    end
  end

  def scrape_json_data(url)
    begin
      response = Net::HTTP.get(URI.parse(url))
      JSON.parse(response)
    rescue => ex
      puts ex.message
    end
  end

  def fill_db (dataset)
    begin
      db = SQLite3::Database.open DB_NAME

      values_for_insert = dataset.map{ |set| "(#{set.values.map{|value| "'#{value}'"}.join(',')})" }.join(",")
      query = "INSERT INTO recent_deals (#{ATTRIBUTES.collect { |item| item.downcase.gsub(" ", "_") }.join(',')}) VALUES #{values_for_insert}"
      db.execute query
    rescue SQLite3::Exception => e
      puts "Exception occurred "
      puts e
    ensure
      db.close if db
    end
  end
end