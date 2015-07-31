require "./connection"
require "./message"
require "./ircchannel"
require "./ircchannel_manager"

module CrystalIRC
  class Bot < Connection
    def initialize(nick : String, @host : String, @port=6667 : Int32, @ssl=false : Bool)
      # init connection
      super @host, @port, @ssl
      @channelmanager = IRCChannelManager.new
      @channelmanager.register_handlers self
      register_handlers
      # auth
      send Message.user nick, nick, nick, nick
      send Message.nick nick
    end

    def register_handlers
      # ping-handler
      on Message::PING do |msg|
        send Message.pong msg.data
      end
    end

    def add_channel channel : IRCChannel
      send Message.join channel.name
      @channelmanager.add_channel channel
    end

    def remove_channel channel: IRCChannel
      send Message.part channel.name
      @channelmanager.remove_channel channel
    end

  end
end
