ActiveAdmin.register Resource do

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
    permitted = [:url, :description, :last_seen, :last_tested, :identifier, :resourceful_id, :resourceful_type]
  end

  form title: "Create resources from programs or formats, not directly" do |f|
    input :url
    input :description
    input :resource_type, as: :select, collection: ResourceType.selector_values, include_blank: true

    # input :search_level , as: :select, collection: ImageFormat::SEARCH_LEVELS, include_blank: true
    # f.has_many :resources, allow_destroy: true, heading: 'Resources' do |r|
    #   # logger.debug("resource #{r.object} has id #{r.object.id}")
    #   url = r.object.url
    #   url = "http://#{url}" if (url and not url.match(/^http/))
    #   rname = r.object.resource_type ? r.object.resource_type.name : 'New'
    #   r.input :url, label: link_to(rname, url)
    #   r.input :description
    #   r.input :resource_type, as: :select, collection: ResourceType.selector_values, include_blank: true
    # end
    actions
  end

end
