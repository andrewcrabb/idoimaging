class PagesController < ApplicationController

  def home
    @programs_new_releases = Program.latest_added
    @programs_latest_versions = Version.latest_programs
    render "home"
  end

  def about
    render "about"
  end

  def turku_2017
    render "pages/turku_2017/turku_2017"
  end

end
