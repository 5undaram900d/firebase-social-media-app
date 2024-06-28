
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_social_media_app/utils/A06_Utils.dart';
import 'package:firebase_social_media_app/widgets/A04_RoundButton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({Key? key}) : super(key: key);

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {

  bool loading = false;
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');

  Future getImageGallery() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }
      else{
        debugPrint("No file picked");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: (){
            getImageGallery();
          },
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black)
            ),
            child: _image != null ? Image.file(_image!.absolute) : const Icon(Icons.image,),
          ),
        ),

        const SizedBox(height: 20,),

        RoundButton(title: 'Uploaded',loading: loading, onTap: () async {
          setState(() {
            loading = true;
          });

          firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref("/folderName//${DateTime.now().millisecondsSinceEpoch.toString()}");
          firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

          Future.value(uploadTask).then((value) async{
            var newUrl = await ref.getDownloadURL();

            databaseRef.child('1').set({
              'id' : '1212',
              'title' : newUrl.toString()
            }).then((value){
              setState(() {
                loading = false;
              });
            }).onError((error, stackTrace) {
              setState(() {
                loading = false;
              });
            });

            Utils().toastMessage('Uploaded');

          }).onError((error, stackTrace) {
            Utils().toastMessage(error.toString());
          });

        })

      ],
    );
  }
}






// 20 video completed but still image not uploaded in the database storage