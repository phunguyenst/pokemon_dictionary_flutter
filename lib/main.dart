import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon_deck/pages/home_page.dart';
import 'package:pokemon_deck/services/database_service.dart';

import 'services/http_service.dart';

void main() async {
  await _setupServices();
  runApp(const MyApp());
}

Future<void> _setupServices() async {
  // await Firebase.initializeApp();
  GetIt.instance.registerSingleton<HttpService>(HttpService());
  GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'PoKeDex',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.quattrocentoSansTextTheme(),
        ),
        home: const HomePage(),
      ),
    );
  }
}
