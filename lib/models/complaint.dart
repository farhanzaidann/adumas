class Complaint {
  String? id;
  String fullname;
  String description;
  String tanggapan;
  int phonenumber;

  Complaint({
    this.id,
    required this.fullname,
    required this.description,
    required this.tanggapan,
    required this.phonenumber,
  });
  Map<dynamic, dynamic> toJson() {
    return {
      "fullname": fullname,
      "description": description,
      "tanggapan": tanggapan,
      "phonenumber": phonenumber,
    };
  }

  factory Complaint.fromJson(Map<dynamic, dynamic> json) {
    return Complaint(
      id: json['_id'],
      fullname: json['fullname'],
      description: json['description'],
      tanggapan: json['tanggapan'],
      phonenumber: json['phonenumber'],
    );
  }
}