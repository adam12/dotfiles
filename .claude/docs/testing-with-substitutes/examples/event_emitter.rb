# Minimal pub/sub used by output-side adapters to expose what they did, so a test
# can observe outputs (via OutputTracker) instead of mocking the collaborator.
class EventEmitter
  def initialize
    @listeners = Hash.new { |hash, key| hash[key] = [] }
  end

  def on(event, &block)
    @listeners[event] << block
  end

  def emit(event, data = nil)
    @listeners[event].each { |listener| listener.call(data) }
  end
end
