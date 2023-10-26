import 'dart:convert';
import 'package:nielts/screens/profile/screen.dart';
import 'package:nielts/screens/users/screen.dart';
import 'package:flutter/material.dart';
import 'package:nielts/components/bar.dart';
import 'package:nielts/constants/urls.dart';
import 'package:nielts/context/token_service.dart';
import 'package:http/http.dart' as http;

class FriendsBlock extends StatelessWidget {
  const FriendsBlock({super.key});

  Future<Map<String, dynamic>> viewProfile(int userId) async {
    final String? access = await TokenService().getAccessToken();
    final response = await http.get(
      Uri.parse(profileRef + userId.toString()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Error viewing profile.');
      return {};
    }
  }

  Future<List<Friend>> listFriends() async {
    final String? access = await TokenService().getAccessToken();
    final response = await http.get(
      Uri.parse(friendListRef),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseBody = json.decode(response.body);
      return responseBody.map((item) {
        var friendData = item['friend'];
        return Friend(
          firstName: friendData['first_name'] ?? "Unknown",
          lastName: friendData['last_name'] ?? "Unknown",
          avatar: "assets/profile_image.jpg",
          id: friendData['id'],
        );
      }).toList();
    } else {
      print('Error fetching friends list: ${response.body}');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Friends",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 15),
          const Bar(),
          FutureBuilder<List<Friend>>(
            future: listFriends(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllUsersScreen()),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/add-friend-img.png',
                          width: 45,
                          height: 45,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Add Friend',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                );
              } else {
                List<Friend> friends = snapshot.data!;
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: friends.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return const Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 20),
                          child: AddFriendBlock(),
                        );
                      } else {
                        Friend friend = friends[index - 1];
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.016,
                              15,
                              0,
                              20),
                          child: FriendBlock(friend: friend),
                        );
                      }
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class Friend {
  final int id;
  final String firstName;
  final String lastName;
  final String avatar;

  Friend(
      {required this.firstName,
      required this.lastName,
      required this.avatar,
      required this.id});
}

class AddFriendBlock extends StatelessWidget {
  const AddFriendBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.21,
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff71C309),
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Material(child: AllUsersScreen())),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/add-friend-img.png',
                width: 45,
                height: 45,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Add Friend',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class FriendBlock extends StatelessWidget {
  final Friend friend;

  const FriendBlock({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Material(child: ProfileScreen(userId: friend.id))),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.21,
        padding: const EdgeInsets.fromLTRB(5, 15, 5, 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xff71C309),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                friend.avatar,
                width: 45,
                height: 45,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              friend.firstName,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              friend.lastName,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
