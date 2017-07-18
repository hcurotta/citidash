# CitiDash Backend

The CitiDash backend is a Sinatra application. 

## Development

To get up and running in dev

1. Install all the gems by running `bundle install`
2. run the development server with `foreman start -f Procfile` 
3. navigate to [0.0.0.0:5000](http://0.0.0.0:5000)

Note that foreman doesn't work all that well with pry-byebug, so to do debugging with that, it's best to run the server using `rackup`. This will run a server on port 9292.

To autoload new files on save so you don't have to keep rebooting the server, install the rerun gem and then call rerun in front of your server command. e.g.

1. `gem install rerun`
2. `rerun rackup`

To get a rails-style console run `bundle exec irb -r ./app.rb`

## Tests

Tests use rspec, run `rspec spec` to run the suite
