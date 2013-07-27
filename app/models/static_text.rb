class StaticText < ActiveRecord::Base
  attr_accessible :key, :value

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
end
