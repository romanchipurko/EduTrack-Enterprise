ActiveAdmin.register LearningPath do
  permit_params :title, :description

  menu priority: 3, label: proc { I18n.t("active_admin.learning_paths.title") }

  filter :title

  index title: proc { I18n.t("active_admin.learning_paths.title") } do
    selectable_column
    id_column
    column :title
    column :description
    column :created_at
    actions
  end

  show title: proc { resource.title } do
    attributes_table do
      row :id
      row :title
      row :description
      row :created_at
      row :updated_at
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
