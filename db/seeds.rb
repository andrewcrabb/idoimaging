# Examples:
#   cities = City.create([{ name: "Chicago" }, { name: "Copenhagen" }])
#   Mayor.create(name: "Emanuel", city: cities.first)

unless Rails.env.development?
  puts "ERROR: Only run seed in development"
  exit
end

AuthorProgram.delete_all
ProgramFeature.delete_all
ReadProgramImageFormat.delete_all
WriteProgramImageFormat.delete_all
ImageFormat.delete_all
ProgramComponent.delete_all
Redirect.delete_all
Resource.delete_all
Version.delete_all
Feature.delete_all
Program.delete_all
Author.delete_all

# Bug in Ransack where id is 0 or 1.  https://github.com/activerecord-hackery/ransack/issues/502

Feature.create!(name: "dummy", value: "see_seeds_rb_1")
ImageFormat.create!(name: "dummy")
Feature.last.delete
ImageFormat.last.delete

# ---------------------------------------------------------------
# Features
# ---------------------------------------------------------------

specialities = [
  "Cardiac",
  "Neuro",
  "CT",
  "DTI",
  "MRI",
  "FMRI",
  "PET/NM",
  "Ultrasound",
]
specialities.each { |speciality| Feature.where(name: "speciality", value: speciality).first_or_create }

languages = [
  "C",
  "C++",
  "Perl",
  "Tcl",
  "Java",
  "Shell",
  "Matlab",
  "Delphi",
  "IDL",
  "C#",
  "Python",
  "Ruby",
  "PHP",
  "JavaScript",
  "R",
  "Lua",
  "Julia",
]
languages.each { |language| Feature.where(name: "language", value: language).first_or_create }

interfaces = [
  "GUI",
  "Command Line",
  "Browser",
  "Touch/Mobile",
  "Server",
]
interfaces.each { |interface| Feature.where(name: "interface", value: interface).first_or_create }

platforms = [
  "Windows",
  "Macintosh",
  "Linux",
  "iOS",
  "Android",
  "Web Client",
  "Web Service",
]
platforms.each { |platform| Feature.where(name: "platform", value: platform).first_or_create }

dicoms = [
  "C-GET",
  "C-MOVE",
  "C-FIND",
  "WADO",
  "QIDO",
]
dicoms.each { |dicom| Feature.where(name: "dicom", value: dicom).first_or_create }

# Functions
displays = [
  "Basic",
  "Intermediate",
  "Other",
]
displays.each { |display|  Feature.where(name: "display", value: display).first_or_create }

utilities = [
  "Convert",
  "Anonymize",
  "Header Dump",
  "Header Edit",
  "Header Compare",
  "Network Test",
  "Validate",
]
utilities.each { |utility|  Feature.where(name: "utility", value: utility).first_or_create }

networks = [
  "PACS Server",
  "PACS Client",
  "Web Server",
  "Web Start",
]
networks.each { |network| Feature.where(name: "network", value: network).first_or_create }

analyses = [
  "Modelling",
  "ROI/TAC",
]
analyses.each { |analysis| Feature.where(name: "analysis", value: analysis).first_or_create }

processings = [
  "Segmentation",
  "Registration",
  "Reslice",
  "Dynamic",
]
processings.each { |processing| Feature.where(name: "processing", value: processing).first_or_create }


