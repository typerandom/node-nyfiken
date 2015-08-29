_ = require 'lodash'
{Promise} = require 'bluebird'

Decorator = require './decorator'
Scopeable = require './scopeable'
DataPoint = require './data-point'
NullDataPoint = require './null-data-point'

# Represents a profiler scope.

class Scope extends Scopeable

  constructor: (name, profiler) ->
    super(profiler)
    @data = {}
    @name = name
    @profiler = profiler
    @maxScopeSize = @profiler.maxScopeSize

  newDataPoint: (name, metadata) ->
    if not @profiler.started
      return NullDataPoint.instance

    dataPoint = new DataPoint metadata

    if not (name of @data)
      @data[name] = []

    if @data[name].length > @maxScopeSize
      @data[name].shift()

    @data[name].push dataPoint

    return dataPoint

  decorate: (name, source) ->
    return new Decorator @scope(name), source

  profile: (name, args...) ->
    [metadata..., target] = args

    dataPoint = @newDataPoint(name, metadata)

    dataPoint.start()
    target () ->
      dataPoint.stop()

    return dataPoint

  intercept: (name, args...) ->
    [metadata..., callback] = args

    handler = null
    dataPoint = @newDataPoint(name, metadata)
    stopProfile = dataPoint.stop.bind(dataPoint)

    if _.isFunction callback
      handler = (args...) ->
        stopProfile()
        callback.apply(null, args)
    else if callback instanceof Promise
      handler = callback.tap stopProfile
    else
      handler = stopProfile

    dataPoint.start()

    return handler

  copy: () ->
    scopes = []

    for own name, scope of @scopes
      scopes.push scope.copy()

    return {
      name: @name
      scopes: scopes
      data: @data
    }

module.exports = Scope
