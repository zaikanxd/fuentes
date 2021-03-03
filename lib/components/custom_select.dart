import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:microbank_app/models/select_option.dart';
import 'package:microbank_app/utils/constans.dart';

class CustomSelect extends StatefulWidget {
  final String title;
  final String value;
  final List<SelectOption> options;
  final Function onChanged;
  CustomSelect({this.title, this.value, this.options, this.onChanged});

  @override
  _CustomSelectState createState() => _CustomSelectState();
}

class _CustomSelectState extends State<CustomSelect> {
  List<SelectOption> selectableOptions;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    selectableOptions = (widget.value != null)
        ? widget.options.where((e) => e.valor != widget.value).toList()
        : widget.options;
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
      subtitle: widget.value != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Colors.black54,
                ),
                Text(
                  widget.options
                      .where((option) => option.valor == widget.value)
                      .first
                      .nombre,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            )
          : null,
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
          height: selectableOptions.length * 37.0,
          child: ListView.builder(
            itemCount: selectableOptions.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                splashColor: Colors.black26,
                onTap: () {
                  _isExpanded = false;
                  widget.onChanged(selectableOptions[index]);
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 15.0),
                  height: 37,
                  child: Text(selectableOptions[index].nombre),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
