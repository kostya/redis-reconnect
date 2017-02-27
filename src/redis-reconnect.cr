require "redis"

class Redis::Reconnect
  @client : Redis

  def initialize(@host : String = "localhost", @port : Int32 = 6379, @unixsocket : String? = nil, @password : String? = nil, @database : Int32? = nil)
    @client = Redis.new(host: @host, port: @port, unixsocket: @unixsocket, password: @password, database: @database)
  end

  def reconnect!
    if old_client = @client
      old_client.close rescue nil
    end
    @client = Redis.new(host: @host, port: @port, unixsocket: @unixsocket, password: @password, database: @database)
  end

  macro method_missing(call)
    safe_call { @client.{{call}} }
  end

  private def safe_call
    yield
  rescue ex : Redis::DisconnectedError
    reconnect!
    yield
  end

  def subscribe(*channels, &callback_setup_block : Redis::Subscription ->)
    @client.subscribe(*channels) { |s| callback_setup_block.call(s) }
  end

  def psubscribe(*channel_patterns, &callback_setup_block : Redis::Subscription ->)
    @client.subscribe(*channel_patterns) { |s| callback_setup_block.call(s) }
  end
end
