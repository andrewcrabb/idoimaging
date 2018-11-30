class ApplicationController < ActionController::Base
  # ahc  https://goo.gl/EHlgIJ
  include CanCan::ControllerAdditions
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # http://bit.ly/2c9De9a
  # Deal with 'ActiveModel::ForbiddenAttributesError'
  # before_filter do
  #   resource = controller_path.singularize.gsub('/', '_').to_sym # => 'blog/posts' => 'blog/post' => 'blog_post' => :blog_post
  #   method = "#{resource}_params" # => 'blog_post_params'
  #   params[resource] &&= send(method) if respond_to?(method, true) # => params[:blog_post]
  # end
  # before_filter do
  #   resource = controller_name.singularize.to_sym
  #   method = "#{resource}_params"
  #   params[resource] &&= send(method) if respond_to?(method, true)
  # end

  # Rack Mini Profiler

  before_action do
    if current_user && current_user.is_admin?
      Rack::MiniProfiler.authorize_request
    end
  end


  # ActiveAdmin

  def authenticate_active_admin_user!
    authenticate_user!
    unless current_user.role?(:admin)
      flash[:alert] = "You are not authorized to access this resource!"
      redirect_to root_path
    end
  end

  # CanCan can
  rescue_from CanCan::AccessDenied do |exception|
    # http://stackoverflow.com/questions/4407719/rails-flash-message-is-not-shown
    flash[:alert] = exception.message
    redirect_to root_url, :alert => exception.message
  end

  def raise_not_found!
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  rescue_from ActionController::RoutingError, :with => :render_404

  def render_404
    render :template => "errors/404", :status => 404
  end

end
