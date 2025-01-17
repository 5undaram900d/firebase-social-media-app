
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_social_media_app/ui/auth/A03_LoginScreen.dart';
import 'package:firebase_social_media_app/ui/posts/A10_AddPost.dart';
import 'package:firebase_social_media_app/utils/A06_Utils.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget{
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilterController = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Post'),
        actions: [
          IconButton(onPressed: (){
            auth.signOut().then((value){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            }).onError((error, stackTrace){
              Utils().toastMessage(error.toString());
            });
          }, icon: const Icon(Icons.logout)),
          const SizedBox(width: 10,)
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: searchFilterController,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder()
              ),
              onChanged: (String value){
                setState(() {

                });
              },
            ),
          ),





          //                   /****** by 2nd way to get from database (best approach) ******/
          // Expanded(
          //   child: StreamBuilder(
          //     stream: ref.onValue,
          //     builder: (context, AsyncSnapshot<DatabaseEvent> snapshot){
          //       if(!snapshot.hasData){
          //         return CircularProgressIndicator();
          //       }
          //       else{
          //         Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
          //         List<dynamic> list = [];
          //         list.clear();
          //         list = map.values.toList();
          //         return ListView.builder(
          //           itemCount: snapshot.data!.snapshot.children.length,
          //           itemBuilder: (context, index){
          //           return ListTile(
          //             title: Text(list[index]['title']),
          //             subtitle: Text(list[index]['id']),
          //           );
          //         });
          //       }
          //     }
          //   )
          // ),






                      /****** by 1st way to get data from the database *******/
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              defaultChild: const Text('loading'),
              itemBuilder: (context, snapshot, animation, index){

                final title = snapshot.child('title').value.toString();

                if(searchFilterController.text.isEmpty){

                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              showMyDialog(title, snapshot.child('id').value.toString());
                            },
                            leading: const Icon(Icons.edit),
                            title: const Text('Edit'),
                          )
                        ),
                        PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                ref.child(snapshot.child('id').value.toString()).remove();
                              },
                              leading: const Icon(Icons.delete),
                              title: const Text('Delete'),
                            )
                        ),
                      ],
                    ),
                  );

                }
                else if(title.toLowerCase().contains(searchFilterController.text.toLowerCase().toString())){
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                }
                else{
                  return Container();
                }
              }
            ),
          ),




        ],
      ),



      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const Icon(Icons.add),
      ),


    );
  }


  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Update'),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(
            hintText: 'Edit here'
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text('Cancel')),

          TextButton(onPressed: (){
            Navigator.pop(context);
            ref.child(id).update({
              'title': editController.text.toLowerCase()
            }).then((value) {
              Utils().toastMessage('Post Updated');
            }).onError((error, stackTrace) {
              Utils().toastMessage(error.toString());
            });
          }, child: const Text('Update'))
        ],
      );
    });
  }

}
