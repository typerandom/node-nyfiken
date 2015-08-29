now = require 'performance-now'

# Represents a profile used to track a certain measurement.

class DataPoint

  constructor: (metadata) ->
    @metadata = metadata
    @startTime = 0
    @stopTime = 0

  start: () ->
    @startTime = now()

  stop: () ->
    @stopTime = now()

  elapsed: () ->
    return (@startTime - @stopTime).toFixed(3)

module.exports = DataPoint
