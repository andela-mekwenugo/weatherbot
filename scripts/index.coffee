# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md


module.exports = (robot) ->

  # robot.hear /sparkbot/i, (res) ->
  #   # res.send "OK am good to go"
  #   res.reply "OK am good to go"


  # robot.respond /weather/i, (msg) ->
  #   msg.http("https://api.forecast.io/forecast/34863e86b249015e8c361fb826adcad/6.5070,3.3841")
  #     .get() (err, res, body) ->
  #       if err
  #         msg.send "error ( #{err})"
  #         return
  #       result = JSON.parse(body)
  #       msg.send "#{result}"



  robot.respond /weather/i, (msg) ->
    msg.http("https://api.forecast.io/forecast/34863e86b2490d15e8c361fb826adcad/6.5070,3.3841")
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)
          msg.send "Time Zone: #{json.timezone}\n
                    Temperature: #{json.currently.temperature}\n
                    Summary: #{json.currently.summary}\n
                    Precip Type: #{json.currently.precipType}\n"
        catch error
          msg.send "error:  ( #{err})"





  # <script src="//maps.googleapis.com/maps/api/js?libraries=weather,geometry,visualization&sensor=false&language=en&v=3.14"></script>

  if (location == "") {
    var getCurrentLocation = function(){
      if (navigator.Geolocationion) {
          navigator.geolocation.getCurrentPosition(function(position){
            console.log("Posiotion is-------", position);
            var currentPosition = position.coords;
            var lat= (currentPosition.latitude);
            var lon= (currentPosition.longitude);
            var latlon= (lat+","+lon);

            getWeatherInfo(latlon);
          });
      } else {
          alert("Geolocation is not enabled.");
      }
    };
  } else {
    console.log("Error--------");
    //convert location address to coordinates.

    // getWeatherInfo(latlon);
  }

  var getWeatherInfo = function(latlon) {
          
  };






  robot.respond /gem whois (.*)/i, (msg) ->
    gemname = escape(msg.match[1])
    msg.http("http://rubygems.org/api/v1/gems/#{gemname}.json")
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)
          msg.send "   gem name: #{json.name}\n
          owners: #{json.authors}\n
          info: #{json.info}\n
          version: #{json.version}\n
          downloads: #{json.downloads}\n"
        catch error
          msg.send "Gem not found. It will be mine. Oh yes. It will be mine. *sinister laugh*"


  robot.hear /check domain (.*)/i, (msg) ->
    domain = escape(msg.match[1])
    user = process.env.DNSIMPLE_USERNAME
    pass = process.env.DNSIMPLE_PASSWORD
    auth = 'Basic ' + new Buffer(user + ':' + pass).toString('base64');
    msg.http("https://dnsimple.com/domains/#{domain}/check")
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            msg.send "Sorry, #{domain} is not available."
          when 404
            msg.send "Cybersquat that s***!"
          when 401
            msg.send "You need to authenticate by setting the DNSIMPLE_USERNAME & DNSIMPLE_PASSWORD environment variables"
          else
            msg.send "Unable to process your request and we're not sure why :("






  # robot.respond /open the (.*) doors/i, (res) ->
  #   doorType = res.match[1]
  #   if doorType is "pod bay"
  #     res.reply "I'm afraid I can't let you do that."
  #   else
  #     res.reply "Opening #{doorType} doors"
  
  # robot.hear /I like pie/i, (res) ->
  #   res.emote "makes a freshly baked pie"
  
  # lulz = ['lol', 'rofl', 'lmao']
  
  # robot.respond /lulz/i, (res) ->
  #   res.send res.random lulz
  
  # robot.topic (res) ->
  #   res.send "#{res.message.text}? That's a Paddlin'"
  
  
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  
  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  
  # robot.respond /what is the answer to the ultimate question of life/, (res) ->
  #   unless answer?
  #     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   res.send "#{answer}, but what is the question?"
  
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  
  # annoyIntervalId = null
  
  # robot.respond /annoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  
  #   res.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  
  
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  
  #   robot.messageRoom room, "I have a secret: #{secret}"
  
  #   res.send 'OK'
  
  # robot.error (err, res) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  
  #   if res?
  #     res.reply "DOES NOT COMPUTE"
  
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  
  #   else
  #     res.reply 'Sure!'
  
  #     robot.brain.set 'totalSodas', sodasHad+1
  
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
