
# <script type="text/javascript" src="https://asciinema.org/a/7khffteogj4ojeobv182jbqfh.js" ?id="asciicast-7khffteogj4ojeobv182jbqfh" async></script>


class Asciinema < Liquid::Tag
    Syntax = /^\s*([^\s]+)\s*?/
  
    def initialize(tagName, markup, tokens)
      super
  
      if markup =~ Syntax then
        @id = $1
      else
        raise "No asciicast ID provided in the \"asciinema\" tag"
      end
    end
  
    def render(context)
      "<script type=\"text/javascript\" src=\"https://asciinema.org/a/#{@id}.js\" id=\"asciicast-#{@id}\" async></script>"
    end
  
    Liquid::Template.register_tag "asciinema", self
  end