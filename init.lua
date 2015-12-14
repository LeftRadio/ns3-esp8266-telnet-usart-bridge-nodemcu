-- start
uart.setup(0,921600,8,0,1,0)
wifi.sta.setip({ip="192.168.1.119",netmask="255.255.255.0",gateway="192.168.1.1"})
--
wifi.setmode(wifi.STATION)
print('set mode=STATION (mode='..wifi.getmode()..')')
--
print('MAC: ',wifi.sta.getmac())
print('chip: ',node.chipid())
print('heap: ',node.heap())
--
wifi.sta.config("*********","*********")
--
tmr.alarm(0, 1000, 1, function()
   if wifi.sta.status() ~= 5 then
      print("Connecting to AP...")
   else
      print(wifi.sta.getip())
      tmr.stop(0)
   end
end)
-- a simple telnet server
pin = 4
gpio.mode(pin, gpio.OUTPUT)
--
s = net.createServer(net.TCP,180)
s:listen(2323,function(c)

    c:on("receive",function(c,l)
        gpio.write(pin, gpio.LOW)
        uart.write(0, l)
        gpio.write(pin, gpio.HIGH)
    end)

    c:on("disconnection",function(c)
        -- client disconnected
    end)

    uart.on("data", 0,
        function(data)
            -- resend from uart
            c:send(data)
    end, 0)

    -- client connected
end)