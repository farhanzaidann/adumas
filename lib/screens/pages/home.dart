import 'package:adumas/constant/HColor.dart' as c;
import 'package:adumas/core/cache/network.dart';
import 'package:adumas/models/complaint.dart';
import 'package:flutter/material.dart';

import '../../core/services/complaint_service.dart';
import '../auth/login_screen.dart';
import 'create.dart';
import 'detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Complaint> contacts;
  bool _isLoading = false;
  bool _isError = false;
  String? name;
  String? username;
  String? level;
  String? token;

  @override
  void initState() {
    sessionManager.getPref().then((value) {
      setState(() {
        token = sessionManager.nToken;
        name = sessionManager.nName;
        username = sessionManager.nUserName;
        level = sessionManager.nLevel;
      });
      // print(" IKI TOKEN ${token}");
    });
    getContacts();
    super.initState();
  }

  getContacts() {
    setState(() {
      _isLoading = true;
    });
    PhoneService().getPhoneContacts().then((value) {
      setState(() {
        contacts = value;
        _isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.blue,
          ))
        : _isError
            ? Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text("Hai, $name"),
                  backgroundColor: Colors.black,
                ),
                body: const Center(child: Text("Tidak ada laporan")),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Create(),
                      ),
                    );
                  },
                  backgroundColor: Colors.black,
                  tooltip: 'Create contact',
                  child: Icon(Icons.add, color: c.white),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text("Hai, $name"),
                  backgroundColor: Colors.black,
                  actions: [
                    IconButton(
                        onPressed: () async {
                          sessionManager.clearSession();
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) {
                            return const LoginScreen();
                          }));
                          // log("message");
                        },
                        icon: Icon(Icons.logout, color: c.white))
                  ],
                ),
                body: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Detail(id: contacts[index].id!),
                          ),
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: .5, color: Colors.grey),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    contacts[index].fullname,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 10.0),
                                  // Text(contacts[index].description.toString()),
                                  Text(contacts[index].phonenumber.toString())
                                ],
                              ),
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(height: 10.0),
                                Icon(Icons.arrow_forward_ios_rounded)
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                floatingActionButton: level == "masyarakat"
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Create(),
                            ),
                          );
                        },
                        backgroundColor: Colors.black,
                        tooltip: 'Create contact',
                        child: Icon(Icons.add, color: c.white),
                      )
                    : const SizedBox());
  }
}
