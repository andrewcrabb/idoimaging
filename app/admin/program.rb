ActiveAdmin.register Program do

  ActiveAdmin.register Rating do
    belongs_to :Program
  end

  controller do
    def scoped_collection
      # super.includes :platforms, :languages, :resources
      super.active.imaging_or_group
    end
  end

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

  action_item :view, only: :show do
    link_to 'View on site', programs_path(program)
  end


  permit_params :name, :summary, :description, :add_date, :remove_date, :remove_note,
    :specialities, :programming_functions, :other_features, :audience_features,
    :image_functions, :pacs_functions, :other_functions, :overall_rating_id, :rating, :program_kind,
    read_image_format_ids: [], write_image_format_ids: [],
    read_format_ids: [], write_format_ids: [], network_features: [], languages: [], feature_ids: [],
    resources_attributes:            [:id, :_destroy, :resource_type_id, :url, :description, :identifier, :resourceful_id, :resourceful_type],
    images_attributes:               [:id, :_destroy, :image, :image_type],
    versions_attributes:             [:id, :_destroy, :date, :program_id, :version],
    latest_versions_attributes:      [:id, :_destroy, :date, :program_id, :version],
    authors_attributes:              [:id, :_destroy],
    author_programs_attributes:      [:id, :_destroy, :author_id, :program_id],
    program_components_attributes:   [:id, :_destroy, :included_program_id, :including_program_id],
    inverse_components_attributes:   [:id, :_destroy, :included_program_id, :including_program_id],
    program_memberships_attributes:  [:id, :_destroy, :included_program_id, :including_program_id],
    inverse_memberships_attributes:  [:id, :_destroy, :included_program_id, :including_program_id],
    program_relations_attributes:    [:id, :_destroy, :included_program_id, :including_program_id],
    inverse_relations_attributes:    [:id, :_destroy, :included_program_id, :including_program_id],
    program_requirements_attributes: [:id, :_destroy, :included_program_id, :including_program_id],
    inverse_requirements_attributes: [:id, :_destroy, :included_program_id, :including_program_id],
    overall_rating_attributes:       [:id, :rating],
    breadth_rating_attributes:       [:id, :rating],
    scale_rating_attributes:         [:id, :rating],
    # scale_ratings_attributes:         [:id, :rating],
    website_rating_attributes:       [:id, :rating],
    appearance_rating_attributes:    [:id, :rating]

  config.sort_order = 'name_asc'

  filter :name
  filter :authors              , collection: Author.selector_values
  filter :programming_functions, collection: Feature.selector_values(Feature::PROGRAMMING)
  filter :platforms            , collection: Feature.selector_values(Feature::PLATFORM)
  filter :languages            , collection: Feature.selector_values(Feature::LANGUAGE)
  filter :display_functions    , collection: Feature.selector_values(Feature::DISPLAY)
  filter :specialities         , collection: Feature.selector_values(Feature::SPECIALITY)
  filter :network_functions    , collection: Feature.selector_values(Feature::NETWORK)
  filter :audience_features    , collection: Feature.selector_values(Feature::AUDIENCE)
  filter :interfaces           , collection: Feature.selector_values(Feature::INTERFACE)
  filter :distributions        , collection: Feature.selector_values(Feature::DISTRIBUTION)
  filter :other_functions      , collection: Feature.selector_values(Feature::OTHER)
  # This was not working without 'as: :select'  http://bit.ly/2houM2j
  filter :appearance_rating_rating, as: :select, collection: (0..5), label: 'Appearance rating'
  filter :breadth_rating_rating   , as: :select, collection: (0..5), label: 'Breadth rating'
  filter :overall_rating_rating   , as: :select, collection: (0..5), label: 'Overall rating'
  filter :scale_rating_rating     , as: :select, collection: (0..5), label: 'Scale rating'
  filter :website_rating_rating   , as: :select, collection: (0..5), label: 'Website rating'

  show do
    columns do
      column do
        attributes_table do
          span link_to("Program Listing", program_path(program))
          table_for program.features.select(:category).distinct do
            column(:category) { |c| c.category }
            column("Value")   { |t| program.features.where(category: t.category).pluck(:value).join(", ") }
          end
          # row :versions do
          div do
            nver = program.versions.count
            "#{nver} versions, latest #{program.latest_version_string}"
          end
        end
      end

      column do
        admin_ratings = program.ratings.admin
        if admin_ratings.count > 0
          table_for admin_ratings do
            column("Rating (#{program.formatted_rating}) ") { |r| r.rating_type }
            column("Value")  { |r| r.rating }
          end
        end
        table_for program.resources do
          column("Resource")         { |r| link_to(r.resource_type.name, r.full_url, {target: 'new'}) }
          column("Value", {span: 2}) { |r| r.short_url }
        end
      end

      column span:2 do
        attributes_table do
          row :authors     do program.authors.map{ |a| a.common_name }.join(', ') end
          row :summary
          row :description
          row :add_date
          row :remove_date
          row('Reads formats')  do program.read_image_formats.order(:name).map  { |f| f.name }.join(', ') end
          row('Writes formats') do program.write_image_formats.order(:name).map { |f| f.name }.join(', ') end
        Program::RELATIONSHIPS.each do |relationship, text|
          if program.send("#{relationship}_programs").count > 0
            row(text) do raw program.send("#{relationship}_programs").map{ |p| link_to(p.name, admin_program_path(p)) }.join(", ") end
          end
        end
        end
      end

    end

    program.images.each do |i|
      span link_to(image_tag(i.image.thumb.url), i.image.url)
    end

    active_admin_comments
  end

  index do
    selectable_column
    column "Name", sortable: :name do |prog|
      link_to prog.name, admin_program_path(prog)
    end
    column :rating do |prog|
      prog.formatted_rating
    end
    actions
  end

  form do |f|
    def feature_selector(form, category)
      collection = Feature.selector_values(category)
      label = category.titleize.pluralize
      form.input :features, as: :check_boxes, multiple: true, collection: collection , label: label
    end
    actions

    inputs 'Details' do
      columns do
        column do
          input :name, :input_html => { :size => 40 }
          span link_to 'Home', program.home_urls.first.full_url if program.home_urls.count > 0
          br
          input :summary, label: "Summary" #, :input_html => { :size => 100 }
          br
          input :program_kind, as: :select, collection: Program.program_kinds
          br
          # input :add_date, as: :datepicker, datepicker_options: {dateFormat: 'mm-dd-yy'}
          input :add_date, as: :datepicker
          br
          # input :remove_date, as: :datepicker, datepicker_options: {dateFormat: 'mm-dd-yy'}
          input :remove_date, as: :datepicker
          br
          input :remove_note
          br

          panel "Versions" do
            f.has_many :latest_versions, heading: false  do |r|
              if r.object.new_record?
                r.input :date, as: :datepicker
                r.input :version
              else
                r.input :date, as: :string, label: r.object.version, :input_html => { :rows => 1 }
                # Rather than 'allow_destroy' in order to apply class for styling.
                r.input :_destroy, as: :boolean, :input_html => { :class => :goaway }
              end
            end
          end

          # -------------------------------------------------------------------------
          # Come back to this.
          # f.date_select :remove_date, label: 'Remove date'
          # f.input :remove_note, label: 'Remove note'
          # -------------------------------------------------------------------------
        end
        column do
          input :description, label: false, :input_html => { :rows => 10 }
          br
          authors = Author.all.map{ |a| [a.common_name, a.id] }.sort{ |e, f| e[0].upcase <=> f[0].upcase }
          f.has_many :author_programs, allow_destroy: true, heading: 'Authors', new_record: 'Add author' do |ap|
            ap.input :author, as: :select, collection: authors, label: false
          end
          br
          panel 'Admin Ratings' do
            # I can't find the documentation for the for: option anywhere.
            # I got this from http://bit.ly/2hkb23H
            columns do
              Rating::RATING_TYPES.keys.each do |rtype|
                column do
                  f.inputs rtype.to_s.titleize, for: [:"#{rtype}_rating", f.object.send("#{rtype}_rating") || Rating.new(rating_type: rtype)] do |meta_form|
                    meta_form.input :rating, as: :radio, collection: (0..5).to_a, label: false
                  end
                end
              end
            end
          end
        end
      end
      columns do
        column do
          feature_selector(f, Feature::PLATFORM)
          feature_selector(f, Feature::INTERFACE)
          feature_selector(f, Feature::LANGUAGE)
        end
        column do
          feature_selector(f, Feature::FUNCTION)
          feature_selector(f, Feature::DISPLAY)
          feature_selector(f, Feature::HEADER)
          feature_selector(f, Feature::NETWORK)
          feature_selector(f, Feature::OTHER)
          feature_selector(f, Feature::PROGRAMMING)

        end
        column do
          feature_selector(f, Feature::DISTRIBUTION)
          feature_selector(f, Feature::SPECIALITY)
          feature_selector(f, Feature::AUDIENCE)
        end
        column do
          image_formats = ImageFormat.order(:name).map { |i| [i.name, i.id] }
          f.input :read_image_formats, as: :check_boxes, collection: image_formats, label: 'Read Formats'
        end
        column do
          image_formats = ImageFormat.order(:name).map { |i| [i.name, i.id] }
          f.input :write_image_formats, as: :check_boxes, collection: image_formats, label: 'Write Formats'
        end
      end
      columns do
        column do
          # render :partial => "has_many_resources", :locals => { f: f }

          f.has_many :resources, allow_destroy: true, heading: 'Resources' do |r|
            # logger.debug("resource #{r.object} has id #{r.object.id}")
            url = r.object.url
            url = "http://#{url}" if (url and not url.match(/^http/))
            rname = r.object.resource_type ? r.object.resource_type.name : 'New'
            r.input :url, label: link_to(rname, url)
            r.input :description
            r.input :resource_type, as: :select, collection: ResourceType.selector_values
          end
        end
        column do
          programs = Program.unscoped.active.order("lower(name)").map { |i| [i.name, i.id] }

          f.has_many :program_components, allow_destroy: true, heading: 'Built upon programs', new_record: 'Add built-upon program' do |u|
            u.input :included_program_id, as: :select, collection: programs, label: "Built upon:"
          end
          br
          f.has_many :inverse_components, allow_destroy: true, heading: 'Built into programs', new_record: 'Add built-into program' do |u|
            u.input :including_program_id, as: :select, collection: programs, label: "Built into programs:"
          end
          br
          f.has_many :program_memberships, allow_destroy: true, heading: 'Member programs', new_record: 'Add member program' do |u|
            u.input :included_program_id, as: :select, collection: programs, label: "Has member programs:"
          end
          br
          f.has_many :inverse_memberships, allow_destroy: true, heading: 'Member of programs', new_record: 'Add member-of program' do |u|
            u.input :including_program_id, as: :select, collection: programs, label: "Member of programs:"
          end

          br
          f.has_many :program_relations, allow_destroy: true, heading: 'Related to programs', new_record: 'Add related program' do |u|
            u.input :included_program_id, as: :select, collection: programs, label: "Related to:"
          end
          br
          f.has_many :inverse_relations, allow_destroy: true, heading: 'Related by programs', new_record: 'Add related-by program' do |u|
            u.input :including_program_id, as: :select, collection: programs, label: "Related by programs:"
          end
          br
          f.has_many :program_requirements, allow_destroy: true, heading: 'Requires programs', new_record: 'Add required program' do |u|
            u.input :included_program_id, as: :select, collection: programs, label: "Requires:"
          end
          br
          f.has_many :inverse_requirements, allow_destroy: true, heading: 'Required by programs', new_record: 'Add requiring program' do |u|
            u.input :including_program_id, as: :select, collection: programs, label: "Required by programs:"
          end


        end
        column do
          f.has_many :images, allow_destroy: true, heading: 'Images' do |i|
            # uploader = ImageUploader.new
            i.input :image, as: :file, :hint => image_tag(i.object.image.thumb.url)
            # i.input :image_type, as: :select, collection: Image::IMAGE_TYPES
            # uploader.store!(:image)
          end
        end
      end
    end
    # inputs 'Content', :body
    para "Press cancel to return to the list without saving."
    hidden_field(:program_id, value: f.object.id)
    actions
  end
end
