class PagesController < ApplicationController

  def home
    @programs = Program.latest_added
    render "home"
  end

  def about
    render "about"
  end
end
