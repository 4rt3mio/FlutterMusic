import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hometask/ui/blocs/file_loader/file_loader_bloc.dart';
import 'package:hometask/ui/widgets/account_page.dart';
import 'package:hometask/ui/widgets/login_page.dart';
import 'package:hometask/ui/widgets/main_page.dart';
import 'package:hometask/ui/widgets/playlist_screen.dart';
import 'package:hometask/ui/widgets/song_page.dart';
import 'package:hometask/ui/widgets/splash_page.dart';
import 'package:hometask/ui/widgets/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
    await Supabase.initialize(
      url: 'https://mlnybhnuiefugvyzpfwz.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sbnliaG51aWVmdWd2eXpwZnd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTUyNjgwNDMsImV4cCI6MjAzMDg0NDA0M30.j11SxlO3v2Lbg0Y3aleY3pXqEMJVgj8neIvU9bXCnQ4',
    );
    runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Flutter',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        primaryColor: Colors.green,
        canvasColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          color: Color.fromRGBO(0, 128, 0, 0.8),
        ),
        textTheme: ThemeData.dark().textTheme.copyWith(
          bodyLarge: const TextStyle(color: Colors.white),
          bodyMedium: const TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
        '/home': (context) => BlocProvider<FileLoaderBloc>(
          create: (context) => FileLoaderBloc(),
          child: const MyHomePage(),
        ),
        '/main': (_) => const MainPage(),
        '/song': (_) => const SongPage(),
        '/playlist': (_) => const PlaylistScreen(),
      },
    );
  }
}