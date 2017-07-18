module CitiDash
  module Helpers
    def current_user
      user_token_attributes = request.env.values_at(:user)

      if user_token_attributes
        @user ||= User.find(id: user_token_attributes[0]["id"])
      else
        @user = nil
      end

      return @user
    end

    def json_result_wrapper(result, request)
      path = request.path
      params = request.params
      current_path = "#{path}?#{hash_to_query_string(params)}"

      response = {
        data: result,
        links: {
          self: current_path,
        }
      }

      response.to_json
    end

    def format_query_json_response(query, request)
      path = request.path
      params = request.params
      offset = params[:offset] ? params[:offset].to_i : 0
      limit = params[:limit] ? params[:limit].to_i : 100
      total = query.count
      query = query.limit(limit, offset)
      
      results = yield(query)

      response_body = {
        total: total,
        offset: offset,
        limit: limit,
        data: results
      }

      current_path = "#{path}?#{hash_to_query_string(params)}"
      params["offset"] = offset + limit
      next_path = "#{path}?#{hash_to_query_string(params)}"

      puts results.count

      response_body[:links] = {
        links: {
          self: current_path,
          next: (next_path if results.count == limit),
        }.reject{ |k,v| v.nil? }
      }

      response_body.to_json
    end

    private

    def hash_to_query_string(hash)
      hash.map { |k, v| "#{k}=#{v}&" }.join
    end
  end
end