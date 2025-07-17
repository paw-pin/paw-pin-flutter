// Flutter version of CombinedProfileScreen replicating Kotlin layout and logic

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class CombinedProfileScreen extends StatefulWidget {
  final bool isOwner;

  const CombinedProfileScreen({super.key, this.isOwner = false});

  @override
  State<CombinedProfileScreen> createState() => _CombinedProfileScreenState();
}

class _CombinedProfileScreenState extends State<CombinedProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.isOwner ? 3 : 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = widget.isOwner
        ? const ['General', 'Inbox', 'Friends']
        : const ['General', 'Ratings', 'Inbox', 'Friends'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: widget.isOwner
            ? [
                const OwnerProfileTab(),
                const OwnerMessagesTab(),
                const OwnerFriendsTab(),
              ]
            : [
                const WalkerProfileTab(),
                const RatingsTab(),
                const MessagesTab(),
                const FriendsTab(),
              ],
      ),
    );
  }
}

class OwnerProfileTab extends StatefulWidget {
  const OwnerProfileTab({super.key});

  @override
  State<OwnerProfileTab> createState() => _OwnerProfileTabState();
}

class _OwnerProfileTabState extends State<OwnerProfileTab> {
  String dogName = "Kiflica";
  String dogBreed = "Chow Chow";
  String dogSize = "Large";
  String walkType = "Solo";
  String avgDistance = "2km";
  String avgDuration = "35min";

  bool isLoading = false;

  void fetchTips() async {
    setState(() => isLoading = true);

    final prompt =
        "dog: $dogBreed, name: $dogName, age: 2 years, avarage distance walked: $avgDistance, avarage time walking: $avgDuration.";

    //final uri = Uri.parse('http://localhost:8080/claude?prompt=${Uri.encodeComponent(prompt)}');
    final uri = Uri.parse(
      'http://10.0.2.2:8080/llm?prompt=${Uri.encodeComponent(prompt)}',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("AI Tips for $dogName"),
            content: SizedBox(
              height: 400,
              width: 300,
              child: Scrollbar(
                child: Markdown(
                  data: response.body,
                  selectable: true,
                  shrinkWrap: true,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                      .copyWith(
                        p: const TextStyle(fontSize: 14),
                        h1: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        h2: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        h3: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      } else {
        showError("Error ${response.statusCode}");
      }
    } catch (e) {
      showError(e.toString());
    }

    setState(() => isLoading = false);
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CircleAvatar(radius: 75, backgroundColor: Colors.grey[300]),
        const SizedBox(height: 12),
        const Text(
          "John Doe",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        const Text("john.doe@example.com", style: TextStyle(fontSize: 14)),
        const Divider(height: 22),
        ElevatedButton.icon(
          onPressed: isLoading ? null : fetchTips,
          icon: const Icon(Icons.auto_awesome, color: Colors.white),
          label: Text(isLoading ? "Loading..." : "Get Tips (AI)", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => context.go('/'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Logout", style: TextStyle(color: Colors.white)),
        ),
        const Divider(height: 32),
        ProfileInfoItem("Dog Name", dogName),
        ProfileInfoItem("Dog Breed", dogBreed),
        ProfileInfoItem("Dog Size", dogSize),
        ProfileInfoItem("Walk Type", walkType),
        ProfileInfoItem("Average Distance Walked", avgDistance),
        ProfileInfoItem("Average Walk Duration", avgDuration)
      ],
    );
  }
}

// class OwnerProfileTab extends StatelessWidget {
//   const OwnerProfileTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         CircleAvatar(radius: 75, backgroundColor: Colors.grey[300]),
//         const SizedBox(height: 12),
//         const Text("John Doe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
//         const Text("john.doe@example.com", style: TextStyle(fontSize: 14)),
//         const Divider(height: 32),
//         ElevatedButton(
//           onPressed: () {context.go('/');},
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//           child: const Text("Logout", style: TextStyle(color: Colors.white)),
//         ),
//         const Divider(height: 32),
//         const ProfileInfoItem("Member Since", "📅 January 2023"),
//         const ProfileInfoItem("Dog Name", "🐶 Luna"),
//         const ProfileInfoItem("Walks Completed", "👟 128"),
//         const ProfileInfoItem("Average Rating", "⭐ 4.9"),
//         const ProfileInfoItem("Average Distance Walked", "3.1 km"),
//         const ProfileInfoItem("Average Walk Duration", "35 min"),
//         const EditableProfileInfoItem("Walk Type", "Solo"),
//         const EditableProfileInfoItem("Dog Breed", "Golden Retriever"),
//         const EditableProfileInfoItem("Dog Size", "Large"),
//         const SizedBox(height: 24)
//       ],
//     );
//   }
// }

class WalkerProfileTab extends StatelessWidget {
  const WalkerProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CircleAvatar(radius: 75, backgroundColor: Colors.grey[300]),
        const SizedBox(height: 12),
        const Text(
          "John Doe",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        const Text("john.doe@example.com", style: TextStyle(fontSize: 14)),
        const Divider(height: 32),
        ElevatedButton(
          onPressed: () {
            context.go('/');
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Logout", style: TextStyle(color: Colors.white)),
        ),
        const Divider(height: 32),
        const ProfileInfoItem("Member Since", "📅 January 2023"),
        const ProfileInfoItem("Walks Completed", "👟 128"),
        const ProfileInfoItem("Average Rating", "⭐ 4.8"),
        const EditableProfileInfoItem(
          "Preferred Dog Breeds",
          "Labrador, Beagle, Poodle",
        ),
        const EditableProfileInfoItem("Preferred Breed Sizes", "Medium"),
        const EditableProfileInfoItem("Preferred Walk Type", "Group Walks"),
        const EditableProfileInfoItem("Recurring Walks with Clients", "Yes"),
        const SizedBox(height: 24),
      ],
    );
  }
}

class RatingsTab extends StatelessWidget {
  const RatingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ratings = List.generate(6, (index) => index);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ratings.length,
      itemBuilder: (context, index) {
        final rating = index;
        final ratedBack = index % 2 == 0;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "👤 Walker $index (Breed)",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Booked: ${30 + index * 2} min | Walked: ${30 + index * 2 + Random().nextInt(3)} min",
                ),
                const Text("★★★★☆"),
                const Text("Great job!"),
                if (ratedBack)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    color: Colors.green[100],
                    child: const Text(
                      "📝 You rated back: ★★★★☆\nVery friendly dog",
                    ),
                  )
                else
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    color: Colors.yellow[100],
                    child: const Text("🖊️ Rate Back"),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      ("Alice", "Luna", "Thanks for today!", true),
      ("Bob", "Rex", "Was the walk fine?", false),
      ("Charlie", "Bella", "Appreciate the effort!", true),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final (from, dog, text, isRead) = messages[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          color: isRead ? Colors.white : Colors.orange[100],
          child: ListTile(
            title: Text("📨 $from ($dog)"),
            subtitle: Text(text),
            trailing: isRead
                ? const Icon(Icons.check, color: Colors.green)
                : const Icon(Icons.mark_email_unread),
          ),
        );
      },
    );
  }
}

class FriendsTab extends StatelessWidget {
  const FriendsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final friends = [
      ("Alice Smith", "Luna", 4.8, "+123456789"),
      ("Bob Johnson", "Rex", 4.6, "+198765432"),
      ("Charlie White", "Bella", 5.0, "+102938475"),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final (name, dogName, rating, phone) = friends[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$name & 🐶 $dogName",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text("⭐ $rating"),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat, size: 16),
                      label: const Text("Text"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person, size: 16),
                      label: const Text("Profile"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class OwnerHeader extends StatelessWidget {
//   const OwnerHeader({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text("Owner General Info"));
//   }
// }

class OwnerMessagesTab extends StatelessWidget {
  const OwnerMessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const MessagesTab();
  }
}

class OwnerFriendsTab extends StatelessWidget {
  const OwnerFriendsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const FriendsTab();
  }
}

class ProfileInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoItem(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class EditableProfileInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const EditableProfileInfoItem(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.grey)),
      subtitle: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.edit),
      onTap: () {},
    );
  }
}
