require 'sinatra'
require 'simple-rss'
require 'builder'
require 'open-uri'

get '/*' do
  rss = SimpleRSS.parse open('http://' + params[:splat][0].to_s)
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title rss.channel.title
        #xml.description 
        xml.link rss.channel.link

        rss.channel.entries.each do |post|
          xml.item do
            xml.title post.title
            xml.link post.link
            xml.description post.content
            xml.pubDate Time.parse(post.updated.to_s).rfc822()
            xml.guid post.link
          end
        end
      end
    end
  end
end
