import 'package:flutter/material.dart';

import '../../globals/color.dart';

class HumorForm extends StatefulWidget {
  const HumorForm({super.key});

  @override
  State<HumorForm> createState() => _HumorFormState();
}

class _HumorFormState extends State<HumorForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          "O que estou Sentindo",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: cor,
      ),
    );
  }
}
