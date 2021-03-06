module GruntSinatra
  module Routes
    class Base < Sinatra::Application
      configure do
        set :root, File.expand_path('../../../', __FILE__)

        disable :method_override
        disable :protection
        disable :static

        set :erb, escape_html: true

        enable :use_code
      end

      configure :development, :test do
        set :views, 'app/views/development'

        set :erb,
            layout_options: { views: 'app/views/development/layouts' }
      end

      configure :production do
        set :views, 'app/views/production'

        set :erb,
            layout_options: { views: 'app/views/production/layouts' }
      end

      set(:auth) do |check|
        condition do
          unless signed_in? || check.nil?
            redirect "/login", 303
          end
        end
      end

      before do
        @user ||= User.get(session[:user_id])
      end

      helpers Helpers
      helpers Sinatra::ContentFor
    end
  end
end
