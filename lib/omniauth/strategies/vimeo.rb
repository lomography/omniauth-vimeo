require 'omniauth-oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    class Vimeo < OmniAuth::Strategies::OAuth
      option :name, 'vimeo'
      option :client_options, {:site => 'http://vimeo.com' }

      uid { user['id'] }

      info do
        {
          'nickname' => user['username'],
          'name' => user['display_name'],
          'location' => user['location'],
          'description' => user['bio'],
          'image' => user['portraits']['portrait'].select{|h| h['height'] == '300'}.first['_content'],
          'urls' => {
            'website' => user['url'],
            'vimeo' => user['profileurl']
          }
        }
      end

      extra do
        { 'user_hash' => user }
      end

      def user
        user_hash['person']
      end

      def user_hash
        url = "http://vimeo.com/api/rest/v2?method=vimeo.people.getInfo&format=json"
        @user_hash ||= MultiJson.decode(access_token.get(url).body)
      end
    end
  end
end