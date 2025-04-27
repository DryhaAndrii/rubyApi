Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch('CLIENT_URL') 
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization'] # чтобы фронтенд мог получать JWT-токен
  end
end