# ref: https://gist.github.com/raw/3156265/0b5824a7509b2815f8dc8e3a6835ae643e9ecbfb/flickr_image.rb
require 'flickraw'
class FlickrImage < Liquid::Tag

  def initialize(tag_name, markup, tokens)
     super
     @markup = markup
     @id   = markup.split(' ')[0]
     @size = markup.split(' ')[1]
  end 

  def render(context)

    FlickRaw.api_key        = "f7692309b27bdac7ee23c79a75ff2dba"
    FlickRaw.shared_secret  = "f0d275922310c3a3"
    FlickRaw.proxy = "http://192.168.1.106:8118/"

    info = flickr.photos.getInfo(:photo_id => @id)

    server        = info['server']
    farm          = info['farm']
    id            = info['id']
    title         = info['title']
    description   = info['description']
    size          = "_#{@size}" if @size
    if @size == "o" then
        secret = info['originalsecret']
        format = info['originalformat']
    else
        secret = info['secret']
        format = "jpg"
    end 
    src           = "http://farm#{farm}.static.flickr.com/#{server}/#{id}_#{secret}#{size}.#{format}"
    page_url      = info['urls'][0]["_content"]

    img_tag       = "<img src='#{src}' title='#{title}'/>"
    link_tag      = "<a href='#{page_url}'>#{img_tag}</a>"

  end 
end

Liquid::Template.register_tag('flickr_image', FlickrImage)
