
module.exports = (robot) ->
  robot.respond /weather (.*)/i, (msg) ->
    query = msg.match[1]
    getLocation msg, query, (data) ->
      msg.reply data  

  robot.respond /forecast (.*)/i, (msg) ->
    query = msg.match[1]
    getForecastLocation msg, query, (data) ->
      msg.reply data


  getLocation = (msg, query, cb) ->
    msg.http("https://maps.googleapis.com/maps/api/geocode/json")
      .header('User-Agent', 'Hubot Geocode Location Engine')
      .query({
        address: query
        sensor: false
      })
      .get() (err, res, body) ->
        response = JSON.parse(body)
        return cb "Please enter a valid location/address" unless response.results?.length
        location = response.results[0].geometry.location
        cb "Here is the weather information for #{response.results[0].formatted_address}"

        getWeatherInfo msg, location, (weather) ->
          msg.send weather


  getWeatherInfo = (msg, location, cb) ->

    getWeatherIcon msg, location, (img) ->
      msg.send "*Current weather image:*  #{img}"

    latlon = location.lat + "," + location.lng
    msg.http("https://api.forecast.io/forecast/34863e86b2490d15e8c361fb826adcad/"+latlon)
      .get() (err, res, body) ->
        try
          result = JSON.parse(body)
          cb "*Current Weather Information:*  #{result.currently.summary} with a temperature of #{result.currently.temperature}°F \n *Next one hour's weather:* #{result.hourly.data[0].summary} with a temperature of #{result.hourly.data[0].temperature}°F\n *Next two hour's weather:* #{result.hourly.data[1].summary} with a temperature of #{result.hourly.data[1].temperature}°F\n"
        catch error
          msg.send "Weather Info currently not available, it may be due to poor internet connection"


  getWeatherIcon = (msg, location, cb) ->
    lat = location.lat
    lon = location.lng
    latlng = "lat="+lat+"&lon="+lon
    msg.http("http://api.openweathermap.org/data/2.5/weather?lat="+latlng)
      .get() (err, res, body) ->
        try
          result = JSON.parse(body)
          cb "http://openweathermap.org/img/w/"+ result.weather[0].icon+".png"
        catch error
          msg.send "" 


  getForecastLocation = (msg, query, cb) ->
    msg.http("https://maps.googleapis.com/maps/api/geocode/json")
      .header('User-Agent', 'Hubot Geocode Location Engine')
      .query({
        address: query
        sensor: false
      })
      .get() (err, res, body) ->
        response = JSON.parse(body)
        return cb "Please enter a valid location/address" unless response.results?.length
        location = response.results[0].geometry.location.lat + "," + response.results[0].geometry.location.lng
        cb "Here is the forecast information for #{response.results[0].formatted_address}"
        lookupForecast msg, location, (forecast) ->
          msg.send forecast


  lookupForecast = (msg, location, cb) ->
    console.log "location: #{location}"
    msg.http("https://api.forecast.io/forecast/34863e86b2490d15e8c361fb826adcad/#{location}")
      .get() (err, res, body) ->
        try
          body = JSON.parse(body)
          forecast = body.daily.data
          today = forecast[0].summary
          tomorrow = forecast[1].summary
          nextTwoDays = forecast[2].summary
          nextThreeDays = forecast[3].summary
          nextFourDays = forecast[4].summary
          console.log "body #{tomorrow}"
          cb "Tomorrow: #{tomorrow} \n Next Two Days: #{nextTwoDays} \n Next Three Days: #{nextThreeDays} \n Next Four Days: #{nextFourDays}"
          # cb "*Tomorrow* #{tomorrow} ,\n *Next Two Days* #{nextTwoDays} ,\n *Next Three Days* #{nextThreeDays} ,\n *Next Four Days* #{nextFourdays}"
        catch err
          msg.send "Forecast Info currently not available"
        cb(msg, location)
