# Title: base64 encode content
# Author: xixitalk http://xixitalk.github.io
# Description: base64 encode twice and decode at browser with javascript
#
# Syntax:
# {% base64_block %}
# This text will be encoded with base64 twice
# {% endbase64_block %}
#
# Output:
#VkdocGN5QjBaWGgwSUhkcGJHd2dZbVVnWlc1amIyUmxaQ0IzYVhSb0lHSmhjMlUyTkE9PQ==
#
require 'base64'

module Jekyll

  class Base64Block < Liquid::Block

    def initialize(tag_name, markup, tokens)
      super
    end

    def render(context)
      code = super
      encoded_text = Base64.strict_encode64(Base64.strict_encode64(code))
      base64_js = "<script src='/javascripts/base64.js' type='text/javascript'> </script>"
	  base64_decode = "<script type='text/javascript'> var line_name = 'base64_block';var content = document.getElementById(line_name).innerHTML;document.getElementById(line_name).innerHTML=Base64.decode(Base64.decode(content));</script>"
      output = "#{base64_js} <span id='base64_block'>#{encoded_text}</span> #{base64_decode}"
    end
  end
end

Liquid::Template.register_tag('base64_block', Jekyll::Base64Block)
