import 'dart:io';
import 'package:flutter/material.dart';

void main() async{
  DisplayState.currentIPAddress = await DisplayState.queryIpAddress;
  runApp(
    MaterialApp(      
      initialRoute: 'display',
      routes:       {
        'display':     (context) => const Display(),
      }
    )
  );
}

class Display extends StatefulWidget {
  const Display({super.key});

  @override
  State<Display> createState() => DisplayState();
}

class DisplayState extends State<Display> {
  // ----- < Variables [Static]> ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  static InternetAddress? currentIPAddress;

  // ----- < Variables > - ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  TextStyle customTextStyle = const TextStyle(color: Color.fromARGB(255, 50, 50, 0), fontSize: 20);

  // ----- < Main Widget Build > ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title:            const Text('IP Address test'),
      backgroundColor:  Colors.yellowAccent,
      foregroundColor:  Colors.black,
      centerTitle:      true,
    ),
    backgroundColor: const Color.fromARGB(255, 255, 255, 200),
    body: _drawBody,
  );

  // ----- < Widgets [1] > ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  Widget get _drawBody => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text('Current IP Address: [ ${currentIPAddress?.address} ]', style: customTextStyle)
  ]));

  // ----- < Methods [Static] >  ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  static Future<InternetAddress> get queryIpAddress async{
    var interface = await NetworkInterface.list();
    return interface[0].addresses.first;
  }
}