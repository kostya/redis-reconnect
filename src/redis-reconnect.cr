require "redis"

class Redis::Reconnect
  VERSION = "0.3"

  @client : Redis

  def initialize(@host = "localhost", @port = 6379, @unixsocket : String? = nil, @password : String? = nil, @database : Int32? = nil, @url : String? = nil)
    @client = Redis.new(host: @host, port: @port, unixsocket: @unixsocket, password: @password, database: @database, url: @url)
  end

  def reconnect!
    @client.close rescue nil
    @client = Redis.new(host: @host, port: @port, unixsocket: @unixsocket, password: @password, database: @database, url: @url)
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
