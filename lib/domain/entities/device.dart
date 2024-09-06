import 'package:equatable/equatable.dart';

enum DeviceType { pc, xbox, playstation }
enum DeviceStatus { available, reserved }

class Device extends Equatable {
  final String id;
  final String name;
  final DeviceType type;
  final DeviceStatus status;
  final double pricePerHour;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.pricePerHour,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last, 
      'pricePerHour': pricePerHour,
    };
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as String,
      name: json['name'] as String,
      type: DeviceType.values.firstWhere(
          (e) => e.toString().split('.').last == json['type']),
      status: DeviceStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['status']),
      pricePerHour: json['pricePerHour'] as double,
    );
  }

  @override
  List<Object?> get props => [id, name, type, status, pricePerHour];
}
