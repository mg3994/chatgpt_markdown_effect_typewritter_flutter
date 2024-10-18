

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TypewriterMarkdownDifference extends StatefulWidget {
  @override
  _TypewriterMarkdownDifferenceState createState() =>
      _TypewriterMarkdownDifferenceState();
}

class _TypewriterMarkdownDifferenceState
    extends State<TypewriterMarkdownDifference>
    with SingleTickerProviderStateMixin {
  final List<String> markdownVersions = [
    "## Problem\nThis is the main issue with what",
    "## Problem\nThis is the main issue with what we're trying to solve.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production. As a result, customer satisfaction has dropped significantly.",
  ];

  late AnimationController _controller;
  late Animation<int> _characterCountAnimation;

  String previousText = "";
  String currentText = "";
  String newText = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Speed of typewriter effect
      vsync: this,
    );

    // Initialize text and animation for the first version
    _updateText(0);
  }

  void _updateText(int versionIndex) {
    if (versionIndex < 0 || versionIndex >= markdownVersions.length) return;

    setState(() {
      previousText = versionIndex > 0 ? markdownVersions[versionIndex - 1] : "";
      currentText = markdownVersions[versionIndex];
      newText = _findNewText(previousText, currentText);

      // Reinitialize animation based on the new text length
      _characterCountAnimation = StepTween(
        begin: 0,
        end: newText.length,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ),
      );

      // Reset and start the animation
      _controller.reset();
      _controller.forward();
    });
  }

  // Compare previous and current text to return the newly added portion
  String _findNewText(String oldText, String newText) {
    if (oldText == newText) return "";
    return newText.substring(oldText.length); // Get new text after old text
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Typewriter Markdown Difference Effect"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _characterCountAnimation,
                builder: (context, child) {
                  // Extract the part of the new text that's visible based on animation
                  String visibleText = newText.isNotEmpty
                      ? newText.substring(0, _characterCountAnimation.value)
                      : "";

                  // Combine the old static markdown and the animated new markdown
                  String fullMarkdown = previousText + visibleText;

                  return MarkdownBody(
                    data: fullMarkdown,
                    styleSheet: MarkdownStyleSheet(
                      h2: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      p: const TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Move to the next version and restart the animation
                int nextIndex = (markdownVersions.indexOf(currentText) + 1) % markdownVersions.length;
                _updateText(nextIndex);
              },
              child: const Text("Next Version"),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: TypewriterMarkdownDifference(),
    ));
