import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Color Scheme', type: Widget)
Widget buildColorSchemeUseCase(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final Map<String, Color> colorMap = {
    'primary': colorScheme.primary,
    'onPrimary': colorScheme.onPrimary,
    'primaryContainer': colorScheme.primaryContainer,
    'onPrimaryContainer': colorScheme.onPrimaryContainer,
    'secondary': colorScheme.secondary,
    'onSecondary': colorScheme.onSecondary,
    'secondaryContainer': colorScheme.secondaryContainer,
    'onSecondaryContainer': colorScheme.onSecondaryContainer,
    'tertiary': colorScheme.tertiary,
    'onTertiary': colorScheme.onTertiary,
    'tertiaryContainer': colorScheme.tertiaryContainer,
    'onTertiaryContainer': colorScheme.onTertiaryContainer,
    'error': colorScheme.error,
    'onError': colorScheme.onError,
    'errorContainer': colorScheme.errorContainer,
    'onErrorContainer': colorScheme.onErrorContainer,
    'surface': colorScheme.surface,
    'onSurface': colorScheme.onSurface,
    'surfaceVariant': colorScheme.surfaceContainer,
    'outline': colorScheme.outline,
    'outlineVariant': colorScheme.outlineVariant,
    'shadow': colorScheme.shadow,
    'scrim': colorScheme.scrim,
    'inverseSurface': colorScheme.inverseSurface,
    'onInverseSurface': colorScheme.onInverseSurface,
    'inversePrimary': colorScheme.inversePrimary,
    'surfaceTint': colorScheme.surfaceTint,
  };

  return ListView.builder(
    itemCount: colorMap.length,
    itemBuilder: (context, index) {
      final entry = colorMap.entries.elementAt(index);
      return Container(
        color: entry.value,
        child: ListTile(
          title: Text(entry.key),
          subtitle: Text(entry.value.toString()),
        ),
      );
    },
  );
}
