import 'package:flutter/material.dart';

class TripTypeButton extends StatefulWidget {
  final String btnText;
  final Color color;
  final VoidCallback onPress;
  TripTypeButton({Key key, this.btnText,this.color, this.onPress}) : super(key: key);

  @override
  _TripTypeButtonState createState() => _TripTypeButtonState();
}

class _TripTypeButtonState extends State<TripTypeButton> {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 100,
      height: 50,
      child:   FlatButton(
        child: Text(widget.btnText,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white), ),
      color: widget.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onPressed: widget.onPress
      ),
    );
  }
}