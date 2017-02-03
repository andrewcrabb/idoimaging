ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :role
    actions
  end

  filter :email
  # filter :role
  filter :role, as: :select, collection: User::ROLES

  menu if: proc{ current_user.admin? }

  # filter :current_sign_in_at
  # filter :sign_in_count
  # filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      # f.input :role, as: :radio, collection: {None: "none", Administrator: "admin"}
      f.input :role, as: :radio, collection: User::ROLES
    end
    f.actions
  end

end
