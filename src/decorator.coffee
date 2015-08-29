_ = require 'lodash'
{Promise} = require 'bluebird'

# Represents a decorator used for automatic decorating/profiling of objects in runtime.
# This instance is what is returned when calling profiler.decorate().

forwardMissingMembers = (source, destination, handler) ->
  for member, sourceMethod of source then do (member, sourceMethod) ->
    if not destination[member]? and _.isFunction(sourceMethod)
      destination[member] = (args...) ->
        return handler member, args, sourceMethod.bind(source)

class Decorator

  constructor: (scope, source) ->
    forwardMissingMembers source, this, (memberName, args, sourceMethod) ->
      [newArgs..., callback] = args

      # Check if this is a call with a callback, then inject our
      # own back into the call so that we can intercept it
      if _.isFunction callback
        callback = scope.intercept memberName, primaryArgs, callback
        newArgs.unshift callback
        return sourceMethod.apply source, newArgs
      else
        # This is either a regular call or a call that returns a promise...
        # If it returns a promise then tap into it and wait for it to end.
        dataPoint = scope.newDataPoint memberName, args

        dataPoint.start()
        result = sourceMethod.apply source, args

        if result instanceof Promise
          result.tap () -> dataPoint.stop()
        else
          dataPoint.stop()

        return result

module.exports = Decorator
