namespace :asana do
  desc "Update dashboard data from Asana"
  task update: :environment do
    Dashboard::Project.reload_all
  end
end
