Scope = require './scope'

# Represents a object that can be scoped.

class Scopeable

  constructor: (profiler) ->
    @profiler = profiler
    @scopes = {}

  scope: (name) ->
    if not (name of @scopes)
      @scopes[name] = new Scope name, @profiler
    return @scopes[name]

module.exports = Scopeable
