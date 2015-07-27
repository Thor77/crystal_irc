require "socket"
require "logger"
require "openssl"

module CrystalIRC

  class Connection
    property? connected

    def initialize(@host : String, @port=6667 : Int32, @ssl=false : Bool)
      @connected = false
      @queue = Channel(String).new
      @msg_channel = Channel(CrystalIRC::Message).new
      @subscriptions = {} of String => Array(Proc(CrystalIRC::Message, Void))
      @logger = Logger.new STDOUT
      @logger.level = Logger::DEBUG
      connect
    end

    def send msg: String
      @queue.send "#{msg}\r\n"
    end

    def on msg_type: String, &block : CrystalIRC::Message ->
      if @subscriptions.has_key? msg_type
        @subscriptions[msg_type] << block
      else
        @subscriptions[msg_type] = [block]
      end
    end

    private def receive_worker socket
      @logger.debug "Starting receive-worker"
      loop do
        raw_message = socket.gets.to_s
        if raw_message.length > 0
          @msg_channel.send CrystalIRC::Message.new raw_message
          @logger.debug ">>#{raw_message}"
        end
        sleep 0.25
      end
    end

    private def send_worker socket
      @logger.debug "Starting send-worker"
      loop do
        next_message = @queue.receive
        socket.puts next_message
        @logger.debug "<<#{next_message}"
      end
    end

    def eventloop
      @logger.debug "Starting eventloop"
      loop do
        msg = @msg_channel.receive
        if @subscriptions.has_key? msg.type
          @subscriptions[msg.type].each do |block|
            block.call(msg)
          end
        end
      end
    end

    def connect
      @logger.info "Connecting to #{@host}:#{@port}#{" (SSL enabled)" if @ssl}"

      socket = TCPSocket.new @host, @port
      socket = OpenSSL::SSL::Socket.new socket if @ssl

      # spawn fiber for receiving msg from sock and parsing them
      spawn receive_worker(socket)

      # spawn fiber for sending msg from queue
      spawn send_worker(socket)
    end
  end
end
