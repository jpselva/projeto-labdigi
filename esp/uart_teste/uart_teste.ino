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
char payload[] = "*\0"; // will hold the payload to be sent to broker

// Communication with FPGA
HardwareSerial SerialFPGA(2); // Use UART 2 (gpio 16, 17)
char byteFromFPGA;

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

void loop() {
  if (!mqttClient.connected())
    mqtt_reconnect();
  mqttClient.loop();

  if (SerialFPGA.available()) {
    byteFromFPGA = SerialFPGA.read();
    Serial.print("I received a: ");
    Serial.println(byteFromFPGA);

    payload[0] = byteFromFPGA;
    mqttClient.publish((user+"/"+outTopic).c_str(), payload);
  }
}
