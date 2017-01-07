module Lorikeet
  class Observable
    def initialize(context, observers = [])
      @context   = context
      @observers = observers
    end

    def include?(observer)
      observers.include?(observer)
    end

    def <<(observer)
      observers << observer unless observers.include?(observer)
    end

    def delete(observer)
      observers.delete(observer)
    end

    def action
      yield(context)

      observers.each { |o| o.send(o.callback_id, context) }
    end

    private

    attr_reader :context, :observers
  end

  module Observer
    DEFAULT_CALLBACK_ID = :callback

    def observe(observable, callback_id = nil)
      if callback_id
        self.callback_id = callback_id
      end

      observable << self
    end

    def callback_id
      @callback_id ||= DEFAULT_CALLBACK_ID
    end

    def callback_id=(sym)
      @callback_id = sym
    end
  end
end
