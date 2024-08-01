// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lesson88_upload_download/blocs/export_blocs.dart';

// import 'package:lesson88_upload_download/services/get_it.dart';
// import 'package:lesson88_upload_download/ui/screens/work_manager_screen.dart';
// import 'package:workmanager/workmanager.dart';

// @pragma(
//     'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//     print(
//         "Native called background task: $task"); //simpleTask will be emitted here.
//     return Future.value(true);
//   });
// }

// void main() {
//   setUp();
//   WidgetsFlutterBinding.ensureInitialized();
//   Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(
//           value: getIt.get<FileBloc>(),
//         ),
//         BlocProvider.value(
//           value: getIt.get<UserBloc>(),
//         ),
//       ],
//       child: const MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: WorkManagerScreen(),
//       ),
//     );
//   }
// }


// main.dart (complete app)
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Background task logic to fetch data from an API
    print("Fetching data in the background");

    final uri = Uri.parse("https://jsonplaceholder.typicode.com/todos/1");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Data fetched: $data");
    } else {
      print("Failed to fetch data. Status code: ${response.statusCode}");
    }

    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String data = 'No data available';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workmanager Example App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Fetched Data:'),
            SizedBox(height: 20),
            Text(data, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Trigger background task manually
          Workmanager().executeTask((task, inputData) {
            print("Manually triggering background task");
            return Future.value(true);
          });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Fetch initial data when the app starts
    fetchData();
  }

  // Function to fetch data from the API
  void fetchData() async {
    final uri = Uri.parse("https://jsonplaceholder.typicode.com/todos/1");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final fetchedData = json.decode(response.body);
      setState(() {
        data = fetchedData.toString();
      });
    } else {
      print("Failed to fetch data. Status code: ${response.statusCode}");
    }
  }
}
