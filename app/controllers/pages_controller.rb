class PagesController < ApplicationController

  def home
    @programs_new_releases = Program.latest_added
    @programs_latest_versions = Version.latest_programs
    render "home"
  end

  def about
    render "about"
  end
end
