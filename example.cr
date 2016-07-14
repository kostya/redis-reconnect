require "./src/redis-reconnect"

r = Redis::Reconnect.new(host: "localhost", port: 6379)
r.set("bla", "a")
p r.get("bla")
