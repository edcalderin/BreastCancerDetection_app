import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:woman_life_app/alertDialog.dart';
import 'package:woman_life_app/model.dart';
import 'package:woman_life_app/prediction.dart';
import 'package:woman_life_app/styleButtons.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WomanLife',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CameraDescription> cameras;
  CameraController controller;
  bool _isReady = false;
  bool loading = false;
  XFile _image;
  List listResult;
  @override
  void initState() {
    super.initState();
    loading = true;
    _setupCameras();
    loadModel();
  }

  void loadModel() async {
    String result = await Tflite.loadModel(
      model: "assets/tflite_cancer_model.tflite",
      labels: "assets/labels.txt",
    );
    setState(() {
      loading = false;
    });
    print(result);
  }

  Future<void> _setupCameras() async {
    try {
      // initialize cameras.
      cameras = await availableCameras();
      // initialize camera controllers.
      controller = new CameraController(cameras[0], ResolutionPreset.medium);
      await controller.initialize();
    } on CameraException catch (_) {
      // do something on error.
    }
    if (!mounted) return;
    setState(() {
      _isReady = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('WomanLife App')),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              getCamera(),
              Container(
                  padding: EdgeInsets.only(bottom: 25),
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                            style: cameraBtnStyle,
                            onPressed: () => {},
                            icon: Icon(Icons.camera_alt),
                            label: Text('Cámara')),
                        ElevatedButton.icon(
                            style: galleryBtnStyle,
                            onPressed: () => openGallery(),
                            icon: Icon(Icons.image),
                            label: Text('Galería'))
                      ]))
            ],
          ),
        ));
  }

  Future<void> openGallery() async {
    final imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
      loading = true;
    });
    imageClasification(_image);
  }

  Future imageClasification(image) async {
    if (image == null) {
      setState(() {
        loading = false;
      });
    } else {
      predictImage(image);
    }
  }

  Future predictImage(image) async {
    List output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 3,
        threshold: 0.2,
        imageMean: 100,
        imageStd: 100);
    setState(() {
      loading = false;
    });
    if (output.length == 0) {
      showAlertDialog(context);
    } else {
      final List<ModelOutput> processOutput = getOutputs(output);
      setState(() {
        loading = false;
        listResult = output;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Prediction(processOutput)),
      );
    }
  }

  List<ModelOutput> getOutputs(List output) {
    List<ModelOutput> modelOutput = [];
    for (var item in output) {
      final ModelOutput modelOut = ModelOutput();
      modelOut.confidence = item['confidence'];
      modelOut.label = item['label'];
      modelOutput.add(modelOut);
    }
    return modelOutput;
  }

  Widget getCamera() {
    if (!_isReady) {
      return Container();
    }
    return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        child: CameraPreview(controller));
  }
}

@override
Widget build(BuildContext context) {
  // Fill this out in the next steps.
  return MyHomePage();
}
