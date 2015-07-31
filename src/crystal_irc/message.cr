module CrystalIRC
  class Message

    getter type
    getter data
    getter host
    getter target

    private def parse(raw_message: String)
      parts = raw_message.split " "
      if parts[0][0] != ':'
        @type = parts[0]
        parts = parts[1..-1]
        @data = parts.join " "
      else
        @host = parts[0][1..-1]
        @type = parts[1]
        @target = parts[2]
        if parts.length < 4
          @data = nil
        else
          @data = parts[3, parts.length].join(" ")[1..-1]
        end
      end
    end

    def initialize(raw_message: String)
      @type = nil
      @data = nil
      @host = nil
      @target = nil
      parse raw_message
    end

    def self.pong ping_data
      "#{CrystalIRC::Message::PONG} #{ping_data}"
    end

    def self.user username, hostname, servername, realname
      "#{CrystalIRC::Message::USER} #{username} #{hostname} #{servername} :#{realname}"
    end

    def self.nick nick
      "#{CrystalIRC::Message::NICK} #{nick}"
    end

    def self.join channel
      channel = "#" + channel if channel[0] != '#'
      "#{CrystalIRC::Message::JOIN} #{channel}"
    end

    def self.part channel
      channel = "#" + channel if channel[0] != '#'
      "#{CrystalIRC::Message::PART} #{channel}"
    end

    def self.quit msg="Bye!"
      "#{CrystalIRC::Message::QUIT} :#{msg}"
    end

  end
end
