class <%= appName %> {

  constructor( $el ) {
    let data  = { message: 'Live long and prosper.', source:'(See app/coffee/main.js)' }
    let $node = $( jadeTemplate['example']( data ) )
    $el.append( $node )
  }

}

if( window.<%= nameSpace %> === undefined ){ window.<%= nameSpace %> = {} }
<%= nameSpace %>.<%= appName %> = <%= appName %>
