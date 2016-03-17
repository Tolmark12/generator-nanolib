class <%= appName %>

  constructor: ($el) ->
    data  = { message: 'Live long and prosper.', source:'(See app/coffee/main.js)' }
    $node = $ jadeTemplate['example']( data )
    $el.append $node

window.<%= nameSpace %> ||= {}
<%= nameSpace %>.<%= appName %> = <%= appName %>
