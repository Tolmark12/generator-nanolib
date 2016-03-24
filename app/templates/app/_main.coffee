example = require 'jade/example'

class <%= appName %>

  constructor: ($el) ->
    data  = { message: 'Live long and prosper.', source:'(See app/coffee/main.coffee)' }
    $node = $ example( data )
    $el.append $node

window.<%= nameSpace %> ||= {}
<%= nameSpace %>.<%= appName %> = <%= appName %>
