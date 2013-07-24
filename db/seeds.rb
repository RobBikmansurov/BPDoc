# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

PublicActivity.enabled = false
# access roles
Role.create!(:note => 'Просмотр информации по исполняемым ролям, участию в процессах, комментирование документов процесса', :name => 'user')
Role.create!(:note => 'Ведение документов, ролей, приложений, рабочих мест процесса, назначение исполнителей на роли', :name => 'owner')
Role.create!(:note => 'Ведение списка процессов, документов, ролей, рабочих мест, приложений', :name => 'analitic')
Role.create!(:note => 'Ведение списков рабочих мест и приложений, настройка системы', :name => 'admin')
Role.create!(:note => 'Ведение документов и директив', :name => 'author')
Role.create!(:note => 'Отвечает за хранение бумажных оригиналов, изменяет место хранения документа', :name => 'keeper')
Role.create!(:note => 'Ведение прав пользователей, настройка системы', :name => 'security')

puts "access roles created"
Role.pluck(:name)

# users
user1 = User.create(:displayname => 'Иванов И.И.', :username => 'ivanov', :email => 'ivanov@example.com', :password => 'ivanov')
user1.roles << Role.find_by_name(:author)
user1.roles << Role.find_by_name(:owner)
user2 = User.create(:displayname => 'Петров П.П.', :username => 'petrov', :email => 'petrov@example.com', :password => 'petrov')
user2.roles << Role.find_by_name(:author)
user3 = User.create(:displayname => 'Администратор', :username => 'admin1', :email => 'admin1@example.com', :password => 'admin1')
user3.roles << Role.find_by_name(:admin)
user3.roles << Role.find_by_name(:security)
user4 = User.create(:displayname => 'Сидоров С.С.', :username => 'petrov', :email => 'sidorov@example.com', :password => 'sidoriv')
user4.roles << Role.find_by_name(:author)
puts "users created"

# applications
['Office', 'Notepad', "Excel", 'Word', 'Powerpoint'].each do |name |
	Bapp.create(:name => name,
				:description => 'Microsoft ' + name + ' 2003',
				:apptype => 'офис',
				:purpose => 'редактирование ' + name)
end
ap1 = Bapp.create(:name => '1С:Бухгалтерия', :description => '1С:Бухгалтерия. Учет основных средств', :apptype => 'бух')
puts "applications created"

# workplaces
wp1 = Workplace.create(:name => 'РМ УИТ Начальник', :description => "начальник УИТ", :designation => 'РМУИТНачальник', :location => '100')
wp2 = Workplace.create(:name => 'Главный бухгалтер', :description => "Главный бухгалтер", :designation => 'РМГлБухгалтер', :location => '200')
["Кассир", "Бухгалтер", "Контролер", "Юрист", "Экономист"].each do |name|
	3.times do |n|
		n += 1
		Workplace.create(:name => 'РМ ' + name + n.to_s,
						 :description => 'рабочее место' + name + n.to_s,
						 :designation => name + n.to_s,
						 :location => n.to_s + '01')
  	end
end
puts "workplaces created"

PublicActivity.enabled = true