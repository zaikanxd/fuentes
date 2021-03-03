import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:microbank_app/utils/constans.dart';

String dateWithSlashToDate(String dateWithSlash) {
  String year = dateWithSlash.substring(dateWithSlash.length - 4);
  String day = dateWithSlash.substring(0, 2);
  String month = dateWithSlash.substring(
      dateWithSlash.indexOf('/') + 1, dateWithSlash.lastIndexOf('/'));
  return year + '-' + month + '-' + day;
}

Future<File> showDialogImagePicker(BuildContext context, Function updateImage) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        content: Container(
          height: 100,
          child: Column(
            children: [
              FlatButton(
                  textColor: kPrimaryColor,
                  onPressed: () async {
                    Navigator.pop(context);
                    uploadImage(isGalery: true, updateImage: updateImage);
                  },
                  child: const Text("Elegir Foto")),
              FlatButton(
                  textColor: kPrimaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                    uploadImage(isGalery: false, updateImage: updateImage);
                  },
                  child: const Text("Tomar una Foto")),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      );
    },
  );
}

Future<void> uploadImage({bool isGalery, Function updateImage}) async {
  final ImagePicker _picker = ImagePicker();

  PickedFile image = await _picker.getImage(
      source: isGalery ? ImageSource.gallery : ImageSource.camera,
      maxHeight: 1024,
      maxWidth: 1024);
  if (image != null) {
    updateImage(image.path);
  }
}

String dateToString({String format, DateTime dateTime}) {
  return DateFormat(format, 'es').format(dateTime);
}

void showMessage(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ),
  );
}

String toTitleCase(String text) {
  String newText = '';
  Map<int, String> textMap = text?.split(' ')?.asMap();
  textMap?.forEach((index, word) {
    if (word.length > 1) {
      newText += word.toLowerCase().replaceRange(0, 1, word[0].toUpperCase()) +
          (textMap.length == 1 ||
                  (textMap.length > 1 && index == textMap.length)
              ? ''
              : ' ');
    }
  });
  return newText.trimRight();
}

void showCustomDialog(BuildContext context, Widget child, Function onTap) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('¿Cerrar Sesión?'),
        content: child,
        insetPadding: EdgeInsets.all(15.0),
        actions: [
          FlatButton(
              textColor: kPrimaryColor,
              onPressed: () {
                Navigator.pop(context);
                onTap();
              },
              child: Text("CONFIRMAR")),
          FlatButton(
              textColor: kPrimaryColor,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("CANCELAR")),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      );
    },
  );
}

void showDialogImage(BuildContext context, Uint8List imageBytes) async {
  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
        content: ClipRRect(
          child: Image.memory(
            imageBytes,
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        buttonPadding: EdgeInsets.zero,
        scrollable: false,
      );
    },
  );
}
