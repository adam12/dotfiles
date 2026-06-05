# Subscribes to one event on an EventEmitter and records its payloads, so a test
# can assert on everything an adapter emitted (its observable outputs).
class OutputTracker
  attr_reader :data

  def initialize(emitter, event)
    @data = []
    emitter.on(event) { |payload| @data << payload }
  end

  def clear
    result = @data.dup
    @data.clear
    result
  end
end
