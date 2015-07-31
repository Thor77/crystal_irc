require "./connection"
require "./ircchannel"
require "./message"

module CrystalIRC
  class IRCChannelManager
    def initialize
      @channels = {} of String => IRCChannel
    end

    def get_channel channel_name : String
      @channels[channel.name]
    end

    def add_channel channel : IRCChannel
      @channels[channel.name] = channel
    end

    def remove_channel channel : IRCChannel
      @channels.delete channel.name
    end

    def register_handlers connection : Connection
      connection.on Message::PRIVMSG do |msg|
        msg_target = msg.target
        unless msg_target.is_a? Nil
          if msg_target.starts_with? '#'
            channel_message msg
          end
        end
      end
    end

    def channel_message msg : Message
      if @channels.has_key? msg.target
        @channels[msg.target].privmsg msg
      end
    end
  end
end
