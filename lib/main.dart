import 'package:chzzk_remote_controller/bloc/chzzk/chzzk_bloc.dart';
import 'package:chzzk_remote_controller/pages/chzzk_donation_list.dart';
import 'package:chzzk_remote_controller/repository/chzzk_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chzzk Chat Testing',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(255, 255, 255, 1.0),
          primary: Color.fromRGBO(0, 255, 163, .9),
          secondary: Color.fromRGBO(65, 39, 118, 1.0),
          background: Color.fromRGBO(20, 21, 23, 1.0),
        ),
        textTheme: TextTheme(
            titleMedium: TextStyle(
                fontSize: 15,
                height: 1.25,
                color: Color.fromRGBO(255, 255, 255, 1.0)),
            displayMedium: TextStyle(
                fontSize: 15,
                height: 1.25,
                color: Color.fromRGBO(255, 255, 255, 1.0)),
            bodyMedium: TextStyle(
                fontSize: 15,
                height: 1.25,
                color: Color.fromRGBO(255, 255, 255, 1.0))),
        fontFamily: 'Pretendard',
        useMaterial3: true,
      ),
      home: BlocProvider<ChzzkBloc>(
        create: (context) => ChzzkBloc(ChzzkRepository()),
        child: const ChzzkDonationList(),
      ),
    );
  }
}
