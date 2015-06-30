namespace :input do

  desc "Collect input data"
  task collect: :environment do
    Input.collect_and_save
  end

  desc "Create daily plant animation"
  task animate: :environment do
    Input.create_animation
  end
end

