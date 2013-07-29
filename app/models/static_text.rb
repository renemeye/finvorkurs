class StaticText < ActiveRecord::Base
  attr_accessible :key, :value

  @@options = [
    :autolink=>true, 
    :disable_indented_code_blocks=>true, 
    :strikethrough=>true,
    :underline=>true,
    :lax_spacing => true,
    :hard_wrap=>true
  ]
  @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(*@@options), *@@options)

  def self.get key
  	record = self.find_by_key(key)
  	if record.nil?
  		record = self.new
  		record.value = key
  		record.key = key
  		record.save
  	end
  	return record
  end

  def markdown_text
   @@markdown.render(self.value)
  end

end
