module Api

  def get_forecast(user)
    latitude = user.latitude
    longitude = user.longitude
    url = "https://api.forecast.io/forecast/b20ed2cf518265035a434036f7522627/#{latitude},#{longitude}"
    response = JSON.parse(HTTParty.get(url).body)
    temperature = response["currently"]["temperature"]
    summary = response["currently"]["summary"].downcase

    # if temperature < 50 
    #   return "Your weather forecast for today is #{temperature} degrees and #{summary}. That's pretty chilly. Better not forget your coat!"
    # elseif temperature > 
    #   return "Your weather forecast for today is #{temperature} degrees and #{summary}"
    # end

    case  
      when temperature < 0 
        "Your weather forecast for today is #{temperature} degrees and #{summary}. That's freezing! Stay where you are, I'm on my way with soup."
      when temperature < 25 &&  temperature > 0 
        "Your weather forecast for today is #{temperature} degrees and #{summary}. Don't even think about leaving home without a scarf."
      when temperature < 50 && temperature > 25
        "Your weather forecast for today is #{temperature} degrees and #{summary}. That's pretty chilly. Better not forget your coat!"
      when temperature < 70 && temperature > 50 
        "Your weather forecast for today is #{temperature} degrees and #{summary}. Do your mother a favor, grab a sweater."
      when temperature > 70 
        "Your weather forecast for today is #{temperature} degrees and #{summary}. Who's hungry?"
      end
  end

  def send_weather_texts
    account_sid = 'ACfb7ac7ffa3b4d03c419ae4d98c32afd6'
    auth_token = '63c3b515f991dd71c83cf9bf47031bca'

    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token

    users = User.all
    users.each do |user|
      forecast = get_forecast(user)
      @client.account.messages.create(
        :from => '+16463623947',
        :to => user.phone_number,
        :body => "It's Mom!  I know you don't check the weather, so here you go: " + forecast
      )
    end
  end

end