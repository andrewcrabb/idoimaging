ActiveAdmin.register Feature do

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

  permit_params do
    permitted = [:category, :value, :description, :icon_prefix, :icon, :tooltip, :search_level]
  end

  config.sort_order = 'category_asc'
  # Put this back.  It was causing a error during db:migrate
  filter :value

  scope :all, default: true
  scope :functions
  scope :other_functions
  scope :conversion_functions
  scope :display_functions
  scope :header_functions
  scope :network_functions
  scope :programming_functions

  scope :audience_features
  scope :distributions
  scope :interfaces
  scope :languages
  scope :other_features
  scope :platforms
  scope :specialities
  scope :audiences

  index do

    selectable_column
    column :category
    column :value
    column :description
    column :search_level
    column :icon
    column :icon_prefix
    column :tooltip
    actions
  end

  form do |f|
    inputs 'Details' do
      columns do
        column do
          # This does very nearly what I want, but not the ability to category in a new value
          input :category, label: 'Category', as: :select, collection: Feature.categories
          br
          input :value, :input_html => { :size => 20 }
          br
          input :description, :input_html => { :size => 40 }
          br
          input :search_level , as: :select, collection: Feature::SEARCH_LEVELS, include_blank: true
          br
          input :icon_prefix, :input_html => { :size => 20 }
          br
          input :icon, :input_html => { :size => 20 }
          br
          input :tooltip, :input_html => { :size => 20 }
        end
      end
    end
    actions
  end

end
