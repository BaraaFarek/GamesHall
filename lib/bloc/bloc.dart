import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_hall/data/local_database.dart';
import 'package:game_hall/domain/entities/device.dart';


class DeviceCubit extends Cubit<List<Device>> {
  final DeviceDatabase dbHelper;

  DeviceCubit(this.dbHelper) : super([]);

  Future<void> loadDevices() async {
    final devices = await dbHelper.fetchDevices();
    emit(devices);
  }

  Future<void> addDevice(Device device) async {
    await dbHelper.addDevice(device);
    await loadDevices(); 
  }

void updateDevice(Device updatedDevice) {
  final updatedDevices = state.devices.map((device) {
    return device.id == updatedDevice.id ? updatedDevice : device;
  }).toList();

}


  Future<void> removeDevice(String id) async {
    await dbHelper.removeDevice(id);
    await loadDevices(); 
  }
}
