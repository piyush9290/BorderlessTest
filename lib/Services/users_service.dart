import 'dart:convert';
import 'package:borderless_test/Services/services_helper.dart';
import 'package:http/http.dart' as http;

class User {
  final String email;
  final String firstName;
  final String id;
  final String lastName;

  const User({
    required this.email,
    required this.firstName,
    required this.id,
    required this.lastName
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String, 
      firstName: json['firstName'] as String, 
      id: json['id'] as String, 
      lastName: json['lastName'] as String
    );
  }
}

abstract class UsersService {
  Future<List<User>> getUsers() async {
    throw ImplementationException();
  }
} 

class UsersServiceImp implements UsersService {
  @override
  Future<List<User>> getUsers() async {
    final url = Uri.parse(ServicePath.users.urlString());
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dataBody = response.body;
      final json = jsonDecode(dataBody).cast<Map<String, dynamic>>();
      final list = json.map<User>((json) => User.fromJson(json)).toList();
      return list;
    } else {
      throw ServiceException();
    }
  }
}