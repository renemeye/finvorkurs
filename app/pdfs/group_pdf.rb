#encoding: utf-8
class GroupPdf < Prawn::Document
	def initialize(current_user, group, tutor, view)
		super(top_margin: 70, page_size: "A4", info: {
			:Title => "BLUBBER "
		})

		@current_user = current_user
		@group = group
		@tutor = tutor
		@view = view

		pdf
	end

	def pdf
		#stroke_axis
		header
			move_down 5
		heading
		information
			move_down 7
		group_information
			move_down 20
		users
		#footer
	end

	def header
		image "#{Rails.root}/app/assets/images/logo.png", at: [-15,780], :width => 100
		formatted_text_box [{text: "Vorkurse", color: "555555", kerning: true}], at: [95,775], style: :bold, size: 27
		
		fill_color "7a003f"
		fill_rectangle [-36,806], 595, 13
		fill_color "000000"
		formatted_text_box [{text: "Unterschriftenliste | #{Time.new.strftime("%d.%m.%Y")}", color: "FFFFFF", kerning: true, background_color: "FF0000"}], at: [430,803], width: 200, size: 9
	end

	def heading
		formatted_text [{text:"Unterschriftenliste", size: 28, color: "555555"}]
	end

	def information

		formatted_text [{text:"Kurs", styles: [:bold]}]
		move_down 3

		formatted_text [{text:"#{@tutor.name} (#{@tutor.email})"}], :indent_paragraphs => 10

		formatted_text [{text:"#{@group.course.course_name}"}], :indent_paragraphs => 10

		formatted_text [{text:"#{(@group.room.blank?) ? "Nicht festgelegt" : @group.room}"}], :indent_paragraphs => 10
	end

	def group_information
		formatted_text [{text:"Gruppen Informationen", styles: [:bold]}]
		move_down 3
		formatted_text [{text:"#{(@group.group_information.blank?) ? "Keine Aktuellen Informationen" : @group.group_information}"}], :indent_paragraphs => 10
	end

	def users
		table user_rows do
			row(0).font_style = :bold
			columns(1..3).align = :right
			self.row_colors = ["DDDDDD","FFFFFF"]
			self.header = true
			#self.position = :center
		end
	end

	def user_rows
		a = 0
		[["\#", "Name", "E-Mail", "Anwesend (Unterschrift)"]]+
		@group.users.collect do |user|
			[
				a=a+1,
				user.name, 
				user.email,#link_to(user.email, "mailto:#{user.email}"),
				""
			]
		end
	end

end