#encoding: utf-8
#!/usr/bin/env ruby
require 'rubygems'
require 'net/http'
require 'json/pure'

class CountHashTags
  def initialize
    @twittes = []
  end

  def count(hashtag)
    call "http://search.twitter.com/search.json?rpp=100&q=%23#{hashtag}"
    puts "Quantidade de Twittes: #{@twittes.size}\n\n"
  end

  def call(url)
    return false unless url
    begin
      req = Net::HTTP.get_response(URI.parse(url))
      res = JSON.parse(req.body)
    rescue JSON::ParserError => e
      raise "Dados corrompidos. Problemas para tratar o JSON. Tente novamente!"
    rescue => e
      raise "Problema para obter os dados do Twitter."
    else
      if res["results"]
        res["results"].each { |r| @twittes << r }
        if res["next_page"]
          call("http://search.twitter.com/search.json#{res["next_page"]}")
        end
      end
    end
  end
end

sorteio = CountHashTags.new
sorteio.count("queremCalarOPovo")
