import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zero_packing/models.dart';
import 'pages.dart';
// TODO : 메인 MyApp NotifierProvider 사용 후에 로그인은 Provider 쓰지않아서 분리시켜야함
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => OrderProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zero Packing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}