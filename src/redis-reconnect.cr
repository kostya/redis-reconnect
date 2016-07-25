require "redis"

class Redis::Reconnect
  @client : Redis

  def initialize(@host : String = "localhost", @port : Int32 = 6379, @unixsocket : String? = nil, @password : String? = nil, @database : Int32? = nil)
    @client = Redis.new(host: @host, port: @port, unixsocket: @unixsocket, password: @password, database: @database)
  end

  def reconnect!
    @client = Redis.new(host: @host, port: @port, unixsocket: @unixsocket, password: @password, database: @database)
  end

  DISCONNECTED_MSG = "RedisError: Disconnected"

  {% for method in Redis::Commands.methods %}
    {% if method.visibility == :public %}
      {% define = "#{method.name.id}(#{method.args.join(", ").id})" %}
      {% args = method.args.map { |a| a.name }.join(", ").id %}
  
      def {{ define.id }}
        @client.{{method.name.id}}({{args}})
      rescue ex : Redis::DisconnectedError
        reconnect!
        @client.{{method.name.id}}({{args}})
      end

    {% end %}
  {% end %}
end
