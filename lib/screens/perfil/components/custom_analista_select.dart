import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:microbank_app/models/analista.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/utils.dart';

class CustomAnalistaSelect extends StatefulWidget {
  final String title;
  final String value;
  final List<Analista> options;
  final Function onChanged;
  CustomAnalistaSelect({this.title, this.value, this.options, this.onChanged});

  @override
  _CustomSelectState createState() => _CustomSelectState();
}

class _CustomSelectState extends State<CustomAnalistaSelect> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: UniqueKey(),
      initiallyExpanded: _isExpanded,
      tilePadding: EdgeInsets.symmetric(horizontal: 15.0),
      childrenPadding: EdgeInsets.zero,
      title: Text(
        widget.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
          color: Colors.black.withOpacity(0.8),
        ),
      ),
      subtitle: Text(
        toTitleCase(widget.value) ?? '-',
        style: TextStyle(color: Colors.black),
      ),
      onExpansionChanged: (value) {
        setState(() => _isExpanded = value);
      },
      trailing: CircleAvatar(
        radius: 10.0,
        backgroundColor: kPrimaryColor,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 17,
          ),
        ),
      ),
      children: [
        Container(
          height: widget.options.length * 37.0 > 250
              ? 250
              : widget.options.length * 37.0,
          child: ListView.builder(
            itemCount: widget.options.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                splashColor: Colors.black26,
                onTap: () {
                  _isExpanded = false;
                  widget.onChanged(widget.options[index]);
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 15.0),
                  height: 37,
                  child: Text(toTitleCase(widget.options[index].name) ?? ''),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
