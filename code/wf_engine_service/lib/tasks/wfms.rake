namespace :wfms do
  task create_db_if_non_existant: :environment do
    Rails.env = "development"
    begin
      ActiveRecord::Base.connection
    rescue ActiveRecord::NoDatabaseError
      Rake::Task["db:create"].invoke
      Rake::Task["db:migrate"].invoke
      Rake::Task["db:seed"].invoke
    else
      Rake::Task["db:migrate"].invoke
    end
  end
end
