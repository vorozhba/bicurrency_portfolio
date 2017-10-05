class CbRate
  def initialize(url)
    begin
      response = Net::HTTP.get_response(URI.parse(url))
      if response.code != '200'
        puts "Ошибка сервера www.cbr.ru. Код ответа: #{response.code}"
        exit
      end
    rescue SocketError => error
      raise error.message
    end
    @doc = REXML::Document.new(response.body)
  end

  def to_f
    exch_rate = usd_rate.gsub(',', '.').to_f
  end

  def usd_rate
    cb_rate = ""
    @doc.root.each_element_with_attribute('ID', 'R01235') do |rate|
      cb_rate = rate.get_text('Value').to_s
    end
    cb_rate
  end
end
