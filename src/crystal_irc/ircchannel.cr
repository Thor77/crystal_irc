require "./message"

module CrystalIRC
  class IRCChannel

    getter name
    def initialize @name
      @subscribers = [] of Proc(Message, Void)
    end

    def on_privmsg &block : Message -> Void
      @subscribers << block
    end

    def privmsg msg : Message
      @subscribers.each do |subscriber|
        subscriber.call msg
      end
    end

  end
end
