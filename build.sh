xcodebuild -target XamarinSoxBindings -sdk iphoneos
xcodebuild -target XamarinSoxBindings -sdk iphonesimulator -arch i386
mkdir universal
lipo -create -output universal/libXamarinSoxBindings.a build/Release-iphoneos/libXamarinSoxBindings.a build/Release-iphonesimulator/libXamarinSoxBindings.a
