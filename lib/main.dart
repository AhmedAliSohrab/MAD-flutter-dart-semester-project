import 'package:crimereportingapp/widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'form.dart' as form; // Ensure form.dart has a class named MyForm
import 'login.dart'; // Ensure login.dart has a class named MyLogin
import 'display.dart'; // Ensure display.dart has a class named DisplayForm
import 'cop_home.dart'; // Ensure cop_home.dart has a class named CopHome
import 'splash_screen.dart'; // Ensure splash_screen.dart has a class named SplashScreen
import 'register.dart'; // Ensure register.dart has a class named RegisterScreen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Home';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        'cophome': (context) => const CopHome(userType: '', userName: ''),
        'register': (context) => const RegisterScreen(),
        'login': (context) => const MyLogin(),
        'home': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is Map<String, String>) {
            return MainPage(
              userName: args['userName'] ?? 'Guest',
              userType: args['userType'] ?? 'Unknown',
            );
          } else {
            return const MainPage(userName: 'Guest', userType: 'Unknown');
          }
        },
        'form': (context) => const form.MyForm(),
        'display': (context) => const DisplayForm(),
      },
      title: title,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
    );
  }
}

// Modify MainPage to accept userName and userType
class MainPage extends StatefulWidget {
  final String userName; // New field for userName
  final String userType; // New field for userType

  const MainPage({
    super.key,
    required this.userName, // Receive the userName
    required this.userType, // Receive the userType
  });

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawerWidget(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(MyApp.title),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            const SizedBox(height: 24.0),
            Text(
              'User Type: ${widget.userType}',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'User Name: ${widget.userName}',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
