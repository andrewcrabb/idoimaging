class FeaturesController < ApplicationController
  load_and_authorize_resource


  def index
    @features = Feature.order(:name, :value)
  end

  def show
  end

  def new
    @feature = Feature.new
  end

  def edit
  end

  def create
    @feature = Feature.new(feature_params)

    respond_to do |format|
      if @feature.save
        format.html { redirect_to @feature, notice: 'Feature was successfully created.' }
        format.json { render :show, status: :created, location: @feature }
      else
        format.html { render :new }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @feature.update(feature_params)
        format.html { redirect_to @feature, notice: 'Feature was successfully updated.' }
        format.json { render :show, status: :ok, location: @feature }
      else
        format.html { render :edit }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feature.destroy
    respond_to do |format|
      format.html { redirect_to features_url, notice: 'Feature was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def feature_params
    params.require(:feature).permit(:name, :value, :description, feature_ids: [])
  end
end
