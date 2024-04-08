import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // Ensure this file exists and contains Firebase options


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(), // Navigate to TaskListScreen after initializing the app
    );
  }
}


class Task {
  String id; // New property
  String name;
  bool isCompleted;
  String time;


  Task({required this.id, required this.name, required this.isCompleted, required this.time});


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isCompleted': isCompleted,
      'time': time,
    };
  }


  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      name: map['name'],
      isCompleted: map['isCompleted'],
      time: map['time'],
    );
  }
}


class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}


class _TaskListScreenState extends State<TaskListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? _user;
  late List<Task> _tasks = [];
  late TextEditingController _taskController;


  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _getUser(); // Call the _getUser method after the frame has been built
    });
  }


  void _getUser() {
    _user = _auth.currentUser;
    if (_user == null) {
      // If user is not logged in, navigate to login screen (Testing: Test user login)
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ));
    } else {
      _fetchTasks(); // Fetch tasks if user is logged in (Testing: Test fetching tasks)
    }
  }


  void _fetchTasks() async {
    final snapshot = await _firestore.collection('tasks').doc(_user!.uid).collection('user_tasks').get();
    setState(() {
      _tasks = snapshot.docs.map((doc) => Task.fromMap(doc.id, doc.data())).toList();
    });
  }


  Future<void> _addTask() async {
    String taskName = _taskController.text.trim();
    if (taskName.isNotEmpty) {
      Task newTask = Task(name: taskName, isCompleted: false, time: "", id: ''); // Dummy id for now
      DocumentReference ref = await _firestore.collection('tasks').doc(_user!.uid).collection('user_tasks').add(newTask.toMap());
      String taskId = ref.id; // Get the generated document ID
      await ref.update({'id': taskId}); // Update the task with the correct ID
      _taskController.clear();
      _fetchTasks(); // Fetch tasks again to update the list
    }
  }


  void _toggleTaskCompletion(String taskId) async {
    final taskRef = _firestore.collection('tasks').doc(_user!.uid).collection('user_tasks').doc(taskId);
    final taskDoc = await taskRef.get();
    if (taskDoc.exists) {
      if (taskDoc['isCompleted']) {
        await taskRef.delete();
      } else {
        taskRef.update({
          'isCompleted': true,
        });
      }
      _fetchTasks(); // Fetch tasks again to update the list
    }
  }


  void _deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(_user!.uid).collection('user_tasks').doc(taskId).delete();
    _fetchTasks(); // Fetch tasks again to update the list
  }


  void _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoginScreen(),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Logout user
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'Enter task name',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask, // Add new task
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  title: Text(task.name),
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => _toggleTaskCompletion(task.id), // Toggle task completion status
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTask(task.id), // Delete task
                  ),
                  onTap: () => _toggleTaskCompletion(task.id), // Toggle task completion status
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login, // Login user
              child: Text('Login'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _signUp, // Sign up user
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }


  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => TaskListScreen(),
      ));
    } catch (e) {
      print('Login failed: $e');
      // Handle login failure
    }
  }


  void _signUp() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => TaskListScreen(),
      ));
    } catch (e) {
      print('Sign up failed: $e');
      // Handle sign up failure
    }
  }
}
