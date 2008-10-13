namespace :directory do
  desc "build a tab-delimited text directory for printing"
  task :text => :environment do
    Directory.output_text
  end

  desc "build a specially-delimited text directory for merging in MS Word"
  task :merge => :environment do
    Directory.output_merge
  end
end
