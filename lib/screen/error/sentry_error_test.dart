import 'package:flutter/material.dart';

class ErrorScreen extends StatefulWidget {
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  int _counter = 0;

  // Simulating an error by trying to call setState after widget is unmounted
  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration(seconds: 2), () {
      // Here we update the state without checking if the widget is still mounted
      setState(() {
        _counter++;
      });
    });
    Future.delayed(Duration(seconds: 4), () {
      // After the widget is unmounted, another setState call happens (this will throw an error)
      setState(() {
        _counter++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error Example')),
      body: Center(
        child: Text('Counter: $_counter'),
      ),
    );
  }
}
