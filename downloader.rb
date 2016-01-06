require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'net/http'
require 'open-uri'
require 'typhoeus'


class Downloader

  def initialize(cast_url = 'http://podcast.badeog.no/kortapplaus/podcast.xml?1001250')
    @cast_url = cast_url
  end

  def download_m3us
    urls = []
    @doc = Nokogiri::XML(open("http://podcast.badeog.no/kortapplaus/podcast.xml?1001250"))
    list = @doc.xpath("//enclosure/@url")

    list.each do|el|
      urls.push(el)
    end

    #This works but tryna use multi threads
    urls.each do|url|
      system %x{ wget -P ~/audio/ #{url} }
      break
    end
  end


end

test = Downloader.new
test.download_m3us