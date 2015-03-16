xcodebuild -target XamarinSoxBindings -sdk iphoneos8.2  
xcodebuild -target XamarinSoxBindings -sdk iphonesimulator -arch i386
lipo -create -output universal/libXamarinSoxBindings.a build/Release-iphoneos/libXamarinSoxBindings.a build/Release-iphonesimulator/libXamarinSoxBindings.a
