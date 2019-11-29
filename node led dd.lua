connect_state = false

wifi.setmode(wifi.STATION)
       wifi.sta.sethostname("Node-RGB")
       station_cfg={}
       station_cfg.ssid=wifiid
       station_cfg.pwd=wifipw
       wifi.sta.config(station_cfg)
       wifi.sta.autoconnect(1)
       print('wifi state: ',wifi.sta.getip())

pwm.setup(ledpin,1000,0)      --pin fenquency  level
pwm.start(ledpin)

gpio.mode(statepin,gpio.OUTPUT)
gpio.write(statepin,gpio.HIGH)

--[[
gpio.trig(buttonpin)           --unregister   pin
--gpio.mode(buttonpin,gpio.INT)            --button
--gpio.trig(buttonpin,"up",button_sw)         --set trig
--]]
changeled(turnonL)                   --level when turn on
      print('turn on change')
      print('change to turnonL')
--changeled(160)
 --tmr.alarm([id(0-6)], interval_ms, mode, func())
tmr.alarm(t_wifi,3000,1,function()
        if wifi.sta.getip() == nil then
            print("Wifi Connecting...")
        else
            init_mqtt()
            tmr.stop(0)
            print("Wifi Connected, IP is "..wifi.sta.getip())
		    tmr.alarm(5,3000,0,function()
			       m:publish(statetopic,'{"state": "ON", "brightness":'..L255..'}',0,1)
				   end)
        end
end)
--tmr.unregister（id）
 
tmr.alarm(t_online, 240000, 1, function()        --online publish  110s
     m:publish(Availability,"online",0,1)
     flash()
end)

--tmr.register(t_changeup,changetime,1, func())
--tmr.register(t_changedown,changetime,1, func())

m:on("message",function(client,topic,data)
    print(topic,data)
    if data ~= nil then
        t = sjson.decode(data)
        if t["state"] == "ON" and t["color"] == nil and t["brightness"] == nil and t["effect"] == nil then 
            print('get turn on')
            on()
        elseif t["state"] == "OFF" and t["color"] == nil and t["brightness"] == nil and t["effect"] == nil then
            print('get turn off')
            off()
        elseif t["brightness"] ~= nil then
		     print('get brightness    ',t["brightness"])
			 w = t["brightness"]
		     changeled(w)
		     print('change brightness finsh')
             --[[      elseif t["color"] ~= nil and t["brightness"] == nil and t["effect"] == nil then
                  g = t["color"]["g"]
                 r = t["color"]["r"]
                  b = t["color"]["b"]
                 change_color(g, r, b)
                  print('get change  ',r,g,b)--]]
             --[[      elseif t["color"] == nil and t["brightness"] == nil and t["effect"] ~= nil and t["effect"] == "flash" then
                 tmr.alarm(2, 50, 1, flash)
               elseif t["effect"] ~= nil and t["effect"] == "close effect" then
                 tmr.stop(2)
               white()--]]  --effict can be any function
        end
    end
end)

m:on("offline", function(client)
    init_mqtt()
    end)

m:lwt(Availability, "offline", 0, 0)
