# README

Useful queries:

Count of resources per program
Program.joins(:resources).group("programs.name").count("resources.id")

Count of source urls per program
Program.joins(:resources).where("resources.resource_type_id = 2").group("programs.name").count("resources.id")