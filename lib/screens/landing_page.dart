import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final void Function(bool isOwner) onSelect;

  const LandingPage({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF9C27B0), width: 3),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(16),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/logo.png'), // <- update path if needed
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Your dog, our care",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9C27B0),
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => onSelect(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0x00000000),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Enter as Dog Walker"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => onSelect(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0x00000000),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Enter as Dog Owner"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
