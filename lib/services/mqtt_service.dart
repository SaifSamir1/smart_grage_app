import 'dart:convert' as json;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:typed_data/typed_data.dart';

class MqttService {
  late MqttServerClient client;

  MqttService() {
    // Generate a unique client ID using a random number
    final random = Random().nextInt(10000);
    client = MqttServerClient(
      'broker.hivemq.com',
      'smart_garage_client_$random',
    );
    client.port = 1883;
    client.logging(on: false);
    client.onDisconnected = _onDisconnected;
    client.onSubscribed = _onSubscribed;
    client.onConnected = _onConnected;
    client.onUnsubscribed = _onUnsubscribed;
    client.autoReconnect = true;
    client.resubscribeOnAutoReconnect = true;
  }

  void _onSubscribed(String? topic) {
    if (kDebugMode) {
      print('Subscribed to $topic');
    }
  }

  void _onUnsubscribed(String? topic) {
    if (kDebugMode) {
      print('Unsubscribed from $topic');
    }
  }

  void _onDisconnected() {
    if (kDebugMode) {
      print('Disconnected from MQTT broker');
    }
  }

  void _onConnected() {
    if (kDebugMode) {
      print('Connected to MQTT broker');
      // Subscribe to the status topic upon connection
      subscribe('garage/status', MqttQos.atLeastOnce);
    }
  }

  Future<void> connect() async {
    client.setProtocolV311();
    client.keepAlivePeriod = 60;
    try {
      await client.connect();
    } catch (e) {
      if (kDebugMode) {
        print('MQTT connection error: $e');
      }
      client.disconnect();
      rethrow;
    }
  }

  void subscribe(String topic, MqttQos qos) {
    try {
      client.subscribe(topic, qos);
    } catch (e) {
      if (kDebugMode) {
        print('Subscription error for $topic: $e');
      }
    }
  }

  void publishReservation(int placeId, String plateNumber) {
    try {
      final payload = jsonEncode({
        'place_id': 'Place$placeId',
        'plate_number': plateNumber,
        'status': 'Booked',
      });
      final builder = MqttClientPayloadBuilder();
      builder.addString(payload);
      client.publishMessage(
        'garage/send',
        MqttQos.atLeastOnce,
        builder.payload!,
      );
      if (kDebugMode) {
        print('Published reservation: $payload');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Publish error: $e');
      }
    }
  }

  void publishMessage(String topic, MqttQos qos, List<int> payload) {
    try {
      // تحويل List<int> إلى Uint8Buffer
      final buffer = Uint8Buffer()..addAll(payload);
      client.publishMessage(topic, qos, buffer);
      if (kDebugMode) {
        print('Published message to $topic: ${String.fromCharCodes(payload)}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error publishing to $topic: $e');
      }
    }
  }

  void disconnect() {
    client.disconnect();
  }
}
