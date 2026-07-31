ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard.title") }

  content title: proc { I18n.t("active_admin.dashboard.title") } do
    columns do
      column span: 12 do
        panel I18n.t("active_admin.dashboard.new_users_table.new_users") do
          table_for User.order(created_at: :desc).limit(10) do
            column :email, sortable: false do |user|
              link_to user.email, admin_user_path(user)
            end
            column :created_at, sortable: false
            column :role, sortable: false do |user|
              user.role.humanize
            end
          end
        end
      end
    end

    columns do
      column span: 12 do
        panel I18n.t("active_admin.dashboard.overall_info_table.overall") do
          attributes_table_for User do
            counts = User.dashboard_counts
            row(I18n.t("active_admin.dashboard.overall_info_table.total_users")) { counts[:total] }
            row(I18n.t("active_admin.dashboard.overall_info_table.total_students")) { counts[:students] }
            row(I18n.t("active_admin.dashboard.overall_info_table.total_instructors")) { counts[:instructors] }
            row(I18n.t("active_admin.dashboard.overall_info_table.total_admins")) { counts[:admins] }
          end
        end
      end
    end
  end
end
