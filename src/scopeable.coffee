# Represents a object that can be scoped.

class Scopeable

  constructor: (baseClass, profiler) ->
    @baseClass = baseClass
    @profiler = profiler
    @scopes = {}

  scope: (name) ->
    if not (name of @scopes)
      @scopes[name] = new @baseClass name, @profiler
    return @scopes[name]

module.exports = Scopeable
