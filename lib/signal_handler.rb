class SignalHandler
  def initialize(signal)
    @interruptible = true
    @enqueued     = [ ]
    trap(signal) do
      if @interruptible
        puts "Graceful shutdown..."
        puts "goodbye"
        exit 0
      else
        @enqueued.push(signal)
      end
    end
  end

  def dont_interrupt
    @interruptible = false
    @enqueued     = [ ]
    if block_given?
      yield
      allow_interruptions
    end
  end

  def allow_interruptions
    @interruptible = true
    @enqueued.each { |signal| Process.kill(signal, 0) }
  end
end