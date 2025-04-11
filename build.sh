#!/bin/bash

# Exit script on any error
set -e

# Run the Flutter web build command
# It will use the HTML renderer because we set it in web/index.html
flutter build web --release

echo "Flutter web build complete."