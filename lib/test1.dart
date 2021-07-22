import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Waite extends StatefulWidget {

  @override
  _WaiteState createState() => _WaiteState();
}

class _WaiteState extends State<Waite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SlidingUpPanelExample"),
      ),
      body: SlidingUpPanel(

        panel: Center(
          child: Text("This is the sliding Widget",style: TextStyle(color: Colors.red)),
        ),
        body: Center(
          child: Text("This is the Widget behind the sliding panel",style: TextStyle(color: Colors.red),),
        ),
      ),
    );
  }
}
