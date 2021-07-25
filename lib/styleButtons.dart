import 'package:flutter/material.dart';

final ButtonStyle cameraBtnStyle = TextButton.styleFrom(
  primary: Colors.white,
  elevation: 0,
  side: BorderSide(color: Colors.white),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
);
final ButtonStyle galleryBtnStyle = TextButton.styleFrom(
  primary: Colors.orange,
  elevation: 0,
  backgroundColor: Colors.white,
  side: BorderSide(color: Colors.orange),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
);
