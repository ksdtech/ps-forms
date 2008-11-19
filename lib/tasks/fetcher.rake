namespace :fetcher do

  desc "process lost password emails"
  task :fetch => :environment do
    fetcher = Fetcher.create(:type => APP_CONFIG[:inbox_type],
      :receiver => EmailResponder.new,
      :server => APP_CONFIG[:inbox_server],
      :port => APP_CONFIG[:inbox_port],
      :ssl => APP_CONFIG[:inbox_ssl],
      :username => APP_CONFIG[:inbox_user],
      :password => APP_CONFIG[:inbox_password])
    fetcher.fetch
  end

end