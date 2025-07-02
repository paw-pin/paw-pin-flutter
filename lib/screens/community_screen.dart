// Flutter equivalent of CommunityScreen.kt (with tabs: Events, Deals, Blog)

import 'package:flutter/material.dart';

class Event {
  final String title, date, location, speaker, description, duration;
  Event(this.title, this.date, this.location, this.speaker, this.description, this.duration);
}

class BlogPost {
  final String title, author, excerpt, content;
  BlogPost(this.title, this.author, this.excerpt, this.content);
}

class BlogCategory {
  final String title;
  final List<BlogPost> posts;
  BlogCategory(this.title, this.posts);
}

class CommunityScreen extends StatefulWidget {
  final bool isOwner;
  const CommunityScreen({super.key, this.isOwner = false});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: widget.isOwner ? 2 : 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = widget.isOwner ? ["🎉 Events", "🟣 Deals"] : ["🎉 Events", "📚 Blog"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
        bottom: TabBar(
          controller: tabController,
          tabs: tabs.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: widget.isOwner
            ? [ownerEventsTab(), specialDealsTab()]
            : [eventsTab(), blogTab()],
      ),
    );
  }

  Widget eventsTab() {
    final events = [
      Event("Dog Nutrition Deep Dive", "July 22, 2025", "Online", "Dr. Woofstein", "Exclusive feeding guide.", "1h 15min"),
      Event("Premium Giveaway: Free Walks", "Aug 5", "Members Only", "Team PawPin", "Win free walks.", "Instant Entry"),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (_, i) {
        final e = events[i];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: e.title.contains("Premium") ? const Color(0xFFF3E5F5) : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("📅 ${e.date} ⏱ ${e.duration}"),
                Text("📍 ${e.location}"),
                Text("🎤 ${e.speaker}"),
                const SizedBox(height: 8),
                Text(e.description),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: e.duration == "Instant Entry" ? null : () {}, child: const Text("RSVP"))
              ],
            ),
          ),
        );
      },
    );
  }

  Widget ownerEventsTab() {
    final events = [
      Event("Dog Nutrition Deep Dive", "July 22, 2025", "Online", "Dr. Woofstein", "Exclusive breakdown of feeding strategies + free PDF guide.", "1h 15min"),
      Event("Premium Giveaway: Year of Free Walks", "August 5, 2025", "Members Only", "Team PawPin", "Enter to win a full year of free dog walks. Premium users only!", "Instant Entry"),
      Event("How to Communicate with Dog Owners", "June 20, 2025", "Online Webinar", "Jane Walker", "Practical guidance on improving communication with clients.", "1h 30min"),
      Event("Safety Protocols During Walks", "July 5, 2025", "Central Park, NY", "Dr. Emily Canine", "Learn emergency responses and leash safety standards.", "2h"),
      Event("Advanced Dog Handling Tips", "August 12, 2025", "SoHo Club, NY", "Marko Tails", "Pro strategies for handling excited or aggressive dogs.", "1h 45min"),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (_, i) {
        final e = events[i];
        final isPremium = e.title.contains("Premium") || e.title.contains("Giveaway");

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: isPremium ? const Color(0xFFF3E5F5) : const Color(0xFFF5F5F5),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (isPremium)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFF9C27B0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text("Premium", style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                const SizedBox(height: 6),
                Text("📅 ${e.date}    ⏱ ${e.duration}"),
                Text("📍 ${e.location}"),
                Text("🎤 Speaker: ${e.speaker}"),
                const SizedBox(height: 8),
                Text(e.description),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: e.duration == "Instant Entry" ? null : () {},
                  child: const Text("RSVP"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget specialDealsTab() {
    final deals = [
      "🎁 2 Free Grooming Coupons at Bark & Bubbles",
      "🦴 15% off Premium Treats at DoggoMart",
      "🏥 Free Initial Checkup at PetCare Vet Center",
      "🎒 Free Walk Bag from PupPacks with Premium Signup",
    ];

    return Container(
      color: const Color(0xFFF8EAF6),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
            decoration: BoxDecoration(
              color: Color(0xFF9C27B0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              "Premium Partner Deals",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: deals.length,
              itemBuilder: (_, i) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(deals[i], style: const TextStyle(fontWeight: FontWeight.w600)),
                        const Text("Available exclusively for Premium members", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9C27B0)),
                          child: const Text("Collect Deal", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget blogTab() {
    final categories = [
      BlogCategory("Training Advice", [
        BlogPost("How to Train", "Sarah", "Tips on heel behavior...", "Use rewards, stay consistent..."),
        BlogPost("Positive Reinforcement", "Dan", "Treat-based reward tips...", "Avoid punishment, reward good behavior...")
      ]),
      BlogCategory("Health", [
        BlogPost("Hydration Tips", "Vet Emily", "In summer...", "Carry water, avoid hot hours..."),
        BlogPost("Paw Care 101", "PawPin", "Prevent cracks, dry paws...", "Trim nails, use balm, inspect after walks.")
      ])
    ];

    return DefaultTabController(
      length: categories.length + 1,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: [const Tab(text: "All"), ...categories.map((c) => Tab(text: c.title))],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildBlogList(categories.expand((c) => c.posts).toList()),
                ...categories.map((c) => _buildBlogList(c.posts)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBlogList(List<BlogPost> posts) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (_, i) {
        final p = posts[i];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 10),
          color: const Color(0xFFFDFDFD),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold))),
                    Text("💬 ${5 + (i * 3) % 10}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Text("✍️ ${p.author}", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 6),
                Text(p.excerpt, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("...Read more ▼", style: TextStyle(color: Colors.deepPurple, fontSize: 12)),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        textStyle: const TextStyle(fontSize: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text("Open Blog"),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}