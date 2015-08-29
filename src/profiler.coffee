WebUI = require './web-ui'
Scope = require './scope'
Scopeable = require './scopeable'
GarbageCollector = require './garbage-collector'

# Represents a profiler.

class Profiler extends Scopeable

  constructor: (maxScopeSize = 100, gcExpireAfter = 5 * 60, gcProbeInterval = 1 * 60) ->
    super(Scope, @)
    @started = false
    @defaultScope = null
    @maxScopeSize = maxScopeSize
    @gc = new GarbageCollector @, gcExpireAfter, gcProbeInterval

  _getDefaultScope: () ->
    if @defaultScope is null
      @defaultScope = @scope "Default"
    return @defaultScope

  start: () ->
    return if @started
    @started = true
    @gc.start()

  stop: () ->
    return if not @started
    @started = false
    @gc.stop()
    @gc.clean()

  serveUI: (app, basePath = '/profiler') ->
    return if @ui
    @ui = new WebUI @, basePath
    @ui.serve app

  # Profiles an object by decorating all of its members.
  decorate: (name, source) ->
    return @_getDefaultScope().decorate(name, source)

  # Profiles a synchronous block of code.
  profile: (args...) ->
    return @_getDefaultScope().profile.apply(@defaultScope, args)

  # Profiles asynchronous blocks of code by intercepting either a callback or a promise.
  intercept: (args...) ->
    return @_getDefaultScope().intercept.apply(@defaultScope, args)

module.exports = Profiler
