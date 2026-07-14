ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role

  menu priority: 2, label: proc { I18n.t("active_admin.users.title") }

  scope :all, default: true, show_count: false
  scope :students, show_count: false
  scope :instructors, show_count: false
  scope :admins, show_count: false

  filter :email
  filter :created_at
  filter :role, as: :select, collection: User.roles.keys.map { |r| [r.humanize, r] }

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

  ###
  show title: proc { resource.email } do
    attributes_table do
      row :id
      row :email
      row :role do
        if current_user != resource
          roles = User.roles.keys.map(&:to_s)
          current_idx = roles.index(resource.role)
          new_role = roles[(current_idx + 1) % roles.size]
          link_to(
            resource.role.humanize,
            change_role_admin_user_path(resource, new_role: new_role),
            method: :post,
            data: { confirm: "Изменить роль пользователя #{resource.email} на #{new_role.humanize}?" },
            class: "button"
          )
        else
          "#{resource.role.humanize}"
        end
      end
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
                     collection: User.roles.keys.map { |r| [r.humanize, r] },
                     include_blank: false,
                     selected: f.object.new_record? ? 'student' : f.object.role
    end
    f.actions
  end

  member_action :change_role, method: :post do
    user = User.find(params[:id])
    new_role = params[:new_role]

    if user == current_user
      flash[:error] = "Вы не можете изменить свою собственную роль."
      redirect_to admin_user_path(user)
    end

    if User.roles.keys.map(&:to_s).include?(new_role)
      if user.update(role: new_role)
        flash[:notice] = "Роль пользователя #{user.email} изменена на #{new_role.humanize}."
      else
        flash[:error] = "Не удалось изменить роль: #{user.errors.full_messages.to_sentence}"
      end
    else
      flash[:error] = "Недопустимая роль."
    end
    redirect_to admin_user_path(user)
  end
end