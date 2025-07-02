// Flutter screen fully ported from Kotlin Jetpack Compose RequestsScreen with all tabs and behavior
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class WalkRequest {
  final String walkerName;
  final double walkerRating;
  final String dogName;
  final String dogBreed;
  final String time;
  final DateTime date;
  final String location;

  WalkRequest(this.walkerName, this.walkerRating, this.dogName, this.dogBreed, this.time, this.date, this.location);
}

class RequestsScreen extends StatefulWidget {
  final bool isOwner;
  const RequestsScreen({super.key, this.isOwner = false});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.isOwner ? 3 : 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = widget.isOwner
        ? const ['Offers', 'Smart Picks', 'Schedule']
        : const ['My Requests', 'Premium AI Match'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests'),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: widget.isOwner
            ? [
          _StandardRequestTab(),
          _PremiumRequestTab(),
          _CreateRequestTab(),
        ]
            : [
          _RequestListTab(),
          _PremiumAiMatchTab(),
        ],
      ),
    );
  }
}

Widget _RequestListTab() {
  final List<WalkRequest> requests = [
    WalkRequest("Emily", 4.8, "Max", "Labrador Retriever", "2:00 PM", DateTime(2025, 5, 10), "Central Park, NY"),
    WalkRequest("Sarah", 4.2, "Luna", "Beagle", "11:00 AM", DateTime(2025, 5, 11), "Prospect Park, NY"),
    WalkRequest("Olivia", 4.7, "Bella", "Border Collie", "3:30 PM", DateTime(2025, 5, 12), "Brooklyn Heights, NY"),
  ];
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: requests.length,
    itemBuilder: (context, index) {
      final r = requests[index];
      final size = ['Small', 'Medium', 'Large'][index % 3];
      final walkType = ['Solo', 'Group'][index % 2];
      final weekly = r.dogName == 'Bella';
      final isBuddy = r.dogName == 'Max';

      return Card(
        color: isBuddy ? Colors.blue[50] : weekly ? Colors.purple[50] : Colors.white,
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${r.walkerName} (${r.walkerRating.toStringAsFixed(1)}★)", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${r.dogName} (${r.dogBreed})"),
              const SizedBox(height: 6),
              Text("📍 ${r.location}"),
              Text("📅 ${DateFormat('MMM d, yyyy').format(r.date)} at ${r.time}"),
              Text("Estimated Distance: 0.9 km • Duration: 45 mins"),
              const Divider(),
              Text("✏️ Size: $size    👣 Walk: $walkType"),
              if (isBuddy)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text("🐾 Already a Buddy", style: TextStyle(color: Colors.indigo)),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text("Accept")),
                  ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text("Deny")),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.message),
                    label: const Text("Message"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

Widget _PremiumAiMatchTab() {
  final WalkRequest suggestion = WalkRequest("Emma", 4.9, "Cooper", "Golden Retriever", "10:00 AM", DateTime(2025, 5, 15), "Greenwood Park");

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(8)),
          child: const Text("🔒 Premium Feature", style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 16),
        const Text("Personalized Matches", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.purple)),
        const SizedBox(height: 12),
        Row(children: [Expanded(child: Text("Start Date: Apr 15, 2025")), Expanded(child: Text("End Date: Apr 17, 2025"))]),
        Row(children: [Expanded(child: Text("Start Time: 08:00")), Expanded(child: Text("End Time: 18:00"))]),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: () {}, child: const Text("Rating (High to Low)")),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("${suggestion.walkerName} (${suggestion.walkerRating}★)"),
              Text("${suggestion.dogName} (${suggestion.dogBreed})"),
              Text("📍 ${suggestion.location}"),
              Text("📅 ${DateFormat('MMM d, yyyy').format(suggestion.date)} at ${suggestion.time}"),
              Text("Estimated Distance: 0.9 km • Duration: 45 mins"),
              const Divider(),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.green[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("🧠 Smart AI Insight", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    Text("Cooper is calm and obedient, ideal for group walks. This time slot aligns well with your 10AM park route — efficient and compatible."),
                    Text("🐾 Powered by behavior patterns, location proximity & walk success scores.", style: TextStyle(fontSize: 12, color: Colors.grey))
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text("✏️ Size: Small    👣 Walk: Group"),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: null, child: const Text("Accept")),
                  ElevatedButton(onPressed: null, child: const Text("Deny")),
                  ElevatedButton.icon(onPressed: null, icon: const Icon(Icons.message), label: const Text("Message")),
                ],
              )
            ]),
          ),
        )
      ],
    ),
  );
}

// Widget _StandardRequestTab() => Center(child: Text('StandardRequestTab — Show offers to owner'));
// Widget _PremiumRequestTab() => Center(child: Text('PremiumRequestTab — AI matches shown to owner'));
// Widget _CreateRequestTab() => Center(child: Text('CreateRequestTab — Form to create new request'));


Widget _StandardRequestTab() {
  final requests = [
    WalkRequest("Alex", 4.5, "Luna", "Golden Retriever", "2:00 PM", DateTime.now(), "Central Park"),
    WalkRequest("Sam", 4.3, "Luna", "Golden Retriever", "11:00 AM", DateTime.now(), "Prospect Park"),
  ];

  return ListView.builder(
    padding: const EdgeInsets.all(12),
    itemCount: requests.length,
    itemBuilder: (_, i) {
      final r = requests[i];
      final hasPastWalks = r.walkerName == "Alex";
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text("👤 ${r.walkerName}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                  Text("⭐ ${r.walkerRating}", style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 6),
              Text("📍 ${r.location}"),
              Text("🕒 ${r.time}"),
              Text("📅 ${DateFormat('MMM d, yyyy').format(r.date)}"),
              Text("🐶 ${r.dogName} (${r.dogBreed})"),
              const Text("⏱️ 30 min  •  👣 Solo Walk"),
              if (r.walkerName == "Alex")
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFE1BEE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("📆 Weekly Request • 3x/week", style: TextStyle(color: Color(0xFF6A1B9A), fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              if (hasPastWalks)
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFDCEDC8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("Already Walked Luna", style: TextStyle(color: Color(0xFF33691E), fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5E35B1)),
                onPressed: () {},
                child: const Text("Accept Walk", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      );
    },
  );
}

Widget _PremiumRequestTab() {
  final requests = [
    WalkRequest("Jamie", 4.9, "Luna", "Golden Retriever", "10:00 AM", DateTime.now(), "Hudson Trail"),
    WalkRequest("Taylor", 5.0, "Luna", "Golden Retriever", "4:00 PM", DateTime.now(), "Liberty Field"),
  ];

  return ListView.builder(
    padding: const EdgeInsets.all(12),
    itemCount: requests.length,
    itemBuilder: (_, i) {
      final r = requests[i];
      final hasPastWalks = r.walkerName == "Jamie";
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: const Color(0xFFE9DCEB),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text("✨ ${r.walkerName}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                  Text("⭐ ${r.walkerRating}", style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 6),
              Text("📍 ${r.location}"),
              Text("🕒 ${r.time}"),
              Text("📅 ${DateFormat('MMM d, yyyy').format(r.date)}"),
              Text("🐶 ${r.dogName} (${r.dogBreed})"),
              const Text("⏱️ 45 min  •  👣 Group Walk"),
              const SizedBox(height: 6),
              if (r.walkerName == "Jamie")
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFE1BEE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("📆 Weekly Request • 3x/week", style: TextStyle(color: Color(0xFF6A1B9A), fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              if (hasPastWalks)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFDCEDC8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("Already Walked Luna", style: TextStyle(color: Color(0xFF33691E), fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFAF97B2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("🔓 Premium AI Insight", style: TextStyle(color: Color(0xFF9C27B0), fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      r.walkerName.contains("Jamie")
                          ? "Jamie is ideal for calm morning group walks. Luna tends to behave best between 10–11AM."
                          : "Taylor adjusts walk intensity. Afternoon walks offer Luna structured exercise with recovery.",
                      style: const TextStyle(fontSize: 13),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF9C27B0)),
                child: const Text("Accept Premium Walk", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      );
    },
  );
}

Widget _CreateRequestTab() {
  return _CreateRequestForm();
}

class _CreateRequestForm extends StatefulWidget {
  const _CreateRequestForm({super.key});

  @override
  State<_CreateRequestForm> createState() => _CreateRequestFormState();
}

class _CreateRequestFormState extends State<_CreateRequestForm> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool asap = false;
  bool useKm = false;
  double duration = 30;
  String location = "Central Park";
  String walkType = "Solo";
  final days = ["M", "T", "W", "T", "F", "S", "S"];
  final selectedDays = <String>{};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 42,
              backgroundColor: const Color(0xFF9C27B0),
              child: const Icon(Icons.pets, size: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(DateFormat('EEE, MMM d, yyyy').format(selectedDate)),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => selectedDate = picked);
              }
            },
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null) {
                    setState(() => selectedTime = picked);
                  }
                },
                child: Text("Select Time: ${selectedTime.format(context)}"),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  Checkbox(value: asap, onChanged: (val) => setState(() => asap = val!)),
                  const Text("ASAP"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text("📍 Pickup Location"),
          TextField(
            controller: TextEditingController(text: location),
            onChanged: (val) => location = val,
            decoration: const InputDecoration(hintText: "Enter address or park"),
          ),
          const SizedBox(height: 16),
          const Text("⏱️ Duration Type"),
          Row(
            children: [
              ChoiceChip(
                label: const Text("Minutes"),
                selected: !useKm,
                onSelected: (_) => setState(() => useKm = false),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text("Kilometers"),
                selected: useKm,
                onSelected: (_) => setState(() => useKm = true),
              ),
            ],
          ),
          Slider(
            value: duration,
            min: useKm ? 0.5 : 10,
            max: useKm ? 5 : 90,
            divisions: useKm ? 9 : 8,
            label: useKm ? "${duration.toStringAsFixed(1)} km" : "${duration.round()} min",
            onChanged: (val) => setState(() => duration = val),
          ),
          const SizedBox(height: 16),
          const Text("👣 Walk Type"),
          Wrap(
            spacing: 12,
            children: ["Solo", "Group", "Both"].map((type) {
              return ChoiceChip(
                label: Text(type),
                selected: walkType == type,
                onSelected: (_) => setState(() => walkType = type),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text("🔁 Weekly Schedule"),
          Wrap(
            spacing: 6,
            children: days.map((day) {
              final selected = selectedDays.contains(day);
              return FilterChip(
                label: Text(day),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    if (selected) {
                      selectedDays.remove(day);
                    } else {
                      selectedDays.add(day);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Submit logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Submit Request", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

