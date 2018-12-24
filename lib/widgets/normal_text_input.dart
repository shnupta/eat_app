import 'package:flutter/material.dart';


/// NormalTextInput is my custom class for a text input within the app.
/// It is basically a custom styles TextField. As you can see most of the code
/// is implemented using the composition by aggregation methodology.
class NormalTextInput extends StatefulWidget {
  // These are the properties for my widget. These are all immutable and so cannot change unless
  // the widget is rebuilt.
  final String title;
  final String hintText;
  final TextEditingController textEditingController;
  final bool obscureText;
  final TextCapitalization textCapitalization;

  NormalTextInput(
      {@required this.title,
      this.hintText = '',
      @required this.textEditingController,
      this.obscureText = false,
      this.textCapitalization = TextCapitalization.none,
      });

  @override
  State<StatefulWidget> createState() {
    return _NormalTextInputState();
  }
}


// This is a stateful widget because at some point I may add the option to be able to change the obscurity of the
// text so that a user can view their entered password if they wish to.
class _NormalTextInputState extends State<NormalTextInput> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: Theme.of(context).accentColor,
                  width: 0.5,
                  style: BorderStyle.solid),
            ),
          ),
          padding: const EdgeInsets.only(left: 0.0, right: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextField(
                  textCapitalization: widget.textCapitalization,
                  controller: widget.textEditingController,
                  obscureText: widget.obscureText,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
