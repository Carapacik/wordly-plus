import 'package:flutter/material.dart';

class const ListItemSelector<T>({
  required final String title,
  required final (T, String) currentValue,
  required final List<(T, String)> items,
  required final ValueChanged<T> onChange,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: ListTileTheme.merge(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: Text(currentValue.$2, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        onTap: () async {
          final T? selected = await _selectLanguageBottomSheet(context);
          if (selected == null) {
            return;
          }
          onChange.call(selected);
        },
      ),
    ),
  );

  Future<T?> _selectLanguageBottomSheet(BuildContext context) => showModalBottomSheet<T>(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
    constraints: const BoxConstraints(maxWidth: 400),
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => ListTile(
              title: Text(items[index].$2),
              trailing: currentValue.$1 == items[index].$1 ? const Icon(Icons.check) : null,
              onTap: () => Navigator.of(context).pop(items[index].$1),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    ),
  );
}
