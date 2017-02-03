ActiveAdmin.register ImageFormat do

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

  permit_params :name, :description, :search_level,
    resources_attributes: [:_destroy, :id, :resource_type_id, :url, :description, :identifier, :resourceful_id, :resourceful_type]

  config.sort_order = 'name_asc'

  show do
    attributes_table do
      row :name
      row :description
      row :search_level

      table_for image_format.resources do
        column("Resource")         { |r| link_to(r.resource_type.name, r.full_url, {target: 'new'}) }
        column("Value", {span: 2}) { |r| r.full_url }
      end
    end
  end

  index do
    selectable_column
    column "Name", sortable: :name do |image_format|
      link_to image_format.name, admin_image_format_path(image_format)
    end
    column :search_level
    column :description
    actions
  end

  form do |f|
    input :name
    input :description
    input :search_level , as: :select, collection: ImageFormat::SEARCH_LEVELS, include_blank: true
    f.has_many :resources, allow_destroy: true, heading: 'Resources' do |r|
      # logger.debug("resource #{r.object} has id #{r.object.id}")
      url = r.object.url
      url = "http://#{url}" if (url and not url.match(/^http/))
      rname = r.object.resource_type ? r.object.resource_type.name : 'New'
      r.input :url, label: link_to(rname, url)
      r.input :description
      r.input :resource_type, as: :select, collection: ResourceType.selector_values, include_blank: true
    end
    actions
  end


end
