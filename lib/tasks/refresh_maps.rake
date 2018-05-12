namespace :routes do
  desc 'Refresh Route Maps'
  task :refresh_maps => :app do
    total = Route.count

    Route.all.each_with_index do |route, i|
      puts "Route #{i+1}/#{total} - ID: #{route.id}"
      mapper = RouteMapperWorker.perform_async(route.id)
    end
  end
end