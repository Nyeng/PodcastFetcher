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
    @doc = Nokogiri::XML(open(@cast_url))
    list = @doc.xpath("//enclosure/@url")

    list.each do|el|
      urls.push(el.text)
    end


    urls.each do|url|
      puts url
       uri = URI(url)
       Net::HTTP.get(uri) # => String
    end

    time = Time.now
    hydra = Typhoeus::Hydra.new(max_concurrency:55)

    urls.map! do|url|
      url.sub(/^https?\:\/\//, '')
    end


    puts "Number of URLs to be testet: #{urls.length}"
    #options = {follow}

    # requests,urls = urls.length.times do |i,url|
    urls.each do|url|
     # puts url
      request = Typhoeus::Request.new (url)#followlocation: true)
      #request = Typhoeus::Request.new(base_url:'vg.no',followlocation:true)
      request.on_complete do|response|
       puts  "Response code: #{response.code}"
        puts "Response return message #{response.return_message}"
      end
      hydra.queue(request)
      #request
    end
   #hydra.run

    puts "Time taken to download #{urls.length} mp3s using Typhoeus: #{Time.now - time}"
   # Net::HTTP.get('example.com', '/index.html') # => String


    #
   #  system %x{ wget -P ~/audio/ #{'assets.skyskraper.no/badeog/podcast/bade_og/kort_applaus/bade_og_kort_applaus_magnus_devold_1_35m38s_zo8ko9qc.mp3'
   #  } }


    #This works but tryna use multi threads
    urls.each do|url|
      # system %x{ wget -P ~/audio/ #{url} }
      break
    end
  end
end


# test = Downloader.new
# test.download_m3us