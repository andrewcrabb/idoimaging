class ResourceTypesController < ApplicationController
  load_and_authorize_resource

  def create
    @resource_type = ResourceType.new(resource_type_params)
    # ...
  end

  private

  def resource_type_params
    params.require(:resource_type).permit(:name, :description)
  end
end
