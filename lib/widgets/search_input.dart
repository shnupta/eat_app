import 'package:flutter/material.dart';


/// NormalTextInput is my custom class for a text input within the app.
/// It is basically a custom styles TextField. As you can see most of the code
/// is implemented using the composition by aggregation methodology.
class SearchInput extends StatefulWidget {
  // These are the properties for my widget. These are all immutable and so cannot change unless
  // the widget is rebuilt.
  final String hintText;
  final TextEditingController textEditingController;
  final TextCapitalization textCapitalization;
  final EdgeInsets margin;
	final Function onChanged;

  SearchInput(
      {
      this.hintText = '',
      @required this.textEditingController,
      this.textCapitalization = TextCapitalization.none,
      this.margin = const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
			this.onChanged,
      });

  @override
  State<StatefulWidget> createState() {
    return _SearchInputState();
  }
}


// This is a stateful widget because at some point I may add the option to be able to change the obscurity of the
// text so that a user can view their entered password if they wish to.
class _SearchInputState extends State<SearchInput> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          margin: widget.margin,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            )
          ),
          padding: const EdgeInsets.only(left: 5.0, right: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Icon(Icons.search, color: Theme.of(context).accentColor),
              ),
              Expanded(
                flex: 10,
                child: TextField(
                  textCapitalization: widget.textCapitalization,
									onChanged: (text) => widget.onChanged(text),
                  controller: widget.textEditingController,
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
