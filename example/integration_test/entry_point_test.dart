import 'package:integration_test/integration_test.dart';

import './example_01.dart' as example01;
import './example_02.dart' as example02;
import './example_03.dart' as example03;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  example01.test();
  example02.test();
  example03.test();
}
