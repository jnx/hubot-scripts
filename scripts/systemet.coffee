# Allows Hubot to get information from Swedish Systembolaget.
#
# systemet search systemet for <name> - Returns a list of products, price and url to systembolagets homepage

module.exports = (robot) ->
  robot.hear /(search) (systemet) (for) (.*)/i, (msg) ->
    query  = msg.match[4]

    unless query
      msg.send "Please type in a name to search for\n\n"
      msg.send "hubot search systemet for pripps blå"
      return

    search_by_name query, msg

  search_by_name = (name, msg) ->
    msg
      .http("http://systemetapi.se/product.json")
      .query(name: name)
      .get() (error, response, body) ->
        resp = "";
        results = JSON.parse(body)
        if results.error
          results.error.errors.forEach (err) ->
            resp += err.message
        else
          results.data.forEach (item) ->
            resp += "#{item.name} - #{item.price} Kr (#{item.type}) - http://systmt.se/#{item.article_no}\n"
            
        resp = "No products found" if resp is ""

        msg.send resp