# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Role.create(:name => "owner")
admin_role = Role.create(:name => "admin")
Role.create(:name => "card admin")

admin = User.new(:email => "admin@swccgvkit.com", :password => "password", :password_confirmation => "password")
admin.roles << admin_role
admin.save!