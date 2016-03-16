'use strict'
yeoman = require('yeoman-generator')
chalk  = require('chalk')
yosay  = require('yosay')

module.exports = yeoman.generators.Base.extend(

  initializing: ->
    @pkg = require('../package.json')

  prompting: ->
    # Have Yeoman greet the user.
    @log yosay 'Welcome to the extraordinary ' + chalk.red('YoGulp') + ' generator!'
    done = @async()
    @prompt(
      [
        { type: 'input', name: 'name',      message: 'Name the Project (Sentance Case):',           default: @appname}
        { type: 'input', name: 'nameSpace', message: 'Choose a namespace (defaults to `nanobox`):', default: 'nanobox'}
      ], ( (answers) ->
        @nameSpace        = answers.nameSpace
        @appname          = answers.name
        @appNameLowerCase = answers.name.toLowerCase().replace(/\s/gi, "-")
        @appNameCamel     = answers.name.replace(/\s/gi, "")
        @log "Creating : #{@nameSpace}.#{@appNameCamel}"

        done()
        return
      ).bind(this)
    )


  writing:
    app: ->
      @fs.copyTpl @templatePath("app/_main.js"),              @destinationPath("app/js/main.js"), {nameSpace:@nameSpace, appName:@appNameCamel}
      @fs.copy    @templatePath("app/_main.scss"),            @destinationPath("app/scss/main.scss")
      @fs.copy    @templatePath("app/_vars-and-utils.scss"),  @destinationPath("app/scss/_vars-and-utils.scss")
      @fs.copy    @templatePath("app/_example.jade"),         @destinationPath("app/jade/example.jade")
      @fs.copy    @templatePath("app/_example.jade"),         @destinationPath("app/jade/example.jade")
      @fs.write   @destinationPath("app/images/images-go-here.txt"), ""

    stage: ->
      @fs.copyTpl @templatePath("stage/stage.js"),          @destinationPath("stage/stage.js"), {nameSpace:@nameSpace, appName:@appNameCamel}
      @fs.copy    @templatePath("stage/stage.scss"),       @destinationPath("stage/stage.scss")
      @fs.copyTpl @templatePath("stage/index.jade"),       @destinationPath("stage/index.jade"), {appName:@appname}

    projectfiles: ->
      # @fs.write    @destinationPath('app')
      @fs.copy    @templatePath("_gitignore"),                @destinationPath(".gitignore")
      @fs.copy    @templatePath("_gulpfile.js"),              @destinationPath("gulpfile.js")
      @fs.copy    @templatePath("_gitignore"),                @destinationPath(".gitignore")
      @fs.copy    @templatePath("_gulpfile.js"),              @destinationPath("gulpfile.js")
      @fs.copy    @templatePath("_bower.json"),               @destinationPath("bower.json")
      @fs.copyTpl @templatePath("_bower.json"),               @destinationPath("bower.json"), { appName:@appNameLowerCase }
      @fs.copy    @templatePath("_bowerrc.json"),             @destinationPath(".bowerrc")
      @fs.copy    @templatePath("_package.json"),             @destinationPath("package.json")

      # GULP FILE:
      # I had to move these two jade snippets out of the file because
      # they use the same <%= %> syntax that @fs.copyTpl() uses.
      jade1       =      "\"jadeTemplate['<%= file.relative.split('.')[0] %>'] = <%= file.contents %>;\\n\""
      jade2       =      "\"jadeTemplate = {};\\n<%= file.contents %>\""
      randomPort  = Math.floor( Math.random()*7000 ) + 3000
      @fs.copyTpl(
        @templatePath    "_gulpfile.coffee"
        @destinationPath "gulpfile.coffee"
        port:randomPort,  jadeExp1:jade1, jadeExp2: jade2
      )

  end: ->
    @installDependencies()
)
