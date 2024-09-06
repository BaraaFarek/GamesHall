import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_hall/bloc/bloc.dart';
import 'package:game_hall/data/local_database.dart';
import 'package:game_hall/presentation/pages/device_management.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  final deviceDatabaseHelper = DeviceDatabase.instance;
  runApp(MyApp(deviceDatabase: deviceDatabaseHelper));
}

class MyApp extends StatelessWidget {
  final DeviceDatabase deviceDatabase;
  MyApp({required this.deviceDatabase});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Hall Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => DeviceCubit(deviceDatabase)..loadDevices(),
        child: DeviceManagementPage(),
      ),
    );
  }
}
