#!/usr/bin/env ruby

queue_name = ARGV.shift
queue_servers = ARGV.shift.split(",")

ARGV.each { |f| load f unless f =~ /^-/  }

require File.dirname(__FILE__) + "/../test_queue.rb"
$queue = TestQueue.new(queue_name, queue_servers)

class Test::Unit::TestCase
  def run(*args, &block)
    puts "push #{self.name}"
    $queue.push(self.name)
  end
end
