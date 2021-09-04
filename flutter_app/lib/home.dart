import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();

  @override
  // ignore: must_call_super
  void initState() {
    loadModel().then((value) {
      setState(() {});
    });
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output!;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    Tflite.close();
    super.dispose();
  }

  pickImage() async {
    // ignore: deprecated_member_use
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  pickGalleryImage() async {
    // ignore: deprecated_member_use
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    var crossAxisAlignment;
    return Scaffold(
        backgroundColor: Color(0xFF101010),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
                crossAxisAlignment: crossAxisAlignment.start,
                children: <Widget>[
                  SizeBox(height: 85),
                  Text(
                    'CNN',
                    style: TextStyle(color: Color(0xFFEEDA28), fontSize: 18),
                  ),
                  SizeBox(height: 6),
                  Text(
                    'Detects the tumour',
                    style: TextStyle(
                        color: color(0xFFE99600),
                        fontWeight: FontWeight.w500,
                        fontSize: 28),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: _loading
                        ? Container(
                            width: 280,
                            child: Column(
                              children: <Widget>[
                                Image.asset('assets/photo.jpeg'),
                                SizeBox(height: 50),
                              ],
                            ),
                          )
                        : Container(
                            child: Coloum(children: <Widget>[
                              Container(
                                height: 250,
                                child: Image.file(_image),
                              ),
                              SizeBox(
                                height: 20,
                              ),
                              // ignore: unnecessary_null_comparison
                              _output != null
                                  ? Text(
                                      '${_output[0]['label']}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  : Container(),
                              SizeBox(height: 10),
                            ]),
                          ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                            onTap: pickGalleryImage,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 150,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 17),
                              decoration: BoxDecoration(
                                color: Color(0xFFE9960),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Take a photo',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                        SizeBox(height: 10),
                        GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 150,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 17),
                              decoration: BoxDecoration(
                                color: Color(0xFFE9960),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Camera Roll',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  )
                ])));
  }

  // ignore: non_constant_identifier_names
  SizeBox({required int height}) {}

  color(int i) {}

  // ignore: non_constant_identifier_names
  Coloum({List<Widget>? children}) {}
}
