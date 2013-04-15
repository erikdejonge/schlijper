./uncrust.sh
xcodebuild -configuration  iphonesimulator3.0 clean
scan-build -k -V xcodebuild -configuration  iphonesimulator3