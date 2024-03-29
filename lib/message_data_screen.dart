// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddData extends StatelessWidget {
  const AddData({Key? key});

  @override
  Widget build(BuildContext context) {
    TextEditingController msgController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 179, 183, 187),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 179, 183, 187),
          centerTitle: true,
          title: const Text(
            "Message Store",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('data').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No data available'));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        return Dismissible(
                          key: Key(doc.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            FirebaseFirestore.instance
                                .collection('data')
                                .doc(doc.id)
                                .delete();
                          },
                          child: ListTile(
                            title: Text(doc['text']),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: msgController,
                onSubmitted: (value) {
                  String message = msgController.text.trim();
                  if (message.isNotEmpty) {
                    FirebaseFirestore.instance
                        .collection('data')
                        .add({'text': message});
                    msgController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please Enter Message"),
                      ),
                    );
                  }
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      String message = msgController.text.trim();
                      if (message.isNotEmpty) {
                        FirebaseFirestore.instance
                            .collection('data')
                            .add({'text': message});
                        msgController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please Enter Message"),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                  hintText: "Enter Message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
