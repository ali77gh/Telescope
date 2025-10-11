import 'package:flutter/widgets.dart';
import 'telescope.dart';

/// TelescopeBuilder: Similar to Consumer in Provider.
/// Rebuilds only the widget that depends on the Telescope's value.
/// Does not rebuild the entire page.
typedef TelescopeWidgetBuilder<T> = Widget Function(
    BuildContext context, T value);

class TelescopeBuilder<T> extends StatefulWidget {
  /// The Telescope instance to listen to
  final Telescope<T> telescope;

  /// Builder function that receives the current value of the Telescope
  final TelescopeWidgetBuilder<T> builder;

  const TelescopeBuilder({
    required this.telescope,
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  _TelescopeBuilderState<T> createState() => _TelescopeBuilderState<T>();
}

class _TelescopeBuilderState<T> extends State<TelescopeBuilder<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    // Initialize with the current Telescope value
    value = widget.telescope.value;
    // Add listener to update this widget when the value changes
    widget.telescope.addListener(_update);
  }

  /// Called when Telescope value changes
  void _update(T val) {
    if (mounted) setState(() => value = val);
  }

  @override
  void dispose() {
    // Remove listener when widget is disposed
    widget.telescope.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Call builder with the current value
    return widget.builder(context, value);
  }
}
