# redis-reconnect

Redis client with autoreconnection for slow clients (wrapper for stefanwille/crystal-redis). Used as part of [redisoid](https://github.com/kostya/redisoid) shard.

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  redis-reconnect:
    github: kostya/redis-reconnect
```


## Usage


```crystal
require "redis-reconnect"

r = Redis::Reconnect.new(host: "localhost", port: 6379)
r.set("bla", "a")
p r.get("bla")
```

Ok to use it with Pool (ysbaddaden/pool):

```crystal
pool = ConnectionPool.new(capacity: 25) do
  Redis::Reconnect.new(host: "localhost", port: 6379)
end

pool.connection do |conn|
  conn.get "bla"
end
```
