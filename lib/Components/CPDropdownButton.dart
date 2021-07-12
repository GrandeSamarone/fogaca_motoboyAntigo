
import 'package:flutter/material.dart';

class CPDropdownButton extends StatefulWidget {

    String dropdownValue;
    List <String> spinnerItems;
    CPDropdownButton({
    @required this.dropdownValue,
    @required this.spinnerItems,
  });

  @override
  _CPDropdownButtonState createState() => _CPDropdownButtonState();
}

class _CPDropdownButtonState extends State<CPDropdownButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  DropdownButton<String>(
      value: widget.dropdownValue,
      isExpanded: true,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Theme.of(context).textTheme.headline4.color, fontSize: 16,fontFamily:  "Brand Bold"),
      underline: Container(
        height: 2,
        color: Theme.of(context).textTheme.headline4.color,
      ),
      onChanged: (String data) {
        setState(() {
          widget.dropdownValue = data;
          return;
        });
      },
      items: widget.spinnerItems.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Center(
            child: Text(
              value,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    );
  }
}