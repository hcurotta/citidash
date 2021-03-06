module CitiDash
  module Routes
    class Users < Base
      use JwtAuth

      def user_response(user)
        if user != current_user
          routes_in_common = RouteQueries.routes_in_common(user, current_user).limit(5).to_a
          routes_in_common.map! do |result|
            {
              id: result[:route_id],
              trip_count: result[:trip_count],
              origin: {
                id: result[:origin_id],
                name: result[:origin_name],
                lat: result[:origin_lat],
                lng: result[:origin_lon]
              },
              destination: {
                id: result[:destination_id],
                name: result[:destination_name],
                lat: result[:destination_lat],
                lng: result[:destination_lon]
              },
              maps: {
                thumb: result[:route_map_thumb],
                small: result[:route_map_small],
                large: result[:route_map_large]
              }
            }
          end

          friendship = Friendship.find(user_id: current_user.id, friend_id: user.id)

          if friendship
            friendship = {
              id: friendship.id,
              status: friendship.status
            }
          end
        else
          routes_in_common = []
          friendship = nil
        end

        favourite_routes = RouteQueries.routes_for(user.id, 'order_by' => 'trip_count').limit(5).to_a
        favourite_routes.map! do |result|
          {
            id: result[:route_id],
            trip_count: result[:trip_count],
            origin: {
              id: result[:origin_id],
              name: result[:origin_name],
              lat: result[:origin_lat],
              lng: result[:origin_lon]
            },
            destination: {
              id: result[:destination_id],
              name: result[:destination_name],
              lat: result[:destination_lat],
              lng: result[:destination_lon]
            },
            maps: {
              thumb: result[:route_map_thumb],
              small: result[:route_map_small],
              large: result[:route_map_large]
            }
          }
        end

        latest_trips = TripQueries.trips_for(user.id).limit(5).to_a
        latest_trips.map! do |result|
          {
            id: result[:trip_id],
            started_at: result[:started_at],
            ended_at: result[:ended_at],
            duration_in_seconds: result[:duration_in_seconds],
            route: {
              id: result[:route_id],
              origin: {
                id: result[:origin_id],
                name: result[:origin_name],
                lat: result[:origin_lat],
                lon: result[:origin_lon]
              },
              destination: {
                id: result[:destination_id],
                name: result[:destination_name],
                lat: result[:destination_lat],
                lon: result[:destination_lon]
              },
              maps: {
                thumb: result[:route_map_thumb],
                small: result[:route_map_small],
                large: result[:route_map_large]
              }
            }
          }
        end

        {
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          name: user.short_name,
          friendship: friendship,
          avatar: {
            id: user.avatar_id,
            url: user.avatar.url
          },
          stats: {
            trip_count: user.trips.count,
            total_duration: user.trips.pluck(:duration_in_seconds).inject(:+),
            total_distance: ((user.trips.pluck(:duration_in_seconds).inject(:+) || 0) / 3600 * 7.45).ceil
          },
          last_refreshed_at: user.last_refreshed_at,
          latest_trips: latest_trips,
          favourite_routes: favourite_routes,
          routes_in_common: routes_in_common
        }.to_json
      end

      get '/user' do
        user_response(current_user)
      end

      get '/users/:id' do
        user = User.find(id: params['id'])
        user_response(user)
      end

      get '/users' do
        users = UserQueries.find_user(params['query'], current_user.id)

        format_query_json_response(users, request) do |users|
          users.map do |user|
            {
              id: user[:id],
              first_name: user[:first_name],
              last_name: user[:last_name],
              name: user[:short_name],
              avatar: {
                id: user[:user_avatar_id],
                url: user[:user_avatar_url]
              },
              friendship: {
                id: user[:friendship_id],
                status: user[:friendship_status]
              }
            }
          end
        end
      end

      get '/users/:id/routes' do
        query = RouteQueries.routes_for(params['id'], params)

        format_query_json_response(query, request) do |results|
          results.map do |result|
            {
              id: result[:route_id],
              trip_count: result[:trip_count],
              last_trip_ended_at: result[:last_trip_ended_at],
              origin: {
                id: result[:origin_id],
                name: result[:origin_name],
                lat: result[:origin_lat],
                lon: result[:origin_lon]
              },
              destination: {
                id: result[:destination_id],
                name: result[:destination_name],
                lat: result[:destination_lat],
                lon: result[:destination_lon]
              },
              maps: {
                thumb: result[:route_map_thumb],
                small: result[:route_map_small],
                large: result[:route_map_large]
              }
            }
          end
        end
      end

      get '/users/:id/trips' do
        query = TripQueries.trips_for(params['id'], params)

        format_query_json_response(query, request) do |results|
          results.map do |result|
            {
              id: result[:trip_id],
              started_at: result[:started_at],
              ended_at: result[:ended_at],
              duration_in_seconds: result[:duration_in_seconds],
              route: {
                id: result[:route_id],
                origin: {
                  id: result[:origin_id],
                  name: result[:origin_name],
                  lat: result[:origin_lat],
                  lon: result[:origin_lon]
                },
                destination: {
                  id: result[:destination_id],
                  name: result[:destination_name],
                  lat: result[:destination_lat],
                  lon: result[:destination_lon]
                },
                maps: {
                  thumb: result[:route_map_thumb],
                  small: result[:route_map_small],
                  large: result[:route_map_large]
                }
              }
            }
          end
        end
      end

      get '/users/:id/friendships' do
        friendships = Friendship.where(user_id: params['id']).eager(:friend)

        if params['status']
          friendships = friendships.where(status: params['status'])
        end

        format_query_json_response(friendships, request) do |friendships|
          friendships.map do |friendship|
            {
              id: friendship.id,
              status: friendship.status,
              user: {
                id: friendship.friend.id,
                first_name: friendship.friend.first_name,
                last_name: friendship.friend.last_name,
                name: friendship.friend.short_name,
                avatar: {
                  id: friendship.friend.avatar_id,
                  url: friendship.friend.avatar.url
                },
              }
            }
          end
        end
      end

      put '/user' do
        halt 400 unless params['avatar_id']

        avatar = Avatar.find(id: params['avatar_id'])
        halt 404 unless avatar
        
        current_user.update(avatar_id: avatar.id)

        status 200
      end

      post '/refresh_data' do
        # temporarily disabled during dev
        # current_user.refresh_data!
        current_user.update(last_refreshed_at: Time.now)
        status 200
      end
    end
  end
end
