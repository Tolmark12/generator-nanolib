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
        { type: 'input', name: 'name',      message: 'Name the project (Capitalize Each Word, Plus A Space):',           default: @appname}
        { type: 'input', name: 'nameSpace', message: 'Choose a namespace (defaults to `nanobox`):', default: 'nanobox'}
      ], ( (answers) ->
        @appname           = answers.name                                                       # Some Project Name
        @appNameLowerCase  = answers.name.toLowerCase().replace(/\s/gi, "-")                    # some-project-name
        @appNameCamel      = answers.name.replace(/\s/gi, "")                                   # SomeProjectName
        @appNameLowerCamel = @appNameCamel.charAt(0).toUpperCase() + @appNameCamel.slice(1);    # someProjectName
        @nameSpace         = answers.nameSpace
        @log "Creating : #{@nameSpace}.#{@appNameCamel}"

        done()
        return
      ).bind(this)
    )

  writing:
    app: ->
      @fs.copyTpl @templatePath("app/_main.coffee"),          @destinationPath("app/coffee/main.coffee"), {nameSpace:@nameSpace, appName:@appNameCamel}
      @fs.copy    @templatePath("app/_main.scss"),            @destinationPath("app/scss/main.scss")
      @fs.copy    @templatePath("app/_vars-and-utils.scss"),  @destinationPath("app/scss/_vars-and-utils.scss")
      @fs.copy    @templatePath("app/_example.jade"),         @destinationPath("app/jade/example.jade")
      @fs.copy    @templatePath("app/_example.jade"),         @destinationPath("app/jade/example.jade")
      @fs.write   @destinationPath("app/assets/assets-go-here.txt"), ""

    stage: ->
      @fs.copyTpl @templatePath("stage/_stage.coffee"),     @destinationPath("stage/stage.coffee"), {nameSpace:@nameSpace, appName:@appNameCamel}
      @fs.copy    @templatePath("stage/_stage.scss"),       @destinationPath("stage/stage.scss")
      @fs.copyTpl @templatePath("stage/_index.jade"),       @destinationPath("stage/index.jade"), {appName:@appname}

    projectfiles: ->
      # @fs.write    @destinationPath('app')
      @fs.copy    @templatePath("_gitignore"),                @destinationPath(".gitignore")
      @fs.copy    @templatePath("_gitignore"),                @destinationPath(".gitignore")
      @fs.copy    @templatePath("_gulpfile.js"),              @destinationPath("gulpfile.js")
      @fs.copyTpl @templatePath("_bower.json"),               @destinationPath("bower.json"), { appName:@appNameLowerCase }
      @fs.copy    @templatePath("_bowerrc.json"),             @destinationPath(".bowerrc")
      @fs.copy    @templatePath("_package.json"),             @destinationPath("package.json")

      # GULP FILE:
      # I had to move these two jade snippets out of the file because
      # they use the same <%= %> syntax that @fs.copyTpl() uses.
      jade1       =      "\"#{@appNameLowerCamel}['<%= file.relative.split('.')[0] %>'] = <%= file.contents %>;\\n\""
      jade2       =      "\"#{@appNameLowerCamel} = {};\\n<%= file.contents %>\""
      randomPort  = Math.floor( Math.random()*7000 ) + 3000
      @fs.copyTpl(
        @templatePath    "_gulpfile.coffee"
        @destinationPath "gulpfile.coffee"
        port:randomPort, jadeExp1:jade1, jadeExp2: jade2
      )

  end: ->
    @installDependencies()
)
