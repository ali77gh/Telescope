
echo "\n--- Unit tests ---"

flutter test
cd example

echo "\n--- Integration tests ---"

flutter test -d linux integration_test

