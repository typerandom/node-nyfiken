path = require 'path'

# Responsible for hosting the web interface
# used to view/control the profiler.

class WebUI

  constructor: (profiler, basePath) ->
    @profiler = profiler
    @basePath = basePath

  _getOverview: (req, res, next) ->
    res.sendFile path.join("#{__dirname}/../ui/overview.html")

  _getScopes: (req, res, next) ->
    scopes = []

    for own name, scope of @profiler.scopes
      scopes.push scope.copy()

    res.json scopes

  serve: (app) ->
    app.get "#{@basePath}/scopes", @_getScopes.bind(@)
    app.get "#{@basePath}/", @_getOverview.bind(@)

module.exports = WebUI
