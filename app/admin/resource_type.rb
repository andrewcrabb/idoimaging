ActiveAdmin.register ResourceType do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  permit_params do
    permitted = [:name, :description, :icon]
  end

  config.sort_order = 'name_asc'

  index do
    selectable_column
    column :name, sortable: :name
    column :description
    column :icon
    actions
  end


end
