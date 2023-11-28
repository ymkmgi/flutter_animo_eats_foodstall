import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

// ignore: must_be_immutable
class Vendor extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String location;
  final String? image;
  final DateTime createdAt;

  // id is the document id
  String? id;

  Vendor({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.createdAt,
    this.image,
  });

  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      location: map['location'],
      image: map['image'],
      createdAt: map['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': name,
      'email': email,
      'phone': phone,
      'location': location,
      'image': image,
      'createdAt': createdAt,
    };
  }

  factory Vendor.fromHive() {
    var box = Hive.box('myBox');
    return Vendor(
      name: box.get('name', defaultValue: ''),
      email: box.get('email', defaultValue: ''),
      phone: box.get('phone', defaultValue: ''),
      location: box.get('location', defaultValue: ''),
      image: box.get('image', defaultValue: null),
      createdAt: box.get('createdAt', defaultValue: DateTime.now()),
    );
  }

  Future<void> saveToHive() async {
    var box = Hive.box('myBox');

    box.put('name', name);
    box.put('id', name);
    box.put('email', email);
    box.put('phone', phone);
    box.put('location', location);
    box.put('image', image);
    box.put('createdAt', createdAt);
  }

  @override
  List<Object?> get props => [
        name,
        email,
        phone,
        location,
        image,
        createdAt,
      ];
}