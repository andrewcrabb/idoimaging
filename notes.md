Naked Emily Notes

'Programs' could be called 'Applications'

Have some introductory text - "Select one or more of the following"

Basic search can say:
** I want to...
** On file type...
** My computer is...


Trying to fix Foundation css problem

config/application.rb took out config.assets.paths
application.scss took out five-star-rating

Programs missing some or all of their images

mevis
mango
saturn
radiant
mricrogl
dvt
camino
papaya
brainbrowser
santesoft

p = Program.includes(:resources).find(6)
r = Program.find(7)

pr = p.resources.includes(:resource_type)    # Collection of ResourceType
pr.each { |r| puts r.resource_type.name }    # No db queries
pr.includes(:resource_type).where(resource_types: {name: 'home_url'})  # Calls db
pr.where(resource_types: {name: 'home_url'})  # Calls db
Current database fields:

Program: name, summary, description, add_date, remove_date

+---------------+-----------------+------+-----+------------+-------+
| Field         | Type            | Null | Key | Default    | Goes to
+---------------+-----------------+------+-----+------------+-------+
| ident         | int(6) unsigned | NO   | PRI | 0          | -
| name          | varchar(30)     | YES  | MUL | NULL       | Program
| summ          | text            | YES  |     | NULL       | Program
| descr         | text            | YES  |     | NULL       | Program
| rev           | varchar(10)     | NO   |     |            | -
| rdate         | date            | NO   |     | 0000-00-00 | -
| auth          | int(6)          | YES  | MUL | NULL       | Program id
| plat          | bigint(20)      | YES  |     | NULL       | Feature
| lang          | bigint(20)      | YES  |     | NULL       | Feature
| func          | bigint(20)      | YES  |     | NULL       | Feature
| prer          | bigint(20)      | YES  |     | NULL       | -
| srcurl        | varchar(100)    | YES  |     | NULL       | Resource
| srcstat       | int(4)          | YES  |     | 0          | -
| homeurl       | varchar(100)    | YES  |     | NULL       | Resource
| linkcnt       | int(5)          | NO   |     | 0          | -
| revurl        | varchar(100)    | YES  |     | NULL       | Resource
| revstr        | varchar(40)     | YES  |     | NULL       | -
| revtrust      | int(1)          | NO   |     | 0          | -
| urlstat       | int(5)          | NO   |     | 0          | -
| urldate       | date            | NO   |     | NULL       | -
| counturl      | varchar(100)    | NO   |     |            | Resource
| readfmt       | bigint(20)      | YES  |     | NULL       | Feature
| writfmt       | bigint(20)      | YES  |     | NULL       | Feature
| adddate       | date            | NO   | MUL | 0000-00-00 | Program
| remdate       | date            | NO   | MUL | 0000-00-00 | Program
| visdate       | date            | NO   |     | 0000-00-00 | Program
| capture       | varchar(40)     | NO   |     |            | -
| interface     | int(4)          | NO   |     | 0          | Feature
| category      | bigint(11)      | NO   | MUL | 0          | Feature
| feature       | bigint(20)      | NO   |     | 0          | Feature
| percentile    | int(3)          | NO   | MUL | 0          | -
| homestr       | varchar(100)    | NO   |     | NULL       | -
| installer     | int(11)         | NO   |     | NULL       | -
| obtain        | int(11)         | NO   |     | NULL       | -
| audience      | int(11)         | NO   |     | NULL       | -
| rank_activity | int(11)         | NO   |     | NULL       | Rating
| rank_appear   | int(11)         | NO   |     | NULL       | Rating
| rank_doc      | int(11)         | NO   |     | NULL       | Rating
| rank_scope    | int(11)         | NO   |     | NULL       | Rating
| rank_overall  | int(11)         | NO   |     | NULL       | Rating
+---------------+-----------------+------+-----+------------+-------+

Author: name_last, name_first, institution, country
Resource: type 'home_url': home

mysql> describe author;
+-------------+-----------------+------+-----+---------+-------+
| Field       | Type            | Null | Key | Default | Extra |
+-------------+-----------------+------+-----+---------+-------+
| ident       | int(6) unsigned | NO   | PRI | 0       |       |
| name_last   | varchar(40)     | NO   | MUL |         |       |
| name_first  | varchar(20)     | NO   | MUL |         |       |
| institution | varchar(30)     | NO   |     |         |       |
| email       | varchar(50)     | YES  |     | NULL    |       |
| home        | varchar(50)     | YES  |     | NULL    |       |
| urlstat     | int(4)          | YES  |     | 0       |       |
| country     | char(2)         | NO   |     | NULL    |       |
+-------------+-----------------+------+-----+---------+-------+