require 'memcache'

module DCruise
  class TestQueue
    module Audition
      attr_reader :total_transport_cost
    
      def push(*args)
        recording_time_cost { super(*args) }
      end
    
      def get(*args)
        recording_time_cost { super(*args) }
      end
    
      def recording_time_cost(&block)
        start = Time.now
        ret = yield
        @total_transport_cost ||= 0
        @total_transport_cost += Time.now - start
        ret      
      end
    end
  
    attr_reader :name
  
    def initialize(name, queue_servers)
      @name = name
      @endpoint = MemCache.new(queue_servers)
    end
  
    def push(test_name)
      @endpoint.set(name, test_name)
    end
  
    def get
      @endpoint.get(name)
    end
  end
end

