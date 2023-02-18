
import 'telescope.dart';

class DependsOnTelescope<T>{
  DependsOnTelescope(this.observables, this.calculate);

  late List<Telescope> observables;
  late T Function() calculate;
}
