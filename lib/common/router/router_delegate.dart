import 'package:flutter/material.dart';
import 'package:qisa/data/local/preference_helper.dart';
import 'package:qisa/ui/screen/home_screen.dart';
import 'package:qisa/ui/screen/login_screen.dart';
import 'package:qisa/ui/screen/register_screen.dart';
import 'package:qisa/ui/screen/splash_screen.dart';
import 'package:qisa/ui/screen/story_add_screen.dart';
import 'package:qisa/ui/screen/story_detail_screen.dart';
import 'package:qisa/ui/screen/welcome_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool isLogin = false;
  bool isAddStory = false;
  String? selectedStory;

  _init() async {
    var pref = PreferencesHelper();
    await Future.delayed(const Duration(seconds: 2));
    isLoggedIn = (await pref.getToken).isNotEmpty;
    notifyListeners();
  }

  List<Page> get _splashStack => const [
    MaterialPage(key: ValueKey("SplashScreen"), child: SplashScreen()),
  ];
  List<Page> get _loggedOutStack => [
    MaterialPage(
      key: const ValueKey("WelcomeScreen"),
      child: WelcomeScreen(
        onLogin: () {
          isLogin = true;
          isRegister = false;
          notifyListeners();
        },
        onRegister: () {
          isRegister = true;
          isLogin = false;
          notifyListeners();
        },
      ),
    ),
    if (isLogin == true)
      MaterialPage(
        key: const ValueKey("LoginScreen"),
        child: LoginScreen(
          onLogin: () {
            isLoggedIn = true;
            notifyListeners();
          },
        ),
      ),
    if (isRegister == true)
      MaterialPage(
        key: const ValueKey("RegisterScreen"),
        child: RegisterScreen(
          onRegister: () {
            isRegister = false;
            notifyListeners();
          },
        ),
      ),
  ];

  List<Page> get _loggedInStack => [
    MaterialPage(
      key: const ValueKey("HomeScreen"),
      child: HomeScreen(
        onTapped: (String storyId) {
          selectedStory = storyId;
          notifyListeners();
        },
        onLogout: () {
          isLoggedIn = false;
          var pref = PreferencesHelper();
          pref.setToken("");
          notifyListeners();
        },
        onAddStories: () {
          isAddStory = true;
          notifyListeners();
        },
      ),
    ),
    if (selectedStory != null)
      MaterialPage(
        key: const ValueKey("StoryDetailScreen"),
        child: StoryDetailScreen(storyId: selectedStory!),
      ),
    if (isAddStory)
      MaterialPage(
        key: const ValueKey("StoryAddScreen"),
        child: StoryAddScreen(
          onAddedStory: () {
            isAddStory = false;
            notifyListeners();
          },
        ),
      ),
  ];

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }

    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onDidRemovePage: (page) {
        historyStack.remove(page);
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }
}
