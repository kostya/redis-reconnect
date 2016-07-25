require "./spec_helper"

# manualy run: redis-server --port 7777 --timeout 2
CONFIG = {host: "localhost", port: 7777}
TIMEOUT = 2

describe Redis::Reconnect do
  it "standard client" do
    client = Redis.new(**CONFIG)
    client.set("bla1", "a")
    client.get("bla1").should eq "a"

    sleep(TIMEOUT + 1.0)

    expect_raises(Redis::DisconnectedError) do
      client.get("bla1")
    end
  end

  it "reconnect client" do
    client = Redis::Reconnect.new(**CONFIG)
    client.set("bla1", "a")
    client.get("bla1").should eq "a"

    sleep(TIMEOUT + 1.0)

    client.get("bla1").should eq "a"
  end

end
