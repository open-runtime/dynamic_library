import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late DynamicLibrary dynamicLibrary;

  MyApp({Key? key}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    loadDynamicLibrary(libraryName: 'hello_world');
    dynamicLibrary = DynamicLibrary.open(fullLibraryName('hello_world'));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
    );
  }
}
