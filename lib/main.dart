import 'dart:io';

import 'package:chzzk_remote_controller/bloc/chzzk/chzzk_bloc.dart';
import 'package:chzzk_remote_controller/pages/chzzk_donation_list.dart';
import 'package:chzzk_remote_controller/repository/chzzk_repository.dart';
import 'package:chzzk_remote_controller/widgets/window_titlebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

/**
 * 
 * rgb(20, 21, 23)
rgb(30, 32, 34)
rba(0, 0, 0)
border (255, 255, 255, 0.06)


rgba(46, 48, 51, 0.6)


rgb(255, 0, 0) red

text
rgb(157, 165, 182)


rgb(223, 226, 234)


rgba(0, 255, 163, 0.9)
rgb(255, 255, 255)
rgb(255, 84, 84)
 * 
 */

// ColorScheme darkThemeColors(context) {
//   return const ColorScheme(
//       brightness: brightness,
//       primary: primary,
//       onPrimary: onPrimary,
//       secondary: secondary,
//       onSecondary: onSecondary,
//       error: error,
//       onError: onError,
//       background: background,
//       onBackground: onBackground,
//       surface: surface,
//       onSurface: onSurface);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 600),
      backgroundColor: Colors.transparent,
      center: true,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
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
          seedColor: const Color.fromRGBO(255, 255, 255, 1.0),
          primary: const Color.fromRGBO(0, 255, 163, .9),
          secondary: const Color.fromRGBO(65, 39, 118, 1.0),
          background: const Color.fromRGBO(20, 21, 23, 1.0),
        ),
        textTheme: const TextTheme(
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
        child: const Column(
          children: [WindowTitlebar(), Expanded(child: ChzzkDonationList())],
        ),
      ),
    );
  }
}
