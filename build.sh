#!/bin/bash

# Exit script on any error
set -e

# 1. Clone Flutter SDK (Stable Channel)
echo "Cloning Flutter SDK..."
rm -rf /tmp/flutter # Remove existing directory if it exists

git clone https://github.com/flutter/flutter.git --depth 1 --branch stable /tmp/flutter
export PATH="/tmp/flutter/bin:$PATH"

# 2. Verify Flutter installation (Optional)
echo "Running flutter doctor..."
flutter doctor

# 3. Run the Flutter web build command
echo "Building Flutter web app..."
# It will use the HTML renderer because we set it in web/index.html
flutter build web --release



echo "Flutter web build complete."

rm -rf public # Remove existing public directory if it exists

# 4. Create the 'public' directory expected by Vercel and copy build output
echo "Preparing output for Vercel..."
mkdir public # Create the public directory
cp -r build/web/* public/ # Copy contents of build/web into public/

echo "Build script finished."