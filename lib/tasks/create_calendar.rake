# frozen_string_literal: true
namespace :calendar do
  desc "Create initial calendar and give users access."
  task create: :environment do
    if GoogleCalendar.any?
      puts "A calendar already exists.  We don't have the technology to manage multiple calendars yet."
    else
      puts "Creating Calendar."
      calendar = GoogleCalendar.create
      User.all.each do |user|
        puts "Granting Access to #{user.name}"
        calendar.users << user
      end
      puts "Resetting any existing calendar events to live on this event."
      GcalEvent.delete_all
      puts
      puts "Done."
      puts "*"
      puts "*"
      puts "* The share link for this calendar is #{calendar.share_link}"
      puts "*"
      puts "*"
    end
  end

  desc "Build Calendar Events For All Future Batches"
  task build_events: :environment do
    Batch.scheduled_batches.each do |batch|
      puts "Creating event for batch #{batch.batch_number}"
      batch.touch
    end
    puts "*"
    puts "*"
    puts "* The share link for this calendar is #{GoogleCalendar.first.share_link}"
    puts "*"
    puts "*"
  end

  desc "Build Calendar Events For All Batches"
  task all_events: :environment do
    Batch.all.each do |batch|
      puts "Creating event for batch #{batch.batch_number}"
      batch.touch
    end
    puts "*"
    puts "*"
    puts "* The share link for this calendar is #{GoogleCalendar.first.share_link}"
    puts "*"
    puts "*"
  end
end
