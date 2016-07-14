# redis-reconnect

Redis client with autoreconnection (wrapper for stefanwille/crystal-redis). Very hacky.

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
