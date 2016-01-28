#!/usr/bin/env ruby

puts "Starting workflow engine..."

require 'rubygems'
require 'bunny'
require 'docker'
require 'json'
require 'thread'

require_relative 'docker_helper'
#require_relative 'messaging_service'
require_relative 'deployment_manager'
require_relative 'workflow_instance'

puts "Binding messaging service..."
#messaging_service = WorkflowEngine::MessagingService.new

@deployment_manager = WorkflowEngine::DeploymentManager.new(nil)
@wf_instances = []

module WorkflowEngine
  class WorfklowInstancesConsumer < Bunny::Consumer
    def initialize(ch, q)
      super
      on_delivery do |info, meta, payload|
        cnt = Docker::Container.create 'Cmd' => ["echo", "#{payload}"], 'Image' => 'alpine'
        cnt.start
      end
    end
  end

  class ServersConsumer < Bunny::Consumer
  end

  def self.run
    begin
      @bunny = Bunny.new(:host => "mom_service_1", :user => "masterarbeit", :password => "masterarbeit")
      @bunny.start
      at_exit {@bunny.close}
    rescue
      sleep 5
      retry
    end

    threads = []

    2.times do
      threads << Thread.new do
        ch = @bunny.create_channel
        exchange = ch.topic("wf_instances", :durable => true)
        q = ch.queue('wf_instances.wfengine')
        q.bind(exchange, routing_key: "wf_instances.#")
        consumer = WorkflowEngine::WorfklowInstancesConsumer.new(ch, q)
        q.subscribe_with(consumer, block: true)
      end

      threads << Thread.new do
        ch = @bunny.create_channel
        exchange = ch.topic("servers", :durable => true)
        q = ch.queue('servers.wfengine')
        q.bind(wf_instances_exchange, routing_key: "servers.#")
        consumer = WorkflowEngine::ServersConsumer.new(ch, q)
        q.subscribe_with(consumer, block: true)
      end
    end

    threads.map(&:join)
  end
end

WorkflowEngine.run


    # wfinstances_thread = Thread.new do
    #   channel ||= @bunny.create_channel
    #   wf_instances_exchange ||= channel.topic("wf_instances", :durable => true)
    #   wf_instances_exchange.publish("testmessage", routing_key: "wf_instances.test")

    #   channel.queue("wfinstances.wfengine").bind(wf_instances_exchange, routing_key: "wf_instances.test").subscribe(block: true) do |a,b,c|
    #     puts "message: #{c}"
    #   end
    # end
