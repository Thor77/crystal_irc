require "../src/crystal_irc"

conn = CrystalIRC::Connection.new "chat.freenode.net"
conn.send CrystalIRC::Message.user "CrystalIRCTest", "CrystalIRCTest", "CrystalIRCTest", "CrystalIRCTest"
conn.send CrystalIRC::Message.nick "CrystalIRCTest"
conn.on CrystalIRC::Message::PING do |msg|
  conn.send CrystalIRC::Message.pong msg.data
end
conn.on CrystalIRC::Message::RPL_ENDOFMOTD do |msg|
  conn.send CrystalIRC::Message.join "#test"
end
conn.on CrystalIRC::Message::PRIVMSG do |msg|
  puts "got message from #{msg.host} to #{msg.target}: #{msg.data}"
end
conn.eventloop
