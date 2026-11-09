import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_screen.dart';
import 'services/widget_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Durum çubuğu şeffaf — immersive deneyim
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Uygulama açıldığında widget'ı güncelle (yeni gün kontrolü)
  await WidgetService.refreshWidgetIfNeeded();

  runApp(const DailyAphorismsApp());
}

class DailyAphorismsApp extends StatelessWidget {
  const DailyAphorismsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Günün Sözü',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0C29),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
