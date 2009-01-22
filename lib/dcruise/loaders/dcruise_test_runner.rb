#!/usr/bin/env ruby
queue_name = ARGV.shift
queue_servers = ARGV.shift.split(",")
ARGV.each { |f| load f unless f =~ /^-/  }

require File.dirname(__FILE__) + "/../test_queue.rb"
$queue = DCruise::TestQueue.new(queue_name, queue_servers)
$queue.extend(DCruise::TestQueue::Audition)

class Test::Unit::TestSuite
  def run(result, &progress_block)
    yield(STARTED, name)
    test_cases = collect_test_cases
    while test_name = $queue.get
      test = test_cases.detect { |test| test.name == test_name }
      test.run(result, &progress_block)
    end
    puts "\n"
    puts "Total cost in getting test from queue is #{$queue.total_transport_cost}s"
    yield(FINISHED, name)
  end
  
  def collect_test_cases
    @tests.inject([]) do |cases, test|
      test.respond_to?(:collect_test_cases) ? cases += test.collect_test_cases : cases << test
    end
  end
end
