ledpin = 1
statepin=4          --board  led

buttonpin=2               --buttonpin
button_state=0

wifiid='12022'
wifipw='zzxx1122'

startL=0       --g 600  w720
L1023=0
L255=40
L100=0
turnonL=100          --   /255
saveL=turnonL        --    255
changetime=2--ms

id='nodeled'
mqttip='m11.cloudmqtt.com'
mqttport=13440
qos=0
username='ppzxzuuy'
password='2y2J62QtY9JH'
m = mqtt.Client(id,120,username,password) 

statetopic      ='BedRoom/rgb/state'
commandtopic='BedRoom/rgb/set'
Availability      ='BedRoomRGBAvailability'

onstate='{"state": "ON"}'
offstate='{"state": "OFF"}'
brightness_state='{"state": "ON", "brightness":'..L255..'}'

t_wifi=0
t_online=1
t_change=2
--mqttip="test.mosquitto.org"
--pwm.setduty(ledpin,x)
--changeled(x)
--gpio.write(pin, gpio.HIGH/LOW)
