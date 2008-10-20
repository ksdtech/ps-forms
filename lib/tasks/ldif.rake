namespace :ldif do
  desc "create users and groups ldif files"
  task :all => :environment do
    User.ldif_add_users(File.new("#{Rails.root}/data/ldif/users.ldif", 'w'))
    Role.ldif_add_groups(File.new("#{Rails.root}/data/ldif/groups.ldif", 'w'))
  end

  task :update_groups => :environment do
    Role.ldif_modify_group_users(File.new("#{Rails.root}/data/ldif/groups.ldif", 'w'))
  end
  
  task :update_groups => :environment do
    Role.ldif_modify_group_users(File.new("#{Rails.root}/data/ldif/mod_groups.ldif", 'w'))
  end
end
