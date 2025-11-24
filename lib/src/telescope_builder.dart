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
  late int telescopeDisposeId;

  @override
  void initState() {
    super.initState();
    telescopeDisposeId = widget.telescope.subscribe(() => setState(() {}));
  }

  @override
  void dispose() {
    // Remove listener when widget is disposed
    widget.telescope.removeListener(telescopeDisposeId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: invalid_use_of_protected_member
    return widget.builder(context, widget.telescope.holden);
  }
}
