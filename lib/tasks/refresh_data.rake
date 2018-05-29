namespace :user do
  desc 'Refresh Trip Data'
  task refresh_data: :app do
    total = User.count

    User.all.each_with_index do |user, i|
      puts "User #{i + 1}/#{total} - #{user.id}: #{user.first_name} #{user.last_name}"
      user.refresh_data!
    end
  end
end
