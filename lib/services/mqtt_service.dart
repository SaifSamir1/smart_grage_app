



import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final MqttServerClient _client;
  final int _port = 1883;
  Function(int, String)? onPlaceStatusUpdated;

  MqttService()
      : _client = MqttServerClient('broker.hivemq.com', 'flutter_client_${DateTime.now().millisecondsSinceEpoch}') {
    _client.port = _port;
    _client.logging(on: false);
    _client.keepAlivePeriod = 60;
    _client.onDisconnected = () => print('MQTT Disconnected');
    _client.onConnected = () => print('MQTT Connected');
  }

  Future<void> connect() async {
    try {
      await _client.connect();
      // Subscribe to topics for 7 places
      for (int i = 1; i <= 6; i++) {
        _client.subscribe('garage/place$i', MqttQos.atLeastOnce);
      }
      // Listen for updates
      _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final recMess = c[0].payload as MqttPublishMessage;
        final topic = c[0].topic;
        final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        final placeId = int.parse(topic.split('/').last.replaceAll('place', ''));
        onPlaceStatusUpdated?.call(placeId, payload);
      });
    } catch (e) {
      print('MQTT Connection failed: $e');
      _client.disconnect();
    }
  }

  void publishReservation(int placeId) {
    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString('Place$placeId');
      _client.publishMessage('garage/reserve', MqttQos.atLeastOnce, builder.payload!);
      print('Reserved Place $placeId');
    } else {
      print('Cannot reserve: MQTT not connected');
    }
  }

  void disconnect() {
    _client.disconnect();
  }
}