#!/bin/bash

# Exit script on any error
set -e

# 1. Clone Flutter SDK (Stable Channel)
echo "Cloning Flutter SDK..."
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

# 4. Copy build output to Vercel's expected directory (usually 'public' or root)
# Vercel often expects output in the root or a 'public' folder.
# Since our output is in 'build/web', we copy it to the root for Vercel to find.
# Adjust if Vercel expects a different output location based on project settings.
echo "Copying build output..."
cp -r build/web/* . 

echo "Build script finished."