namespace :export do
  desc "create users and groups ldif files"
  task :ldif => :environment do
    User.ldif_add_users(File.new("#{Rails.root}/data/ldif/users.ldif", 'w'))
    Role.ldif_add_groups(File.new("#{Rails.root}/data/ldif/groups.ldif", 'w'))
  end

  desc "export all schoolwires users"
  task :sw_all => :environment do
    staff_users = User.find(:all, :conditions => ['access_type IS NULL and staff_id IS NOT NULL'])
    User.export_sw_users(staff_users, "#{Rails.root}/data/staff_users.csv", "#{Rails.root}/data/UserInformation.csv")
    parent_users = User.find(:all, :conditions => ['access_type IS NULL and staff_id IS NULL'])
    User.export_sw_users(parent_users, "#{Rails.root}/data/parent_users.csv", "#{Rails.root}/data/UserInformation.csv")
  end

  desc "export staff schoolwires users"
  task :sw_staff => :environment do
    staff_users = User.find(:all, :conditions => ['access_type IS NULL and staff_id IS NOT NULL'])
    User.export_sw_users(staff_users, "#{Rails.root}/data/staff_users.csv")
  end

  desc "export parent schoolwires users"
  task :sw_parents => :environment do
    parent_users = User.find(:all, :conditions => ['access_type IS NULL and staff_id IS NULL'])
    User.export_sw_users(parent_users, "#{Rails.root}/data/parent_users.csv")
  end

  desc "export family schoolwires users"
  task :sw_families => :environment do
    parent_users = User.find(:all, :conditions => ['access_type IN (?)', ['primary','secondary']])
    User.export_sw_users(parent_users, "#{Rails.root}/data/family_users.csv")
  end

end
