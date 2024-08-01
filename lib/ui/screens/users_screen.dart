import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lesson88_upload_download/blocs/export_blocs.dart';
import 'package:lesson88_upload_download/blocs/user/user_event.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users with Isolates"),
      ),
      body: Column(
        children: [
          Image.asset("assets/ball.gif"),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              FilledButton(
                onPressed: () {
                  context.read<UserBloc>().add(
                        GetUsersCountWithIsolate(1000000000),
                      );
                },
                child: const Text("Count with Isolate"),
              ),
              FilledButton(
                onPressed: () {
                  context.read<UserBloc>().add(
                        GetUsersCount(1000000000),
                      );
                },
                child: const Text("Count without Isolate"),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              context.read<UserBloc>().add(GetPhotosWithIsolate());
            },
            child: const Text("Get Photos with Isolate"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<UserBloc>().add(GetPhotos());
            },
            child: const Text("Get Photos without Isolate"),
          ),
        ],
      ),
    );
  }
}
