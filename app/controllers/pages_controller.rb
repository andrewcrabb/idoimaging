class PagesController < ApplicationController

  def home
    @programs_new_releases = Program.latest_added
    @latest_versions = Version.latest_programs
    logger.debug("latest_versions #{@latest_versions.pluck(:date)} ")
    render "home"
  end

  def about
    render "about"
  end
end
