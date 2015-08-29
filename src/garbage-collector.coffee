now = require 'performance-now'

# Responsible for cleaning up scopes and their data points.
# Does only clean the data points of the scopes and not the scopes itself.
# The reson for this is that the scopes are contextual objects that lives in user space and should for that reason be kept alive.
# I.e. if scopes would be removed, then it would not be possible to start/stop the profiler in runtime. Also since scopes may be externally referenced,
# theres no actual guarantee that they would be garbage collected by the node runtime.

class GarbageCollector

  constructor: (profiler, expireAfter, probeInterval) ->
    @profiler = profiler
    @expireAfter = expireAfter * 1000
    @probeInterval = probeInterval * 1000
    @started = false
    @probeTickId = null

  _cleanerProbe: () ->
    return if not @started

    timeNow = now()

    walkScope = (scope) =>
      keysToRemove = []

      for dataName, dataPoints of scope.data
        indexesToRemove = []

        for dataPoint, index in dataPoints
          if (timeNow - dataPoint.startTime) > @expireAfter
            indexesToRemove.push index

        # If the number of indexes to remove are same as the number of data points,
        # then just remove the whole key.
        if indexesToRemove.length is dataPoints.length
          keysToRemove.push dataName
        else
          # Remove keys in descending order because else the referencing index will be lost.
          for index in indexesToRemove.reverse()
            dataPoints.splice index, 1

      for key in keysToRemove
        delete scope.data[key]

      for name, subScope of scope.scopes
        walkScope subScope

    walkScope @profiler

    setTimeout @_cleanerProbe.bind(@), @probeInterval

  start: () ->
    return if @started
    return if @probeInterval <= 0
    @started = true
    @_cleanerProbe()

  stop: () ->
    return if not @started
    @started = false
    clearTimeout @probeTickId

  clean: () ->
    walkScope = (scope) ->
      scope.data = {}

      for name, subScope of scope.scopes
        walkScope subScope

    walkScope @profiler

module.exports = GarbageCollector
