import 'dart:convert';

import 'package:nielts/context/token_service.dart';
import 'package:nielts/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:nielts/constants/urls.dart';
import 'package:http/http.dart' as http;

class User {
  final int id;
  final String userName;
  final String firstName;
  final String lastName;
  final String avatar;

  User(
      {required this.id,
      required this.userName,
      required this.firstName,
      required this.lastName,
      required this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['username'],
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      avatar: "assets/profile_image.jpg",
    );
  }
}

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  List<User> users = [];
  String query = '';

  Future<List<User>>? _usersFuture;
  Future<List<User>> fetchAllUsers() async {
    final String? access = await TokenService().getAccessToken();
    final response = await http.get(
      Uri.parse(allUsersRef),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseBody = json.decode(response.body);
      return responseBody.map((item) => User.fromJson(item)).toList();
    } else {
      print('Error fetching users: ${response.body}');
      return [];
    }
  }

  Future<void> addFriend(int friendId) async {
    final String? access = await TokenService().getAccessToken();
    final response = await http.post(
      Uri.parse(addFriendRef),
      headers: {
        'Authorization': 'Bearer $access',
      },
      body: {'friend_id': friendId.toString()},
    );

    if (response.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Material(child: HomePage()),
        ),
      );
      print('Friend added successfully.');
    } else {
      print('Error adding friend.');
    }
  }

  @override
  void initState() {
    super.initState();
    _usersFuture = fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add friends"),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<User>>(
                  future: _usersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('There is no users'));
                    } else {
                      List<User> users = snapshot.data!;
                      return Material(
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(users[index].userName),
                              trailing: SizedBox(
                                width: 100,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    textStyle: const TextStyle(fontSize: 12),
                                  ),
                                  child: const Text('Add friend'),
                                  onPressed: () async {
                                    await addFriend(users[index].id);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserSearch extends SearchDelegate<User> {
  final List<User> users;

  UserSearch({required this.users});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, User as User);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
        users.where((user) => user.userName.contains(query)).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].userName),
          trailing: ElevatedButton(
            child: const Text('Add Friend'),
            onPressed: () {},
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        users.where((user) => user.firstName.contains(query)).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index].firstName),
          onTap: () {
            query = suggestions[index].firstName;
            showResults(context);
          },
        );
      },
    );
  }
}
