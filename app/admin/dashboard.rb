ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  action_item do
    link_to "Main Site", root_url
  end

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "User" do
          h5 "User per Role:"
          user_per_role = User.select("count(id) as count, role").group("role").group_by{|g| g.role}

          #Collect to: ["Name",Count]
          user_per_role = User::ROLES.collect{|role_name,role| [role_name.to_s, (user_per_role[role]||[{count:0}])[0][:count]]}

          #Add Count to Description
          user_per_role = user_per_role.collect{|r| ["#{r[0]} (#{r[1]})", r[1]]}

          #Show Graphic #User per Role
          para raw "<div  style=\"height: 100px; width:100%\" class=\"category_vizualisation\" data-bars='#{user_per_role.to_json}' data-yaxis_label='Users'></div>"
          para "Total Count: #{User.all.count}"

          h5 "Last five:" do
            ul do
              User.last(5).map do |user|
                li link_to(user.email, admin_user_path(user))
              end
            end
          end
        end

        panel "Test results" do
          h5 "Test result Histogram:"
          test_result_histogram = VorkursTest.all.collect do |vorkurs_test|
            counter = [[100,0],[90,0],[80,0],[70,0],[60,0],[50,0],[40,0],[30,0],[20,0],[10,0]]
            User.all.each do |user|
              result = vorkurs_test.result user
              if result > 0
                counter.each do |c|
                  if result >= c[0]
                    c[1] = c[1]+1
                    break
                  end
                end
              end
            end
            counter
          end


          para raw "<div  style=\"height: 300px; width:100%\" class=\"multiple_category_vizualisation\" data-bars='#{test_result_histogram.to_json}'></div>"
        end
      end
      column do
        panel "Events" do
          table_for Event.since(1.week.ago) do |event|
            column :created_at
            column :message
          end
        end
      end
    end
  end

end
