
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_social_media_app/ui/posts/A11_ImageUpload.dart';
import 'package:firebase_social_media_app/utils/A06_Utils.dart';
import 'package:firebase_social_media_app/widgets/A04_RoundButton.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30,),
              TextFormField(
                controller: postController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'What is in your mind?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30,),
              RoundButton(title: 'Add', loading: loading, onTap: (){
                setState(() {
                  loading = true;
                });

                String id = DateTime.now().millisecondsSinceEpoch.toString();

                databaseRef.child(id).set({
                  'title': postController.text.toString(),
                  'id' : id
                }).then((value) {
                  Utils().toastMessage('Post added');
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });

              }),

              const SizedBox(height: 20,),

              const ImageUploadScreen(),


            ],
          ),
        ),
      ),
    );
  }

}




// 11 video complete