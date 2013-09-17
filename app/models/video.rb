require 'nokogiri'
require 'open-uri'

class Video < ActiveRecord::Base
  attr_accessible :mediaweb_url

	# #Original-View URL (:mediaweb_url) 
	# "http://mediaweb.ovgu.de/Mediasite/Play/#{cardPresentationId}"
	# "http://mediaweb.ovgu.de/Mediasite/Play/a60948e0341547b6abf7c1ce73d5e91d1d?catalog=e0f74689-3d93-4765-a57a-01f5ca51f6f1"
	def cardPresentationId url = nil
		url ||= self.mediaweb_url
		
		match = /Mediasite\/Play\/(?<id>[^?]+)/.match(mediaweb_url)
		throw "This is not a correct Mediaweb URL" if match.nil?

		cardPresentationId = match[:id]

		#page = Nokogiri::HTML(open(self.mediaweb_url))
		#page.css("body")
	end

	# #Mediaweb Manifest
	# "http://mediaweb.ovgu.de/Mediasite/FileServer/Presentation/#{cardPresentationId}/player-manifest.xml"
	# "http://mediaweb.ovgu.de/Mediasite/FileServer/Presentation/a60948e0341547b6abf7c1ce73d5e91d1d/player-manifest.xml"
	# --> "PresentationDataUrl" => "/Mediasite/FileServer/4980815e5dad4da784da1fcfa9d584f329"
	# --> "SlideUriFormat" => "slide_{0:D4}_full.jpg"
	# --> "Slides.count" => 33
	# --> "Slides>Slide[]" => "Times[]"
	# --> "VideoStreams>VideoStream>Location" => "http://mediass.ovgu.de/OnDemand/5adea352-f791-43ed-a484-1c54d55646ca.mp4?playbackTicket=b576333fb5414786b36dc63cbfa329f0&site=mediaweb.ovgu.de"
	# --> "VideoStreams>VideoStream>Filename" => "5adea352-f791-43ed-a484-1c54d55646ca.mp4"
	def catch_manifest_data url = nil
		url ||= self.mediaweb_url
		manifest_url = "#{server url}/Mediasite/FileServer/Presentation/#{cardPresentationId url}/player-manifest.xml"

		page = Nokogiri::XML(open(manifest_url))

		manifest = {}

		manifest[:slide_uri_format] = page.css("SlideUriFormat").children[0].text

		manifest[:mime_type] = page.css("VideoStreams>VideoStream>MimeType").children[0].text
		manifest[:location] = page.css("VideoStreams>VideoStream>Location").children[0].text
		manifest[:file_name] = page.css("VideoStreams>VideoStream>Filename").children[0].text

		manifest[:presentation_data_url] = page.css("PresentationDataUrl").children[0].text

		manifest[:title] = page.css("MetaData>Title").children[0].text
		manifest[:recording_time] = page.css("MetaData>RecordDateTime").children[0].text

		first_name = page.css("MetaData>Presenters>Presenter>FirstName").children[0].text
		last_name = page.css("MetaData>Presenters>Presenter>LastName").children[0].text
		manifest[:presenter] = "#{first_name} #{last_name}"

		#parsing slides
		slides = page.css("Slides").children.collect do |slide| 
			time = slide.attributes["Time"]
			unless time.nil?
				slide = {}
				slide[:time] = time.value
				slide
			end
		end
		#remove nil's
		slides = slides.delete_if{|x|x.nil?}

		#insert slide urls
		slides.each_with_index do |slide, index|
			slide[:url] = full_slide_url index+1, manifest[:presentation_data_url], url, manifest[:slide_uri_format]
		end

		manifest[:slides] = slides

		manifest
	end

	# #Slides
	# "http://mediaweb.ovgu.de/#{PresentationDataUrl}/Presentation/#{cardPresentationId}/#{SlideUriFormat}"
	# "http://mediaweb.ovgu.de/Mediasite/FileServer/4980815e5dad4da784da1fcfa9d584f329/Presentation/a60948e0341547b6abf7c1ce73d5e91d1d/slide_0005_full.jpg"
	# #Slides.preview
	# "http://mediaweb.ovgu.de/Mediasite/FileServer/4980815e5dad4da784da1fcfa9d584f329/Presentation/a60948e0341547b6abf7c1ce73d5e91d1d/slide_1_240_180.jpg"
	def full_slide_url index, presentation_data_url, url = nil, ruby_slide_uri_format = "slide_{0:D4}_full.jpg"
		url ||= self.mediaweb_url
		ruby_slide_uri_format = ruby_slide_uri_format.gsub(/{0:D([0-9]+)}/,'%0\1d')
		"#{server url}#{presentation_data_url}/Presentation/#{cardPresentationId url}/#{ruby_slide_uri_format % index}"
	end

	def server url = nil
		url ||= self.mediaweb_url
		uri = URI(url)
		"#{uri.scheme}://#{uri.host}"
	end

# #MP4
# "http://mediass.ovgu.de/OnDemand/5adea352-f791-43ed-a484-1c54d55646ca.mp4?playbackTicket=b576333fb5414786b36dc63cbfa329f0&site=mediaweb.ovgu.de"
# #shorter
# "http://mediass.ovgu.de/OnDemand/5adea352-f791-43ed-a484-1c54d55646ca.mp4"
# #even-shorter
# "http://mediass.ovgu.de/OnDemand/#{Filename}"

end
