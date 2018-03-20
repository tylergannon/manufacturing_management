# frozen_string_literal: true
namespace :dev do
  desc "Run generator"
  task :generate do
    run  = :generate
    type = :scaffold
    name = :batch_feedback

    args = {
      integer: [
        :rancidity,
        :coloration,
        :thickness,
        :texture,
        :saltiness,
        :spiciness,
        :overall_impression,
        :appearance,
      ],
      references: [
        :batch,
        :user
      ],
      string: [
        :notes
      ]
    }

    args = args.collect do |type, cols|
      cols.collect do |col|
        "#{col}:#{type}"
      end.join(" ")
    end.join(" ")

    command = "rails #{run} #{type} #{name} #{args}"
    puts "Running command:\n#{command}"
    pipe = IO.popen(command)

    while (line = pipe.gets)
      print ">>>>"
      print line
    end
  end
end
