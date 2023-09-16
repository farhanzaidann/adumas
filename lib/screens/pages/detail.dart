import 'package:adumas/models/complaint.dart';
import 'package:adumas/screens/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/complaint_service.dart';

class Detail extends StatefulWidget {
  const Detail({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  // List<String> list = <String>[
  //   'Dibuka',
  //   'Proses',
  //   'Selesai',
  // ];
  String dropdownValue = 'Dibuka';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _phonenumber = TextEditingController();
  final TextEditingController _tanggapan = TextEditingController();
  late Complaint contact;
  bool _isLoading = false;
  bool _isSubmitting = false;
  bool _isError = false;
  String? masyarakat;
  void checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      masyarakat = prefs.getString('lastName');
    });
  }

  @override
  void initState() {
    checkUser();
    getContacts();
    super.initState();
  }

  getContacts() {
    setState(() {
      _isLoading = true;
    });
    PhoneService().getSinglePhoneContact(widget.id).then((value) {
      setState(() {
        contact = value;
        _isLoading = false;
      });
      _fullname.text = value.fullname;
      _description.text = value.description;
      _tanggapan.text = value.tanggapan;
      _phonenumber.text = value.phonenumber.toString();
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    });
  }

  updateContact(
    String fullname,
    String description,
    String tanggapan,
    int phonenumber,
    String validasi,
  ) {
    setState(() {
      _isSubmitting = true;
    });
    PhoneService()
        .updatePhoneContact(
            widget.id, fullname, description, tanggapan, phonenumber, validasi)
        .then((value) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan berhasil di update')),
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route route) => false);
    }).catchError((onError) {
      setState(() {
        _isSubmitting = false;
        _isError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating contact!')),
      );
    });
  }

  deleteContact() {
    setState(() {
      _isSubmitting = true;
    });
    PhoneService().deletePhoneContact(widget.id).then((value) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan berhasil dihapus')),
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route route) => false);
    }).catchError((onError) {
      setState(() {
        _isSubmitting = false;
        _isError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting contact!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // String dropdownValue = list.first;
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.blue,
          ))
        : _isError
            ? const Center(
                child: Text(
                  'null',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: const Text("Details"),
                  backgroundColor: Colors.black,
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Laporan',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                TextFormField(
                                  controller: _fullname,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please input your fullname';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    hintText: "input name",
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLines: null,
                                ),
                                const SizedBox(height: 30.0),
                                const Text(
                                  'Detail Laporan',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                TextFormField(
                                  controller: _description,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please input your description';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    hintText: "input description",
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLines: null,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                const Text(
                                  'NIK',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                TextFormField(
                                  controller: _phonenumber,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please input your phone number';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    hintText: "input phone number",
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                const Text(
                                  'Tanggapan',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                TextFormField(
                                  controller: _tanggapan,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please input your tanggapan';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    hintText: "input tanggapan",
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLines: null,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                masyarakat == "masyarakat"
                                    ? const SizedBox()
                                    : const Text(
                                        'Validasi',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                masyarakat == "masyarakat"
                                    ? const SizedBox()
                                    : DropdownButton<String>(
                                        // Step 3.
                                        value: dropdownValue,
                                        // Step 4.
                                        items: <String>[
                                          'Dibuka',
                                          'Proses',
                                          'Selesai',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          );
                                        }).toList(),
                                        // Step 5.
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });
                                        },
                                      ),
                              ],
                            ),
                            //MASIH SALAHHH
                            masyarakat == "masyarakat"
                                ? dropdownValue == "Dibuka"
                                    ? const Center(
                                        child: Text("Laporanmu masih dibuka"),
                                      )
                                    : dropdownValue == "Proses"
                                        ? const Center(
                                            child: Text(
                                                "Laporanmu masih diproses"),
                                          )
                                        : dropdownValue == "Selesai"
                                            ? const Center(
                                                child: Text(
                                                    "Selamat laporanmu selesai"),
                                              )
                                            : const SizedBox()
                                : const SizedBox()
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        masyarakat == "masyarakat"
                            ? const SizedBox()
                            : SizedBox(
                                height: 45,
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: _isSubmitting
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            updateContact(
                                              _fullname.text,
                                              _description.text,
                                              _tanggapan.text,
                                              int.parse(_phonenumber.text),
                                              dropdownValue,
                                            );
                                          }
                                        },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                  ),
                                  child: const Text(
                                    'Update laporan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: (masyarakat == "masyarakat")
                    ? const SizedBox()
                    : FloatingActionButton(
                        onPressed: _isSubmitting
                            ? null
                            : () {
                                deleteContact();
                              },
                        backgroundColor: Colors.red,
                        tooltip: 'Delete',
                        child: const Icon(Icons.delete),
                      ),
              );
  }
}
