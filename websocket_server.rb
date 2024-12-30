require 'socket'
require 'websocket/driver'

class WebSocketServer
  def initialize(port)
    @server = TCPServer.new(port)
    puts "WebSocket server started on ws://localhost:#{port}"
  end

  def run
    loop do
      socket = @server.accept
      Thread.new { handle_connection(socket) }
    end
  end

  private

  def handle_connection(socket)
    driver = WebSocket::Driver.server(socket)

    driver.on(:connect) do |event|
      if WebSocket::Driver.websocket?(socket)
        driver.start
        puts "WebSocket connection established"
      else
        socket.close
      end
    end

    driver.on(:message) do |event|
      puts "Received message: #{event.data}"
      driver.text("Echo: #{event.data}")
    end

    driver.on(:close) do |_event|
      puts "Connection closed"
      socket.close
    end

    while (data = socket.gets)
      driver.parse(data)
    end
  rescue => e
    puts "Error: #{e.message}"
    socket.close
  end
end

# Start the WebSocket server on port 8080
server = WebSocketServer.new(8080)
server.run
