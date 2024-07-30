import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/home/bloc/tab_container_bloc.dart';
import 'package:gallery_app/home/widgets/tab_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery Home'),
        centerTitle: true,
      ),
      body: Center(
        child: BlocProvider<TabContainerBloc>(
          create: (context) => TabContainerBloc(),
          child: const TabContainer(),
        ),
      ),
    );
  }
}
