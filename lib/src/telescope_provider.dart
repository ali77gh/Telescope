import 'package:flutter/widgets.dart';
import 'telescope.dart';
import 'telescope_builder.dart';

/// TelescopeProvider: Similar to Provider in Flutter.
/// Provides a set of Telescopes to the widget subtree.
class TelescopeProvider extends InheritedWidget {
  /// Map of telescopes with string keys
  final Map<String, Telescope> telescopes;

  const TelescopeProvider({
    Key? key,
    required this.telescopes,
    required Widget child,
  }) : super(key: key, child: child);

  /// Access the provider from the widget tree
  static TelescopeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TelescopeProvider>();
  }

  @override
  bool updateShouldNotify(TelescopeProvider oldWidget) =>
      telescopes != oldWidget.telescopes;
}

/// TelescopeSelector: Similar to Selector in Provider.
/// Rebuilds only the widget that listens to a specific Telescope.
class TelescopeSelector<T> extends StatelessWidget {
  /// Key of the Telescope in the provider
  final String keyName;

  /// Builder function to build the widget with the Telescope value
  final TelescopeWidgetBuilder<T> builder;

  const TelescopeSelector({
    required this.keyName,
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = TelescopeProvider.of(context);
    if (provider == null) throw "TelescopeProvider not found in widget tree";

    final telescope = provider.telescopes[keyName] as Telescope<T>;
    return TelescopeBuilder<T>(telescope: telescope, builder: builder);
  }
}
