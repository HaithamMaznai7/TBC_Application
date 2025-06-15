import 'package:flutter/material.dart';

class BaseSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Widget body;
  final bool flow;

  const BaseSectionCard({
    required this.title,
    required this.actions,
    required this.body,
    this.flow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: getBorder([
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: const TextStyle(color: Colors.white))),
                Row(
                  children: actions,
                ),
              ],
            ),
          ),
          body,
        ],
      ),
    );
  }

  Widget getBorder(List<Widget> children) {
    return flow 
    ? Stack(
      children: children.reversed.toList(),
    ) 
    : Column(
      children: children,
    );
  }
}
