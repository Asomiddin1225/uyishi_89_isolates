import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

class WorkManagerScreen extends StatelessWidget {
  const WorkManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Manager"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Workmanager Example App'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Schedule a background task to run every 15 minutes
                Workmanager().registerOneOffTask(
                  "task-identifier",
                  "simpleTask",
                  initialDelay: Duration(seconds: 5),
                );
              },
              child: Text('Schedule Background Task'),
            ),
          ],
        ),
      ),
    );
  }
}
