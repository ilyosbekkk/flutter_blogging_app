import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostBottomSheet extends StatefulWidget {
  const PostBottomSheet();

  @override
  _PostBottomSheetState createState() => _PostBottomSheetState();
}

class _PostBottomSheetState extends State<PostBottomSheet> {
  File _file;
  ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildDivider(),
              _buildTitle(),
              _buildContent(),
              _file!=null ? _buildImage() : _buildPictureSelector(context),
              _buildPostWidget()],
          ),
        ),
      ),
    );
  }


  //region build widgets
  Widget _buildHeader(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close)),
          Spacer(),
          Text(
            "Create Post",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 10, left: 10),
      child: TextFormField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Your title",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 10, left: 10),
      child: TextFormField(
        maxLines: 5,
        decoration: InputDecoration(
          hintText: "What's in your mind?",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildPictureSelector(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MaterialButton(
              elevation: 5.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              color: Color.fromRGBO(255, 255, 240, 0.8),
              onPressed: () {
                _buildBottomSheet(context);
              },
              child: Text("Photo")),
          MaterialButton(elevation: 5.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), color: Color.fromRGBO(255, 255, 240, 0.8), onPressed: () {}, child: Text("Video")),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Image.file(_file)
    );
  }

  Widget _buildPostWidget() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      width: double.infinity,
      child: MaterialButton(elevation: 5.0, textColor: Colors.white, onPressed: () {}, child: Text("POST")),
      color: Colors.blue,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.black38,
      height: 1,
    );
  }

  Future<void> _buildBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    onPressed: () async {
                      await getImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Text("Camera"),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      await getImage(ImageSource.gallery);
                      Navigator.pop(context);

                      },
                    child: Text("Photo"),
                  ),
                ],
              ),
            ));
  }

  //reion utils
  Future getImage(ImageSource imageSource) async {
    final pickedFile = await _imagePicker.getImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
      });

      print(await pickedFile.readAsBytes());

    } else {
      print("No image selected");
    }
  }
}