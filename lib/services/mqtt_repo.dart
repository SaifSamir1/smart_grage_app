import 'dart:async';
import 'dart:convert' as json;
import 'package:flutter/foundation.dart' as foundation;
import 'package:mqtt_client/mqtt_client.dart';

import '../cubits/home_cubit/home_cubit.dart';
import 'mqtt_service.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:convert';

class MqttRepository {
  final MqttService _mqttService;

  MqttRepository(this._mqttService);

  Future<void> connect() async {
    try {
      await _mqttService.connect();
    } catch (e) {
      if (kDebugMode) {
        print('MQTT connection error in repository: $e');
      }
      rethrow;
    }
  }

  void disconnect() {
    _mqttService.disconnect();
  }

  void publishReservation(int placeId, String plateNumber) {
    _mqttService.publishReservation(placeId, plateNumber);
  }

  void subscribeToStatusUpdates(HomeCubit cubit) {
    if (_mqttService.client.updates == null) {
      if (kDebugMode) {
        print('MQTT updates stream is null, ensure connection is established');
      }
      return;
    }
    _mqttService.client.updates!.listen(
      (List<MqttReceivedMessage<MqttMessage>> c) {
        try {
          final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
          final payload = MqttPublishPayload.bytesToStringAsString(
            message.payload.message,
          );
          final data = jsonDecode(payload);
          if (data is List) {
            for (final item in data) {
              final placeId = item['place_id'];
              final status = item['status'];
              final plate = item['plate_number'] ?? '';
              cubit.updatePlaceStatus(placeId, status, plate);
            }
          } else if (data is Map) {
            final placeId = data['place_id'];
            final status = data['status'];
            final plate = data['plate_number'] ?? '';
            cubit.updatePlaceStatus(placeId, status, plate);
          } else {
            if (kDebugMode) {
              print('Invalid MQTT payload: $payload');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error processing MQTT message: $e');
          }
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('MQTT stream error: $error');
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> getInitialState() async {
    final Completer<List<Map<String, dynamic>>> completer = Completer();
    final List<Map<String, dynamic>> initialData = [];

    if (_mqttService.client.updates == null) {
      if (kDebugMode) {
        print('MQTT updates stream is null, cannot fetch initial state');
      }
      return [];
    }

    final subscription = _mqttService.client.updates!.listen(
      (List<MqttReceivedMessage<MqttMessage>> c) {
        try {
          final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
          final payload = MqttPublishPayload.bytesToStringAsString(
            message.payload.message,
          );
          final data = jsonDecode(payload);
          if (data is List) {
            for (final item in data) {
              if (item is Map &&
                  item.containsKey('place_id') &&
                  item.containsKey('status')) {
                initialData.add(Map<String, dynamic>.from(item));
              }
            }
          } else if (data is Map) {
            if (data.containsKey('place_id') && data.containsKey('status')) {
              initialData.add(Map<String, dynamic>.from(data));
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error processing initial MQTT message: $e');
          }
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('MQTT initial state error: $error');
        }
        completer.completeError(error);
      },
    );

    // Request initial state from the ESP (optional, if supported)
    _mqttService.publishMessage(
      'garage/request_state',
      MqttQos.atLeastOnce,
      MqttClientPayloadBuilder().addString('request').payload!,
    );

    // Wait for up to 10 seconds for initial data
    Timer(const Duration(seconds: 10), () {
      subscription.cancel();
      completer.complete(initialData);
    });

    return completer.future;
  }
}
