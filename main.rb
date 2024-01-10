require_relative "obj/multihost.rb"
#This file runs the app manager

m = LukaNet::MultiHost.new
require_relative "apps/test.rb"
m.mount 0, TestApp

m.run(0)

while m.anyRunning?
  m.prune
  sleep 1
end
