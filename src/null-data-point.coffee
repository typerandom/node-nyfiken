# Represents a data point that does nothing (null object)
# The reason for this is that in order to not break behaviour,
# we must, even when profiling is stopped be able to return a data point.

class NullDataPoint

  @instance: new NullDataPoint()

  start: () ->
    return false

  stop: () ->
    return false

  elapsed: () ->
    return 0

module.exports = NullDataPoint
