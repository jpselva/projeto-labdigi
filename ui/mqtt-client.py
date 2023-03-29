import paho.mqtt.client as mqtt
import time

user = "grupo1-bancadaA4"
passwd = "digi#@1A4"

outTopic = "toESP"
inTopic = "fromESP"

broker = "labdigi.wiseful.com.br"
port = 80
keepAlive = 60

# Quando conectar na rede (Callback de conexao)
def on_connect(client, userdata, flags, rc):
  print("Conectado com codigo " + str(rc))
  client.subscribe(user+"/"+inTopic, qos=0)

# Quando receber uma mensagem (Callback de mensagem)
def on_message(client, userdata, msg):
  print("from ["+str(msg.topic)+"]"+str(msg.payload.decode("utf-8")))

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.username_pw_set(user, passwd)

print("=================================================")
print("Teste Cliente MQTT")
print("=================================================")

client.connect(broker, port, keepAlive)

client.loop_start() 

# A primeira mensagem costuma ser perdida aqui no notebook
#client.publish(user+"/S0", payload="0", qos=0, retain=False)

i = 0

while True:
  #client.publish(user+"/S0", payload="1", qos=0, retain=False)
  #time.sleep(2)
  client.publish(user+"/"+outTopic, payload="{} bruh".format(i%2), qos=0, retain=False)
  time.sleep(2)
  i += 1

client.loop_stop()

client.disconnect()
