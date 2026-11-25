import 'package:flutter/material.dart';

class MessageView extends StatelessWidget {
  final IconData icon;
  final String pesan;
  final String? labelTombol;
  final VoidCallback? onTombol;

  const MessageView({
    Key? key,
    required this.icon,
    required this.pesan,
    this.labelTombol,
    this.onTombol,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64.0, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16.0),
            Text(
              pesan,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (labelTombol != null && onTombol != null) ...[
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: onTombol,
                child: Text(labelTombol!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}