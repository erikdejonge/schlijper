./uncrust.sh
xcodebuild -configuration  iphonesimulator2.2.1 clean
scan-build -k -V xcodebuild -configuration  iphonesimulator2.2.1