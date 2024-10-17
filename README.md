# chatgpt_markdown_effect_typewritter_flutter
No i am doing experiment around this don't check it 
```dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TypewriterMarkdownDifference extends StatefulWidget {
  @override
  _TypewriterMarkdownDifferenceState createState() =>
      _TypewriterMarkdownDifferenceState();
}

class _TypewriterMarkdownDifferenceState
    extends State<TypewriterMarkdownDifference> with SingleTickerProviderStateMixin {
  final List<String> markdownVersions = [
    "## Problem\nThis is the main issue with what",
    "## Problem\nThis is the main issue with what we're trying to solve.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production.",
    "## Problem\nThis is the main issue with what we're trying to solve. The current solution is insufficient for handling edge cases, and it leads to frequent breakdowns in production. As a result, customer satisfaction has dropped significantly.",
  ];

  AnimationController? _controller;
  Animation<int>? _characterCountAnimation;

  String previousText = "";
  String currentText = "";
  String newText = "";

  @override
  void initState() {
    super.initState();
    _updateText(4); // Start with the last version

    _controller = AnimationController(
      duration: Duration(seconds: 2), // Speed of typewriter effect
      vsync: this,
    );

    // Animation to reveal characters one by one in the new text
    _characterCountAnimation = StepTween(begin: 0, end: newText.length)
        .animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    ));

    _controller!.forward();
  }

  void _updateText(int versionIndex) {
    setState(() {
      if (versionIndex > 0 && versionIndex < markdownVersions.length) {
        previousText = markdownVersions[versionIndex - 1];
        currentText = markdownVersions[versionIndex];
        newText = _findNewText(previousText, currentText);
      }
    });
  }

  // Compare previous and current text to return the newly added portion
  String _findNewText(String oldText, String newText) {
    if (oldText == newText) return "";
    int startIndex = oldText.length;
    return newText.substring(startIndex);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Typewriter Markdown Difference Effect"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _characterCountAnimation!,
                builder: (context, child) {
                  // Extract the part of the new text that's visible based on animation
                  String visibleText = newText.substring(
                      0, _characterCountAnimation!.value); // Animated text

                  // Combine the old static markdown and the animated new markdown
                  String fullMarkdown = previousText + visibleText;

                  return MarkdownBody(
                    data: fullMarkdown,
                    styleSheet: MarkdownStyleSheet(
                      h2: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      p: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Move to the next version and restart the animation
                int nextIndex = (markdownVersions.indexOf(currentText) + 1) %
                    markdownVersions.length;
                _updateText(nextIndex);
                _controller?.reset();
                _controller?.forward();
              },
              child: Text("Next Version"),
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

```
