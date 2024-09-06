import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_hall/bloc/bloc.dart';

import 'package:game_hall/domain/entities/device.dart';

class DeviceManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Management'),
        backgroundColor: Colors.purple,
      ),
      body: BlocBuilder<DeviceCubit, List<Device>>(
        builder: (context, devices) {
          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return ListTile(
                title: Text(
                  '${device.name} (${device.type.toString().split('.').last})',
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text('${device.status.toString().split('.').last}'),
                trailing: Row(
                  mainAxisSize:
                      MainAxisSize.min, // حجم الـRow يعتمد على أصغر عنصر داخله
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showEditDeviceDialog(
                            context, device); // استدعاء دالة فتح صفحة التعديل
                      },
                    ),

                    SizedBox(width: 8), // مسافة بين الزر التعديل والزر الحذف
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        context.read<DeviceCubit>().removeDevice(device.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDeviceDialog(context);
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext parentContext) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    DeviceType? selectedType;

    showDialog(
      context: parentContext, // استخدم parentContext هنا
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('إضافة جهاز جديد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'اسم الجهاز'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'السعر لكل ساعة'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<DeviceType>(
                value: selectedType,
                hint: Text('اختر نوع الجهاز'),
                items: DeviceType.values.map((DeviceType type) {
                  return DropdownMenuItem<DeviceType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (DeviceType? newValue) {
                  selectedType = newValue;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // إغلاق الحوار
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    selectedType != null) {
                  final newDevice = Device(
                    id: DateTime.now().toString(),
                    name: nameController.text,
                    type: selectedType!,
                    status: DeviceStatus.available,
                    pricePerHour: double.parse(priceController.text),
                  );
                  BlocProvider.of<DeviceCubit>(parentContext)
                      .addDevice(newDevice);

                  Navigator.of(dialogContext).pop(); // إغلاق الحوار بعد الإضافة
                }
              },
              child: Text('إضافة'),
            ),
          ],
        );
      },
    );
  }

  void showEditDeviceDialog(BuildContext parentContext, Device device) {
    final TextEditingController nameController =
        TextEditingController(text: device.name); // استخدام الاسم الحالي
    final TextEditingController priceController = TextEditingController(
        text: device.pricePerHour.toString()); // استخدام السعر الحالي
    DeviceType? selectedType = device.type; // استخدام النوع الحالي

    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('تعديل الجهاز'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'اسم الجهاز'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'السعر لكل ساعة'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<DeviceType>(
                value: selectedType,
                hint: Text('اختر نوع الجهاز'),
                items: DeviceType.values.map((DeviceType type) {
                  return DropdownMenuItem<DeviceType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (DeviceType? newValue) {
                  selectedType = newValue;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // إغلاق الحوار
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    selectedType != null) {
                  final updatedDevice = Device(
                    id: device.id, // نستخدم نفس الـ ID لتحديد الجهاز
                    name: nameController.text,
                    type: selectedType!,
                    status: device.status, // احتفاظ بالحالة القديمة
                    pricePerHour: double.parse(priceController.text),
                  );

                  // تحديث الجهاز باستخدام Cubit
                  BlocProvider.of<DeviceCubit>(parentContext)
                      .updateDevice(updatedDevice);

                  Navigator.of(dialogContext).pop(); // إغلاق الحوار بعد التعديل
                }
              },
              child: Text('تعديل'),
            ),
          ],
        );
      },
    );
  }
}
