import paho.mqtt.client as mqtt
import time
import pygame

user = "grupo1-bancadaA4"
passwd = "digi#@1A4"

outTopic = "inTeste"
#outTopic = "/toESP"
inTopic = "/fromESP"
#inTopic = ""

broker = "labdigi.wiseful.com.br"
port = 80
keepAlive = 60

# Quando conectar na rede (Callback de conexao)
def on_connect(client, userdata, flags, rc):
  print("Conectado com codigo " + str(rc))
  client.subscribe(user+inTopic+"/nota", qos=0)
  client.subscribe(user+inTopic+"/erros", qos=0)
  client.subscribe(user+inTopic+"/estado", qos=0)
  client.subscribe(user+inTopic+"/jogada", qos=0)

# Quando receber uma mensagem (Callback de mensagem)
def on_message(client, userdata, msg):
  global nota_msg, erros_msg, estado_msg, jogada_msg
  msg_topic = str(msg.topic)[25:]
  #print(msg_topic)
  if msg_topic == "nota":
    nota_msg = int(msg.payload.decode("utf-8"))
  elif msg_topic == "erros":
    erros_msg = str(msg.payload.decode("utf-8"))
  elif msg_topic == "estado":
    estado_msg = int(msg.payload.decode("utf-8"))
  elif msg_topic == "jogada":
    jogada_msg = str(msg.payload.decode("utf-8"))
  print("from ["+str(msg.topic)+"]: "+str(msg.payload.decode("utf-8")))

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.username_pw_set(user, passwd)

print("=================================================")
print("Teste Cliente MQTT")
print("=================================================")

client.connect(broker, port, keepAlive)

client.loop_start() 

#### pygame stuff ####

# dicionarios
noteDict = {
  0 : "Dó",
  1 : "Ré",
  2 : "Mi",
  3 : "Fá",
  4 : "Sol",
  5 : "Lá",
  6 : "Sí",
  7 : "Dó Maior",
  8 : "Ré Maior",
  9 : "Fá Maior",
  10: "Sol Maior",
  11: "Lá Maior"
}

estadoDict = {
  0 : "inicial",
  2 : "seleciona_modo",
  3 : "toca_tr",
  4 : "espera_tr",
  7 : "espera_errou_tr",
  8 : "espera_acertou_tr",
  11 : "silencio_acertou_tr",
  12 : "silencio_errou_tr",
  13 : "fim",
  14 : "seleciona_dif",
  17 : "espera_pr",
  19 : "toca_pr"
}

# define colors
black = (  36,  28,  28 )
white = ( 229, 216, 206 )
beige = ( 135, 122, 116)
brown = (  73,  54,  59 )
lighter_black = (  86,  78,  78 )
darker_white = ( 165, 150, 150 )

# faz piano
def draw_key(color, pos): # x( -12 - 386), y(0 - 100)
  if color == black or color == lighter_black :
    pygame.draw.rect(screen, color, ( pos[0]+39, pos[1], 24, 120)) 
  elif color == white or color == darker_white :
    pygame.draw.rect(screen, color, ( pos[0], pos[1], 48, 132)) 
  else :
    print("Erro cor desconhecida")

def draw_keyboard(pos, nota):
  pygame.draw.rect(screen, beige, ( pos[0]-12, pos[1], 396, 174))
  pygame.draw.rect(screen, brown, ( pos[0]-12, 145+pos[1], 396, 12))
  pygame.draw.rect(screen, brown, ( pos[0]-12, 160+pos[1], 396, 20))
  i = 0
  while (i < 12 ):
    if(i < 7):
      if(nota == i):
        draw_key(darker_white, (pos[0]+i*54, pos[1]) )
      else :
        draw_key(white, (pos[0]+i*54, pos[1]) )
    else:
      if(i < 9):
        if(nota == i):
          draw_key(lighter_black, (pos[0]+(i-7)*54, pos[1]))
        else:
          draw_key(black, (pos[0]+(i-7)*54, pos[1]))
      else:
        nota
        if(nota == i):
          draw_key(lighter_black, (pos[0]+(i-6)*54, pos[1]))
        else:
          draw_key(black, (pos[0]+(i-6)*54, pos[1]))
    i+=1
    
def write_big(text, pos):
  img = big.render(text, True, beige)
  screen.blit(img, pos)
def write_huge(text, pos):
  img = huge.render(text, True, beige)
  screen.blit(img, pos)
def write_small(text, pos):
  img = small.render(text, True, beige)
  screen.blit(img, pos)

def escolhe_tela(est): # tela : (1000, 600)
  nota_tocada = -1
  if (est == "inicial") :
    write_huge("Note Genius", (200, 100))
    write_big("Acione iniciar", (340, 250))
    draw_keyboard((314, 350), nota_tocada)
  elif (est== "fim") :
    write_huge("Fim", (420, 200))
    write_big("Erros: "+ erros_msg, (200, 400))
  elif est != None: # todos outros
    if (est.endswith("_tr")) : # tradicional
      # Render
      if (est== "espera_acertou_tr"):
        write_huge("Acertou!",(290, 200))
        nota_tocada = nota_msg
        write_small("Nota: "+ str(noteDict.get(nota_msg)),(720, 420))
      else :
        write_small("Nota: ?",(720, 420))
      if (est== "espera_errou_tr"):
        write_huge("Errou!",(350, 200))
      elif (est== "espera_tr"):
        write_big("Qual a nota?",(350, 200))  
      elif (est== "toca_tr"):
        write_big("tocando...",(30, 350))
      elif (est== "silencio_acertou_tr"):
        write_huge("Rodada + 1",(240, 200))
      elif (est== "silencio_errou_tr"):
        write_huge("Erros + 1",(300, 200))

      # msgs "constantes em tradicional"
      draw_keyboard((314, 350), nota_tocada)
      write_small("Rodada ("+ jogada_msg+ "/16)",  (720, 40))
      write_small("Erros: "+ erros_msg, (720, 80))
      write_big("Note Genius: Tradicional", (30, 30))

    elif (est== "seleciona_modo") :
      write_huge("Escolha o modo", (30, 30))
      write_big("Tradicional ou Prática", (250, 300))

    elif (est== "seleciona_dif") :
      write_big("Escolha a Dificuldade", (30, 30))
      write_big("3, 5, 7 ou 12?", (300, 300))

    elif (est.endswith("_pr")) :
      if (est== "toca_pr") :
        write_small("Nota: "+ str(noteDict.get(nota_msg)),(30, 150))
        nota_tocada = nota_msg
        write_big("tocando...",(30, 350))  
      else :
        write_small("Nota: -",(30, 150))
      draw_keyboard((314, 350), nota_tocada)
      write_big("Note Genius: Prática", (30, 30))
  else :
    erro = big.render("ERRO: onde que você tá!?", True, beige)

pygame.init()
screen = pygame.display.set_mode((1000, 600))
running = True

background = black
screen.fill(background)

huge = pygame.font.SysFont(None, 148)
big = pygame.font.SysFont(None, 72)
small = pygame.font.SysFont(None, 48)

nota_msg = 13
erros_msg = "00"
jogada_msg = "00"
estado_msg = 0

client.publish(user+"/S0", payload="1", qos=0, retain=False)
time.sleep(2)
client.publish(user+"/"+outTopic, "Teste", qos=0, retain=False)
time.sleep(2)

while running:
  screen.fill(background)
  # Render
  escolhe_tela(estadoDict.get(estado_msg))
  for event in pygame.event.get() :
    if event.type == pygame.QUIT :
      running = False
      client.publish(user+"/S0", payload="1", qos=0, retain=False)
      time.sleep(2)
      client.publish(user+"/"+outTopic, "Desliga", qos=0, retain=False)
      time.sleep(2)
      #elif event.type == MOUSEBUTTONDOWN:
    #  if rect.collidepoint(event.pos):
    #      moving  = True
  pygame.display.update()
  

client.loop_stop()

client.disconnect()
