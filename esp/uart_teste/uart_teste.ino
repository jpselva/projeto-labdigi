#include <WiFi.h>
#include <HardwareSerial.h>
#include <PubSubClient.h>
#include "wifi_config.h" // should export 'password' and 'ssid' 

// WiFi client
WiFiClient netClient;

// MQTT communication
PubSubClient mqttClient(netClient);
const char* mqtt_server = "labdigi.wiseful.com.br";
String user = "grupo1-bancadaA4";
String passwd = "digi#@1A4";
int mqtt_port = 80;
String inTopic = "toESP";
String outTopic = "fromESP";
String stateTopic = "estado";
String noteTopic = "nota";
String errorsTopic = "erros";
String roundTopic = "jogada";

// Communication with FPGA
HardwareSerial SerialFPGA(2); // Use UART 2 (gpio 16, 17)
char bytesFromFPGA[] = "***\0";
int byteCount = 0;

void setup_wifi() {
  delay(10);

  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  randomSeed(micros());

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void mqtt_reconnect() {
  // Loop until we're reconnected
  while (!mqttClient.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Create a random Client ID
    String clientId = "ESP32Client-";
    clientId += String(random(0xffff), HEX);
    // Attempt to connect
    if (mqttClient.connect(clientId.c_str(), user.c_str(), passwd.c_str())) {
      Serial.println("connected");
    } else {
      Serial.print("failed, rc=");
      Serial.print(mqttClient.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void setup() {
  // Setup serial ports
  Serial.begin(9600);
  SerialFPGA.begin(9600, SERIAL_8N2, 16, 17);
  // Setup WiFi & Broker  
  setup_wifi();
  mqttClient.setServer(mqtt_server, mqtt_port);
}

char extractErrors(const char *payload) {
  return payload[0] & 0x7F;
}

char extractRound(const char *payload) {
  return (payload[1] & 0x3C) >> 2;
}

char extractNote(const char *payload) {
  return ((payload[1] & 0x03) << 2) | ((payload[2] & 0x60) >> 5);
}

char extractState(const char *payload) {
  return payload[2] & 0x1F;
}

#define MSGLEN 10
char currErrors, currRound, currNote, currState, nextErrors, nextRound, nextNote, nextState;
char tmpErrors[MSGLEN];
char tmpRound[MSGLEN];
char tmpNote[MSGLEN];
char tmpState[MSGLEN];

void loop() {
  if (!mqttClient.connected())
    mqtt_reconnect();
  mqttClient.loop();

  if (Serial.available()) {
    byteCount = SerialFPGA.readBytesUntil(',', bytesFromFPGA, 3);
    if (byteCount == 3) {
      nextErrors = extractErrors(bytesFromFPGA);
      nextRound = extractRound(bytesFromFPGA);
      nextNote = extractNote(bytesFromFPGA);
      nextState = extractState(bytesFromFPGA);

      if (nextErrors - currErrors <= 2) {
        if (currErrors != nextErrors) {
          snprintf(tmpErrors, MSGLEN, "%d", nextErrors);
          currErrors = nextErrors;
          mqttClient.publish((user+"/"+outTopic+"/"+errorsTopic).c_str(), tmpErrors);
          Serial.printf("published %d errors\n", currErrors);
        }

        if (currRound != nextRound) {
          snprintf(tmpRound, MSGLEN, "%d", nextRound);
          currRound = nextRound;
          mqttClient.publish((user+"/"+outTopic+"/"+roundTopic).c_str(), tmpRound);
          Serial.printf("published %d round\n", currRound);
        }

        if (currNote != nextNote) {
          snprintf(tmpNote, MSGLEN, "%d", nextNote);
          currNote = nextNote;
          mqttClient.publish((user+"/"+outTopic+"/"+noteTopic).c_str(), tmpNote);
          Serial.printf("published %d note\n", currNote);tractErrors(bytesFromFPGA)
        }

        if (currState != nextState) {
          snprintf(tmpState, MSGLEN, "%d", nextState);
          currState = nextState;
          mqttClient.publish((user+"/"+outTopic+"/"+stateTopic).c_str(), tmpState);
          Serial.printf("published %d state\n", currState);
        }
      }

      //Serial.printf("got: %x %x %x\n", bytesFromFPGA[0], bytesFromFPGA[1], bytesFromFPGA[2]);
      //Serial.printf("published: %d %d %d %d\n", extractErrors(bytesFromFPGA), extractRound(bytesFromFPGA), extractNote(bytesFromFPGA), extractState(bytesFromFPGA));
    }
  }
}
