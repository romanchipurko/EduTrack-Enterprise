ActiveAdmin.register LearningPath do
  permit_params :title, :description

  menu priority: 3, label: proc { I18n.t("active_admin.learning_paths.title") }

  filter :title
  filter :created_at

  index title: proc { I18n.t("active_admin.learning_paths.title") } do
    selectable_column
    id_column
    column :title
    column :description do |lp|
      truncate(lp.description, length: 50)
    end
    column I18n.t("active_admin.learning_paths.students_count"), :enrollments_count
    column :created_at
    actions
  end

  show title: proc { resource.title } do
    attributes_table do
      row :id
      row :title
      row :description
      row I18n.t("active_admin.learning_paths.total_items") do |lp|
        lp.total_completable_items_count
      end
      row :created_at
      row :updated_at
    end

    panel proc { I18n.t("active_admin.learning_paths.enrollments_panel") } do
      table_for learning_path.enrollments.includes(:user) do
        column :user do |enrollment|
          link_to enrollment.user.email, admin_user_path(enrollment.user)
        end
        column :progress_percentage do |enrollment|
          "#{enrollment.progress_percentage}%"
        end
      end
    end
  end

  form do |f|
    f.inputs I18n.t("active_admin.learning_paths.main") do
      f.input :title
      f.input :description
    end
    f.actions
  end
end
