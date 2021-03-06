class ProgramsController < ApplicationController
  # load_and_authorize_resource
  authorize_resource
  skip_authorize_resource :only => :show
  # skip_authorization_check :only => [:index, :show, :search]

  def index
    logger.error("@programs has #{@programs.count} entries") if @programs
    basic_params = %i(function read_format platform name_cont)
    advanced_params = %i(summary_cont interface speciality write_format for_audience language display_function header_function network_function programming_function other_function author)
    qparams = params[:q] ? params[:q].permit(basic_params + advanced_params) : nil
    if qparams
      # You could use the :active and :imaging scopes in the query.  Result is the same as the scopes are chained.
      # @q = Program.active.imaging.ransack(qparams)
      @q = Program.ransack(qparams.merge(active: true, imaging: true))
      @q.sorts = 'rating desc' if @q.sorts.empty?
      make_search_params(qparams)
      @programs = @q.result.includes(:languages, :platforms, :source_urls, :ratings).page(params[:page]).per(10)
    else
      @q = Program.none.ransack
      @programs = nil
    end
  end

  def make_search_params(qparams)
    if qparams and qparams.to_h.count > 0
      # params no longer subclassed from Hash in Rails 5  http://bit.ly/2RXRUs2
      qqparams = qparams.to_h
      exclude_keys = []
      if (search_level = qqparams[Feature::SEARCH_LEVEL])
        # logger.debug("XXX search_level #{search_level}")
        exclude_keys = [Feature::FOR_AUDIENCE, Feature::SEARCH_LEVEL] if search_level.eql? Feature::SEARCH_LEVEL_BASIC
      end
      @search_params = qqparams.select{ |k, v|
        # key 's' is used by Kaminari for search order on column
        v.length > 0 and k.length > 1 and not exclude_keys.include? k.to_s
      }.map { |k, v|
        describe_search_terms(k, v)
      }
      # logger.debug("search_params: #{@search_params}")
    end
  end

  # @param key [String] 'name_cont' or 'platform' or 'read_format'
  # @param val [String] 'Foo' (for cont) or '3' (for values)
  # @return [Array<key_string, val_string>]

  def describe_search_terms(key, val)
    case key
    when /^(.+)_cont/
      key_str = "#{$1.titleize} contains"
      val_str = val
    else
      key_str = key.titleize
      val_str = describe_search_val(key, val)
    end
    return [key_str, val_str]
  end

  def describe_search_val(key, val)
    features = Feature.select(:category).distinct.pluck(:category)
    # logger.error("features #{features} key #{key}")
    keycaps = key.titleize.gsub(/ /, '')
    if features.include? keycaps
      Feature.find(val.to_i).value
    elsif key.match(/_format$/)
      ImageFormat.find(val.to_i).name
    elsif key.match(/author/)
      Author.find(val.to_i).common_name
    # elsif key.match(/for_audience/)

    else
      logger.error("Can't find key #{key} val #{val} keycaps #{keycaps}")
    end
  end

  def show
    # logger.debug("XXXXXXXXXXXXXXXXXXXXXXXXXX")
    @program = Program.active.imaging_or_group.includes(:features, :ratings, :resources).where(id: params[:id]).first
    @rating = user_signed_in? ? @program.rating_by(current_user.id) : nil
    # Hack.  I can't find a correct db way to perform multiple queries upon the
    # eager-loaded resources without incurring a db query for each one.
    # So I pull them all out here and put them in a hash.
    @resources = Hash.new{ |h,k| h[k] = [] }
    if @program
      pr = @program.resources.includes(:resource_type)
      # logger.debug("------------ program #{@program.id} has #{pr.count} resources")
      pr.each { |r|
        unless r
          logger.error("nil resource for program #{@program.id} with #{pr.count} resources")
          next
        end
        @resources[r.resource_type.name] << r if r.resource_type
      }
    else
      logger.error("ProgramsController::show: NilClass error, redirecting")
      redirect_to root_url, :alert => "No program found"
    end
    # logger.debug("resources #{@resources}")
  end

  def new
    @program = Program.new
  end

  def edit
  end

  def create
    @program = Program.new(program_params)

    respond_to do |format|
      if @program.save
        format.html { redirect_to @program, notice: 'Program was successfully created.' }
        format.json { render :show, status: :created, location: @program }
      else
        format.html { render :new }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    logger.debug("Params are #{params}")
    logger.debug("Program Params are #{program_params}")
    respond_to do |format|
      if @program.update(program_params)
        format.html { redirect_to @program, notice: 'Program was successfully updated.' }
        format.json { render :show, status: :ok, location: @program }
      else
        format.html { render :edit }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @program.destroy
    respond_to do |format|
      format.html { redirect_to programs_url, notice: 'Program was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # ahc

  def search
    @q = Program.ransack(params[:q])
  end

  def fulltext
    @search_param = params['Program'][:fulltext]
    redirect_to :back unless @search_param.length > 0
      # render :nothing => true

    @programs = Program.search_for(@search_param).page(params[:page]).per(10)
    # .with_pg_search_highlight
    # 
  end

  def rating
    logger.debug("#{params}")
    rating = @program.ratings.find_by(user_id: params["user"])
    if rating
      # Modify existing Rating
      logger.debug("Modifying Rating #{rating.id} from #{rating.rating} to #{params['rating']}")
      rating.rating = params["rating"]
      rating.save
    else
      logger.debug("Creating new rating: #{params['rating']}")
      Rating.create(program_id: params["id"], user_id: params["user"], rating: params["rating"])
    end
    render :nothing => true, :status => :ok
  end

  def calculate_rating
    logger.debug("#{params}")
    @program.calculate_ratings
    render :nothing => true, :status => :ok
  end

  private

  def program_params
    # logger.debug("program params: #{params['program']}")
    logger.debug("program params: #{params}")
    params.require(:program).permit(:id, :name, :summary, :description, :kind, :add_date, :remove_date, :fulltext, read_format_ids: [], write_format_ids: [], overall_rating_ids: [])
  end

end
