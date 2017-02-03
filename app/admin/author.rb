ActiveAdmin.register Author do

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

  permit_params :name_last, :name_first, :institution, :email, :country,
    resources_attributes: [:_destroy, :id, :resource_type_id, :url, :description, :identifier, :resourceful_id, :resourceful_type]


  config.sort_order = 'name_last_asc'

  filter :name_last_cont, as: :string, label: "Last name"
  filter :name_last_or_institution_cont, as: :string, label: "Last name or institution"

  index do

    selectable_column
    column :name_last, sortable: :name_last
    column :name_first
    column :institution
    column :country
    actions
  end

  show :title => proc{ |author| author.common_name } do
    columns do
      column do
        attributes_table do
          row :name_last
          row :name_first
          row :institution
          row :email
          row :country
        end
        span link_to("Programs for this author", programs_path(q: {author: author.id}))
      end
      column do
        table_for author.resources do
          column("Resource")         { |r| r.resource_type.name }
          column("Value", {span: 2}) { |r| link_to(r.url) }
        end
      end
    end

  end

  form do |f|
    inputs 'Details' do
      columns do
        column do
          input :name_last, :input_html => { :size => 40 }
          br
          input :name_first, :input_html => { :size => 40 }
          br
          input :country, include_blank: true
          br
          input :institution, :input_html => { :size => 40 }
        end
        # end

        column do

          f.has_many :resources, allow_destroy: true, heading: 'Resources' do |r|
            # logger.debug("resource #{r.object} has id #{r.object.id}")
            url = r.object.url
            url = "http://#{url}" if (url and not url.match(/^http/))
            rname = r.object.resource_type ? r.object.resource_type.name : 'New'
            r.input :url, label: rname
            r.input :description
            r.input :resource_type, as: :select, collection: ResourceType.selector_values
          end
        end
      end

      actions
    end
  end

end
