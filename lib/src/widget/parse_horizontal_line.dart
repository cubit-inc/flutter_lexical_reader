part of '../parser.dart';

class _ParseHorizontalLine extends StatelessWidget {
  const _ParseHorizontalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        color: Color(0xFFEBE7E5),
        thickness: 2,
      ),
    );
  }
}
