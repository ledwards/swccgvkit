Role.create(:name => "owner")
admin_role = Role.create(:name => "admin")
Role.create(:name => "card admin")
admin = User.new(:email => "admin@swccgvkit.com", :password => "password", :password_confirmation => "password")
admin.roles << admin_role
admin.save!

files = ["#{Rails.root}/db/lightside.cdf", "#{Rails.root}/db/darkside.cdf"]
files.each do |curfile|
  file = File.new(curfile,"r")
  while (line = file.gets)
    importer = CardImporter.new
    card = importer.import(line)
    card.save!
  end
  file.close
end