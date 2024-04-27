// ignore_for_file: sized_box_for_whitespace
import 'package:aimpoint/aimpoint.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(
    home: AimpointPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class AimpointPage extends StatefulWidget {
  const AimpointPage({super.key});

  @override
  AimpointPageState createState() => AimpointPageState();
}

class AimpointPageState extends State<AimpointPage> {
  TargetController targetController = TargetController();
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        shadowColor: Colors.yellow[50],
        backgroundColor: Colors.yellow[50],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Aimpoint', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Text(text),
          Expanded(
            child: Center(
              child: TargetWidget(
                allowEdit: true,
                name: 'aimpoint',
                addingArrows: false,
                targetController: targetController,
                backgroundColor: Colors.yellow[50]!,
                selectedRingChanged: (var data) {
                  setState(() {
                    text = '$data';
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
