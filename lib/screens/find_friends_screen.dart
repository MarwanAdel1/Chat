import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class FindFriendScreen extends StatefulWidget {
  static const ROUTE_NAME = "find_friend";

  @override
  _FindFriendScreenState createState() => _FindFriendScreenState();
}

class _FindFriendScreenState extends State<FindFriendScreen> {
  bool _isLoading = false;
  bool _isSearched = false;

  final user = FirebaseAuth.instance.currentUser;

  List<QueryDocumentSnapshot> docs = [];

  DocumentSnapshot<Map<String, dynamic>> userData;

  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Find Friends'),
        actions: [searchBar.getSearchAction(context)]);
  }

  Future<void> searchByMail(String email) async {
    email.toLowerCase();
    email.trim();
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    docs = snapshot.docs;
  }

  void onSubmitted(String value) async {
    setState(() {
      _scaffoldKey.currentState;
      _isLoading = true;
      _isSearched = false;
    });
    await searchByMail(value);
    setState(() {
      _isLoading = false;
      _isSearched = true;
    });
  }

  _FindFriendScreenState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        hintText: "Search By Mail",
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : docs.length != 0
              ? Container(
                  margin: EdgeInsets.all(4),
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemBuilder: (ctxx, index) {
                      var data = docs[index].data() as Map<String, dynamic>;
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(data['image_url']),
                        ),
                        title: Text(
                          "${data['username']}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: user.uid != data['uid']
                            ? FlatButton.icon(
                                onPressed: () {
                                  
                                },
                                icon: Icon(Icons.add_circle_outline),
                                label: Text("Add Friend"),
                              )
                            : FlatButton.icon(
                                textColor: Theme.of(context).primaryColor,
                                onPressed: () {},
                                icon: Icon(Icons.person),
                                label: Text("Me"),
                              ),
                      );
                    },
                    itemCount: docs.length,
                  ),
                )
              : Center(
                  child: Text(_isSearched ? "Not Found" : "Search By Mail"),
                ),
    );
  }
}
