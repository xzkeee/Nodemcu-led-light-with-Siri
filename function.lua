function calc(w)        --in 255, out real pwm
     L255=w               --in w  out w2
     print('calc start')
     print('calc from ',w)
     w=w*4+3                   -- w255=((w255*4+3)*((1023-startL)^-1)+startL)   --]]
     w=(w/1023)*(1023-startL)          --w2=0.001*((w*4+3)^2)
     w=w-w%1
     w2=w+startL
     L100=(L255/2.55)
     L100=(L100-L100%1)
     print('calc goal '..w2)
	 print('calc finsh')
end

function ledup()
   repeat
      pwm.setduty(ledpin,L1023)
      print(L1023)
      L1023=L1023+1
	  tmr.delay(changetime*1000)
    until L1023>=w2   
	print('change fnish')
end

function leddown()
   repeat
      pwm.setduty(ledpin,L1023)
      print(L1023)
      L1023=L1023-1
	  tmr.delay(changetime*1000)
    until L1023<=w2    
    print('change fnish')
end

function changeled(w)    --in 255 number
       print('changeled start')
       print('change from 8bit ',L255,' to ',w)
	   if w~=0  then          --if not 0 store light
	      calc(w)
		  saveL=L255
	      print('save ',saveL)
	   else w2=0
	   end
	   m:publish(statetopic,'{"state": "ON", "brightness":'..L255..'}',0,1)
	   print('publish state and brightness ',L255)
       if w2>1023  then
          print('input worng range')
          w2=1023
       end
       if w2>L1023     then  
            print('go up')
            ledup(w2)
       elseif w2<L1023   then
            print('go down')
            leddown(w2)
       elseif w2==L1023  then
            print(L1023)
            print(L255)
            print('stay,no change')
       end
       print('now at  10bit '..L1023)
       print('now at  8bit   '..L255)
       print('now at  100   '..L100)
	   print('saveL is  ',saveL)
end

function changepwm(w)   --change  true pwm value
     pwm.setduty(ledpin,w)
     print('pwm at ',w)
end

function button_sw()
        print('do button sw')
        if  button_state==0       then
		    on()
            button_state=1
			print('button on')
        elseif  button_state==1  then           
            off()
			button_state=0
			print('button off')
	    end
end

function flash()      --board flash led
      gpio.write(statepin, gpio.LOW)      --turn on
      tmr.delay(1)  --ms
      gpio.write(statepin, gpio.HIGH)     --turn off
end

function init_mqtt()
    m:connect(mqttip,mqttport,qos,
        function(client)
            print("connect success,now online")   
                   connect_state = true
                   m:subscribe(commandtopic,0)
                   m:publish(Availability,"online",0,1)
        end,
        function(client, reason)
            print("connect failed: "..reason)
            node.restart()
        end)
end

function on()
     print('get turn on')
     print('storeL = ',saveL)
     changeled(saveL)
	 m:publish(statetopic,"{\"state\":\"ON\"}",0,1)
	 print('publish on')
	 print('now on')
end

function off()
     print('get turn off')
	 m:publish(statetopic,"{\"state\":\"OFF\"}",0,1)
	 print('publish off')
	 w2=0
     leddown(w2)
     pwm.setduty(ledpin,0)
     print('now off,output 0')
end
