import 'package:flutter/material.dart';
import '../../../data/models/character.dart';
import '../../../core/utils/date_formatter.dart';

class CharacterDetailModal extends StatelessWidget {
  final Character character;

  const CharacterDetailModal({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: cs.primary.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.primary.withOpacity(0.1),
              border:
                  Border.all(color: cs.primary.withOpacity(0.4), width: 1.5),
            ),
            child: Icon(Icons.person, color: cs.primary, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            character.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: cs.primary,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Divider(color: cs.primary.withOpacity(0.2)),
          const SizedBox(height: 12),
          _InfoRow(
              label: 'Height',
              value: character.heightInMeters,
              icon: Icons.height),
          _InfoRow(
              label: 'Mass',
              value: character.massInKg,
              icon: Icons.monitor_weight_outlined),
          _InfoRow(
              label: 'Birth year',
              value: character.birthYear,
              icon: Icons.cake_outlined),
          _InfoRow(
              label: 'Added to API',
              value: DateFormatter.format(character.created),
              icon: Icons.calendar_today_outlined),
          _InfoRow(
              label: 'Films',
              value:
                  '${character.films.length} film${character.films.length == 1 ? '' : 's'}',
              icon: Icons.movie_outlined),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: cs.primary.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: cs.primary.withOpacity(0.3)),
                ),
              ),
              child: Text('Close',
                  style: TextStyle(
                      color: cs.primary, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, size: 18, color: cs.primary.withOpacity(0.7)),
          const SizedBox(width: 12),
          Text(label,
              style:
                  TextStyle(color: cs.onSurface.withOpacity(0.55), fontSize: 14)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
