import 'package:flutter/material.dart';
import 'package:woman_life_app/model.dart';
import 'package:woman_life_app/styleButtons.dart';

class Prediction extends StatelessWidget {
  final List<ModelOutput> modelOutputs;
  Prediction(this.modelOutputs) : super();

  @override
  Widget build(BuildContext context) {
    const double fontSizePred = 27;
    return Scaffold(
        appBar: AppBar(title: Center(child: Text('WomanLife App'))),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Predicción',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                ),
                SizedBox(height: 40),
                //Benigno
                Text(
                  modelOutputs[0].label,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: fontSizePred),
                ),
                SizedBox(height: 5),
                Text(
                  modelOutputs[0].confidence.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: fontSizePred),
                ),
                SizedBox(height: 20),
                //Maligno
                Text(
                  modelOutputs[1].label,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: fontSizePred),
                ),
                SizedBox(height: 5),
                Text(
                  modelOutputs[1].confidence.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: fontSizePred),
                ),
                SizedBox(height: 20),
                //Normal
                Text(
                  modelOutputs[2].label,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: fontSizePred),
                ),
                Text(
                  modelOutputs[2].confidence.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: fontSizePred),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ElevatedButton.icon(
                      style: galleryBtnStyle,
                      onPressed: () => {Navigator.of(context).pop()},
                      icon: Icon(Icons.arrow_back_ios),
                      label: Text('Volver')),
                )
              ]),
        ));
  }
}
