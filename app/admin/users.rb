ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role

  menu priority: 2, label: proc { I18n.t("active_admin.users.title") }

  scope :all, default: true, show_count: false
  scope :students, show_count: false
  scope :instructors, show_count: false
  scope :admins, show_count: false

  filter :email
  filter :created_at
  filter :role, as: :select, collection: User.roles.keys.map { |r| [ r.humanize, r ] }

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

  form do |f|
    f.inputs I18n.t("active_admin.users.main") do
      f.input :email
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
      f.input :role, as: :select,
                     collection: User.roles.keys.map { |r| [ r.humanize, r ] },
                     include_blank: false,
                     selected: f.object.new_record? ? "student" : f.object.role
    end
    f.actions
  end
end
