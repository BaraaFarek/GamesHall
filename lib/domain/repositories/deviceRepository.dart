

import 'package:game_hall/domain/entities/device.dart';

abstract class DeviceRepository {
  Future<List<Device>> getAllDevices();
  Future<void> addDevice(Device device);
  Future<void> updateDevice(Device device);
  Future<void> deleteDevice(int id);
}
