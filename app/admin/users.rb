ActiveAdmin.register User do
  permit_params :email, :role

  menu priority: 2, label: proc { I18n.t("active_admin.users.title") }

  scope :all, default: true, show_count: false
  scope :students, show_count: false
  scope :instructors, show_count: false
  scope :admins, show_count: false

  filter :email
  filter :created_at
  filter :role, as: :select, collection: User.roles.keys

  index title: I18n.t("active_admin.users.title") do
    selectable_column
    id_column
    column :email
    column :role do |user|
      user.role.humanize
    end
    column :created_at
    actions
  end

  show title: proc { resource.email } do
    attributes_table do
      row :id
      row :email
      row :role
      row :created_at
      row :updated_at
    end
  end

  action_item :reset_password, only: :show do
    button_to I18n.t("active_admin.users.reset_password.button"),
              reset_password_admin_user_path(resource),
              method: :post,
              form: { class: "btn btn-sm btn-outline-secondary", data: { confirm: I18n.t("active_admin.users.reset_password.confirm") } }
  end

  member_action :reset_password, method: :post do
    user = User.find(params[:id])
    user.send_reset_password_instructions
    redirect_to admin_user_path(user),
                notice: I18n.t("active_admin.users.reset_password.success", email: user.email)
  end

  form do |f|
    f.inputs I18n.t("active_admin.users.main") do
      f.input :email
      f.input :role, as: :select,
                     collection: User.roles.keys.map { |r| [ r.humanize, r ] },
                     include_blank: false,
                     selected: f.object.new_record? ? "student" : f.object.role
    end
    f.actions
  end
end
