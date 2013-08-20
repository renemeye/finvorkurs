require 'redcarpet'

class MathjaxCompatibleMarkdown < Redcarpet::Render::HTML
  def block_code(code, language)
    if language == 'mathjax'
      "<script type=\"math/tex; mode=display\">
        #{code}
      </script>
      <noscript>
        #{code}
      </noscript>
      "
    else
      "<pre><code class=\"#{language}\">#{code}</code></pre>"
    end
  end
  
  def codespan(code)
    if code[0] == "$" && code[-1] == "$"
      code.gsub!(/^\$/,'')
      code.gsub!(/\$$/,'')
      "<script type=\"math/tex\">#{code}</script><noscript>#{code}</noscript>"
    else
      "<code>#{code}</code>"
    end
  end
end
 