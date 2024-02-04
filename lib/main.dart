
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mis_lab3/auth.dart';
import 'package:mis_lab3/create_exam.dart';
import 'package:mis_lab3/firebase_options.dart';
import 'package:mis_lab3/models/exam.dart';


void main() async {
  await initializeApp();
  runApp(const MyApp());
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const ListScreen(),
        '/login': (context) => const AuthScreen(isLogin: true),
        '/register': (context) => const AuthScreen(isLogin: false),
      },
    );
  }
}



class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListState createState() => _ListState();
}


class _ListState extends State<ListScreen> {
  final List<Exam> exams = [
    Exam(courseName: 'test', dateTime: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildExamGrid(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Exams Scheduler App'),
      actions: [
        _buildAddExamButton(),
        _buildSignOutButton(),
      ],
    );
  }

  IconButton _buildAddExamButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => FirebaseAuth.instance.currentUser != null
          ? addNewExam(context)
          : _navigateToSignInPage(context),
    );
  }

  IconButton _buildSignOutButton() {
    return IconButton(
      icon: const Icon(Icons.login),
      onPressed: () => logOut(),
    );
  }

  Widget _buildExamGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.courseName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  exam.dateTime.toString(),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

 Future<void> addNewExam(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: CreateExamWidget(
              addExam: addExam,
            ),
          );
        });
  }

  void addExam(Exam exam) {
    setState(() {
      exams.add(exam);
    });
  }

  void _navigateToSignInPage(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}


