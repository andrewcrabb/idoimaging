ActiveAdmin.register Version do

  # belongs_to :program

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


  batch_action :publish do |ids|
    batch_action_collection.find(ids).each do |version|
      version.publish
    end
    redirect_to collection_path, alert: "#{ids.count} versions published."
  end



  permit_params do
    permitted = [:version, :date, :note, :rev_str, :program_id, :published_on]
  end

  config.sort_order = 'updated_at_desc'

  filter :date

  scope :all, default: true
  scope :unpublished

  index do

    selectable_column
    column  :program_id do |ver|
      prog = Program.find(ver.program_id)
      link_to prog.name, admin_program_path(prog)
    end
    column :version
    column  :date
    column :prev do |ver|
      prog = Program.find(ver.program_id)
      latest = prog.latest_version
      "#{latest.version}\n#{latest.date}"
    end
    column  :rev_str
    column :updated_at
    actions
  end

  form do |f|
    # inputs 'Details' do
    #   columns do
    #     column do
    #       # This does very nearly what I want, but not the ability to category in a new value
    #       input :category, label: 'Category', as: :select, collection: Version.categories
    #       br
    #       input :value, :input_html => { :size => 20 }
    #       br
    #       input :description, :input_html => { :size => 40 }
    #       br
    #       input :search_level , as: :select, collection: Version::SEARCH_LEVELS, include_blank: true
    #       br
    #       input :icon_prefix, :input_html => { :size => 20 }
    #       br
    #       input :icon, :input_html => { :size => 20 }
    #       br
    #       input :tooltip, :input_html => { :size => 20 }
    #     end
    #   end
    # end
    # actions
  end

end
