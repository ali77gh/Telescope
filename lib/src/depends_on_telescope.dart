
import 'telescope.dart';

class DependsOnTelescope<T>{
  DependsOnTelescope(this.observables, this.calculate);

  List<Telescope> observables;
  T Function() calculate;
}
