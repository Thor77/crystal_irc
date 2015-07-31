require "../src/crystal_irc"

b = CrystalIRC::Bot.new "CrystalIRCTest", "chat.freenode.net"
thorsraum = CrystalIRC::IRCChannel.new "#thorsraum"
b.add_channel thorsraum
thorsraum.on_privmsg do |msg|
  puts "got a message: #{msg.data}"
end
b.eventloop
