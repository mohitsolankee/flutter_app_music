echo 'Cleaning...'
flutter clean
echo 'All clear'

echo 'Fetching packages..⏳'
flutter pub get
echo 'Fetching packages COMPLETE ✅'

echo 'Code Auto-Gen with build_runner..⏳'
flutter pub run build_runner build --delete-conflicting-outputs
echo 'Code Auto-Gen with build_runner COMPLETE ✅'


  