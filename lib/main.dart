import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async{
  HandleIPAddress.currentIPAddress = await HandleIPAddress.queryIpAddress;
  runApp(
    MaterialApp(      
      initialRoute: 'display',
      routes:       {
        'display':     (context) => const Display(),
      }
    )
  );
  HandleIPAddress.loopBackgroundIpAddressCheck();
  if(kDebugMode)print("it seems loop is working?");
}

class HandleIPAddress { //#######################################################################################################//
  // ----- < Variables [Static]> ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  static List<NetworkInterface> _interface =      List<NetworkInterface>.empty();
  static bool enableBackgroundIPAddressCheck =    true;
  static InternetAddress? currentIPAddress;
  static InternetAddress? examingIPAddress;

  // ----- < Methods [Static] >  ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  static Future<InternetAddress> get queryIpAddress async{
    _interface =        await NetworkInterface.list();
    return _interface[0].addresses.first;
  }

  static Future loopBackgroundIpAddressCheck() async {while(enableBackgroundIPAddressCheck){
    await Future.delayed(const Duration(seconds: 10));
    try{
      examingIPAddress = await queryIpAddress;
      if(examingIPAddress!.address != currentIPAddress!.address){
        currentIPAddress =                            examingIPAddress;
        DisplayState.ipAddressChangeNotifier.value =  currentIPAddress!.address;
      }
    }
    catch(e) {continue;}
    DisplayState.counterInt.value++;
  }}
}

class Display extends StatefulWidget { //########################################################################################//
  const Display({super.key});

  @override
  State<Display> createState() => DisplayState();
}

class DisplayState extends State<Display> { //###################################################################################//
  // ----- < Variables [Static] > ---- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  // ----- < Variables > - ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  static ValueNotifier<String> ipAddressChangeNotifier =  ValueNotifier(HandleIPAddress.currentIPAddress!.address);
  static ValueNotifier<int> counterInt =                  ValueNotifier(0);
  TextStyle customTextStyle =                             const TextStyle(color: Color.fromARGB(255, 50, 50, 0), fontSize: 20);

  // ----- < Constructors > ---- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  DisplayState() {
    ipAddressChangeNotifier.addListener(() => setState((){}));
    counterInt.addListener(() => setState((){}));
  }

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
    Text('Current IP Address: [ ${ipAddressChangeNotifier.value} ]', style: customTextStyle),
    Text('Loop counter: ${counterInt.value}', style: customTextStyle),
    _drawButtonTerminateIPAddressCheck
  ]));

  // ----- < Widgets [2] > ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
  Widget get _drawButtonTerminateIPAddressCheck => TextButton(
    style:      ButtonStyle(backgroundColor: MaterialStateProperty.all((HandleIPAddress.enableBackgroundIPAddressCheck)? Colors.yellow : Colors.grey)),
    onPressed:  () => setState(() => HandleIPAddress.enableBackgroundIPAddressCheck = false),
    child:      Text('Terimnate IP Address Check', style: customTextStyle,)
  );

}