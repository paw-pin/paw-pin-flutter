import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalkRequest {
  final String walkerName;
  final double rating;
  final String dogName;
  final String dogBreed;
  final String location;
  final DateTime date;
  final String? time;

  WalkRequest(this.walkerName, this.rating, this.dogName, this.dogBreed, this.location, this.date, [this.time]);
}

class WalksScreen extends StatefulWidget {
  final bool isOwner;
  const WalksScreen({super.key, this.isOwner = false});

  @override
  State<WalksScreen> createState() => _WalksScreenState();
}

class _WalksScreenState extends State<WalksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(text: 'Upcoming'),
    Tab(text: 'History'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isOwner ? 'Owner Walks' : 'Walker Walks'),
        bottom: TabBar(controller: _tabController, tabs: _tabs),
      ),
      body: TabBarView(
        controller: _tabController,
        children: widget.isOwner
            ? [OwnerUpcomingWalks(), OwnerHistoryWalks()]
            : [UpcomingWalksTab(), HistoryWalksTab()],
      ),
    );
  }
}

class UpcomingWalksTab extends StatelessWidget {
  final List<WalkRequest> requests = [
    WalkRequest('Emily', 4.8, 'Max', 'Labrador Retriever', 'Central Park, NY', DateTime.now().add(Duration(minutes: 30))),
    WalkRequest('Sarah', 4.2, 'Luna', 'Beagle', 'Prospect Park, NY', DateTime.now().add(Duration(minutes: 55))),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) => UpcomingWalkCard(request: requests[index]),
    );
  }
}

class UpcomingWalkCard extends StatelessWidget {
  final WalkRequest request;

  const UpcomingWalkCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final int minutesLeft = request.date.difference(DateTime.now()).inMinutes;
    final String formattedDate = DateFormat('MMM d, h:mm a').format(request.date);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${request.walkerName} (${request.dogName})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text('📍 ${request.location}'),
            Text('🕒 In $minutesLeft min'),
            Text('📅 $formattedDate'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text('Breed: Labrador Retriever')),
                Chip(label: Text('Sex: Male')),
                Chip(label: Text('Size: Medium')),
                Chip(label: Text('Walk: Group')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HistoryWalksTab extends StatelessWidget {
  final List<WalkRequest> mockHistory = [
    WalkRequest('Chris Canine', 4.6, 'Luna', 'Golden Retriever', 'Liberty Trail', DateTime.now().subtract(Duration(days: 2)), '2:00 PM'),
    WalkRequest('Taylor Paws', 4.8, 'Luna', 'Golden Retriever', 'Liberty Trail', DateTime.now().subtract(Duration(days: 3)), '10:30 AM')
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockHistory.length,
      itemBuilder: (context, index) {
        final walk = mockHistory[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✅ ${walk.walkerName} (${walk.dogName})', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('⭐ ${walk.rating} • ${DateFormat('MMM d').format(walk.date)} at ${walk.time} • ${walk.location}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: const [
                    Chip(label: Text('🐶 Golden Retriever')),
                    Chip(label: Text('👣 Solo Walk')),
                    Chip(label: Text('⏳ Requested: 45 min')),
                    Chip(label: Text('✅ Completed: 48 min')),
                    Chip(label: Text('📏 2.4 km')),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('📝 Summary:', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('Walk completed successfully. Your dog was happy and playful.')
              ],
            ),
          ),
        );
      },
    );
  }
}

class OwnerUpcomingWalks extends StatelessWidget {
  final List<WalkRequest> mockUpcoming = [
    WalkRequest('Urgent Dan', 4.5, 'Luna', 'Golden Retriever', 'Union Square', DateTime.now().add(Duration(minutes: 20)), 'Now'),
    WalkRequest('Alex Walker', 4.9, 'Luna', 'Golden Retriever', 'Central Park', DateTime.now().add(Duration(days: 1)), '3:00 PM'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockUpcoming.length,
      itemBuilder: (context, index) => UpcomingWalkCard(request: mockUpcoming[index]),
    );
  }
}

class OwnerHistoryWalks extends StatelessWidget {
  final List<WalkRequest> mockHistory = [
    WalkRequest('Chris Canine', 4.6, 'Luna', 'Golden Retriever', 'Liberty Trail', DateTime.now().subtract(Duration(days: 2)), '2:00 PM'),
    WalkRequest('Taylor Paws', 4.8, 'Luna', 'Golden Retriever', 'Liberty Trail', DateTime.now().subtract(Duration(days: 3)), '10:30 AM')
  ];

  @override
  Widget build(BuildContext context) {
    return HistoryWalksTab();
  }
}
