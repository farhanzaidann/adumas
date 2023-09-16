// // ignore_for_file: unused_field, unnecessary_null_comparison

// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:mongo_dart/mongo_dart.dart' show Db, GridFS;

// class PickImagee extends StatefulWidget {
//   const PickImagee({super.key, required this.title});

//   final String title;

//   @override
//   _PickImageeState createState() => _PickImageeState();
// }

// class _PickImageeState extends State<PickImagee>
//     with SingleTickerProviderStateMixin {
//   final url = [
//     "mongodb+srv://farhnzaidan:2wsx1qaz@cluster0.7kysiea.mongodb.net/?retryWrites=true&w=majority",
//     "mongodb+srv://farhnzaidan:2wsx1qaz@cluster0.7kysiea.mongodb.net/?retryWrites=true&w=majority",
//     "mongodb+srv://farhnzaidan:2wsx1qaz@cluster0.7kysiea.mongodb.net/?retryWrites=true&w=majority"
//   ];

//   final picker = ImagePicker();
//   late File _image;
//   late GridFS bucket;
//   late AnimationController _animationController;
//   late Animation<Color> _colorTween;
//   late ImageProvider provider;
//   var flag = false;

//   @override
//   void initState() {
//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 1800),
//       vsync: this,
//     );
//     _animationController.repeat();
//     super.initState();
//     connection();
//   }

//   Future getImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       var _cmpressed_image;
//       try {
//         _cmpressed_image = await FlutterImageCompress.compressWithFile(
//             pickedFile.path,
//             format: CompressFormat.heic,
//             quality: 70);
//       } catch (e) {
//         _cmpressed_image = await FlutterImageCompress.compressWithFile(
//             pickedFile.path,
//             format: CompressFormat.jpeg,
//             quality: 70);
//       }
//       setState(() {
//         flag = true;
//       });

//       Map<String, dynamic> image = {
//         "_id": pickedFile.path.split("/").last,
//         "data": base64Encode(_cmpressed_image)
//       };
//       // ignore: unused_local_variable
//       var res = await bucket.chunks.insert(image);
//       var img =
//           await bucket.chunks.findOne({"_id": pickedFile.path.split("/").last});
//       setState(() {
//         provider = MemoryImage(base64Decode(img!["data"]));
//         flag = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//           backgroundColor: Colors.green,
//         ),
//         body: SingleChildScrollView(
//             child: Center(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 20,
//               ),
//               provider == null
//                   ? Text('No image selected.')
//                   : Image(
//                       image: provider,
//                     ),
//               SizedBox(
//                 height: 10,
//               ),
//               if (flag == true)
//                 CircularProgressIndicator(valueColor: _colorTween),
//               SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                 onPressed: getImage,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: <Color>[
//                         Colors.green,
//                       ],
//                     ),
//                   ),
//                   padding: const EdgeInsets.all(10.0),
//                   child: const Text('Select Image',
//                       style: TextStyle(fontSize: 20)),
//                 ),
//               ),
//             ],
//           ),
//         )));
//   }

//   Future connection() async {
//     Db _db = new Db.pool(url);
//     await _db.open(secure: true);
//     bucket = GridFS(_db, "image");
//   }
// }
