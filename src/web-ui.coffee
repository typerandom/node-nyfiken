path = require 'path'
express = require 'express'

# Responsible for hosting the web interface
# used to view/control the profiler.

class WebUI

  constructor: (profiler, basePath) ->
    @profiler = profiler
    @basePath = basePath

  _getScopes: (req, res, next) ->
    scopes = []

    for own name, scope of @profiler.scopes
      scopes.push scope.copy()

    res.json scopes

  _serveAPI: (app) ->
    app.get "#{@basePath}/api/scopes", @_getScopes.bind(@)

  _serveStaticAssets: (app) ->
    assetPath = path.join("#{__dirname}/../assets")
    app.use @basePath, express.static(assetPath)

  serve: (app) ->
    @_serveAPI app
    @_serveStaticAssets app

module.exports = WebUI
