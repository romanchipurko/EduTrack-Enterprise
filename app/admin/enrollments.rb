ActiveAdmin.register Enrollment do
  menu priority: 4, label: proc { I18n.t("active_admin.enrollments.title") }

  permit_params :user_id, :learning_path_id

  includes :user, :learning_path

  filter :user, collection: proc { User.users_collection }
  filter :learning_path
  filter :progress_percentage
  filter :created_at

  index title: proc { I18n.t("active_admin.enrollments.title") } do
    selectable_column
    id_column

    column :user do |enrollment|
      link_to enrollment.user.email, admin_user_path(enrollment.user)
    end

    column :learning_path do |enrollment|
      link_to enrollment.learning_path.title, admin_learning_path_path(enrollment.learning_path)
    end

    column :progress_percentage do |enrollment|
      "#{enrollment.progress_percentage}%"
    end

    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :learning_path
      row :progress_percentage do |enrollment|
        "#{enrollment.progress_percentage}%"
      end

      row :completed_item_ids do |enrollment|
        if enrollment.completed_item_ids.present?
          safe_join(enrollment.completed_item_ids.map { |id| content_tag(:span, id, class: "status_tag") }, " ")
        else
          "—"
        end
      end

      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs I18n.t("active_admin.enrollments.main") do
      f.input :user, collection: User.users_collection
      f.input :learning_path
      f.input :progress_percentage, input_html: { min: 0, max: 100, readonly: true  }
    end
    f.actions
  end
end
