import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qisa/common/router/page_manager.dart';
import 'package:qisa/common/router/router_delegate.dart';
import 'package:qisa/provider/img_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouterDelegate _myRouterDelegate;

  @override
  void initState() {
    super.initState();
    _myRouterDelegate = MyRouterDelegate();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PageManager>(create: (context) => PageManager()),
        ChangeNotifierProvider<ImgProvider>(create: (context) => ImgProvider()),
      ],
      child: MaterialApp(
        title: 'Qisa',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Router(
          routerDelegate: _myRouterDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
