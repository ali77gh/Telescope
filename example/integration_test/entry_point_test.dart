import 'package:integration_test/integration_test.dart';

import './01.dart' as example01;
import './02.dart' as example02;
import './03.dart' as example03;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  example01.test();
  example02.test();
  example03.test();
}
