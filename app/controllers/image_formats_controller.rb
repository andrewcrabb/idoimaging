class ImageFormatsController < ApplicationController
  load_and_authorize_resource


  def index
    @image_formats = ImageFormat.order(:name)
  end

  def show
  end

  def new
    @image_format = ImageFormat.new
  end

  def edit
  end

  def create
    @image_format = ImageFormat.new(image_format_params)

    respond_to do |format|
      if @image_format.save
        format.html { redirect_to @image_format, notice: 'ImageFormat was successfully created.' }
        format.json { render :show, status: :created, location: @image_format }
      else
        format.html { render :new }
        format.json { render json: @image_format.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @image_format.update(image_format_params)
        format.html { redirect_to @image_format, notice: 'ImageFormat was successfully updated.' }
        format.json { render :show, status: :ok, location: @image_format }
      else
        format.html { render :edit }
        format.json { render json: @image_format.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @image_format.destroy
    respond_to do |format|
      format.html { redirect_to image_formats_url, notice: 'ImageFormat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def image_format_params
    params.require(:image_format).permit(:name, :value, :description, image_format_ids: [])
  end
end
