import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async{
  await HandleIPAddress.queryIpAddress;
  HandleIPAddress.loopBackground;
  runApp(
    MaterialApp(      
      initialRoute: 'display',
      routes:       {
        'display':     (context) => const Display(),
      }
    )
  );
}

class HandleIPAddress { //#######################################################################################################//
  // ----- < Variables [Static]> ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  static List<NetworkInterface> _interface =  List<NetworkInterface>.empty();
  static dynamic isolate;
  static InternetAddress? currentIPAddress;
  static InternetAddress? examingIPAddress;

  // ----- < Methods [Static] >  ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  static Future get queryIpAddress async{
    _interface =        await NetworkInterface.list();
    currentIPAddress =  _interface[0].addresses.first;
  }

  static void get loopBackground async{ while(true){
    await Future.delayed(const Duration(seconds: 10));
    if(kDebugMode)print('Loop is still running');
  }}//isolate = await Isolate.spawn<void>((message) => _loopBackgroundIpAddressCheck, null);

  // ----- < Methods [2] > ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  static void _loopBackgroundIpAddressCheck() async {while(true){
    await Future.delayed(const Duration(seconds: 10));
    /*_interface =        await NetworkInterface.list();
    examingIPAddress =  _interface[0].addresses.first;
    if(examingIPAddress!.address != currentIPAddress!.address){
      currentIPAddress = examingIPAddress;                            // If the examined IPAddress is drifferent
    }*/
    if(kDebugMode)print('background is running');
  }}
}

class Display extends StatefulWidget { //########################################################################################//
  const Display({super.key});

  @override
  State<Display> createState() => DisplayState();
}

class DisplayState extends State<Display> { //###################################################################################//
  // ----- < Variables > - ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  ValueNotifier<String> ipAddressChangeNotifier = ValueNotifier(HandleIPAddress.currentIPAddress!.address);
  TextStyle customTextStyle =                     const TextStyle(color: Color.fromARGB(255, 50, 50, 0), fontSize: 20);

  // ----- < Constructors > ---- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  DisplayState() {ipAddressChangeNotifier.addListener(() => setState((){}));}

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
    Text('Current IP Address: [ ${ipAddressChangeNotifier.value} ]', style: customTextStyle)
  ]));
}