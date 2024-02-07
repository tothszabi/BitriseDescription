build:
	xcodebuild archive \
		-scheme BitriseDescription \
		-destination "generic/platform=macOS" \
		-archivePath ./output/BitriseDescription \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES

	xcodebuild -create-xcframework \
		-archive ./output/BitriseDescription.xcarchive \
		-framework BitriseDescription.framework \
		-output ./output/BitriseDescription.xcframework

	ditto -c -k --sequesterRsrc --keepParent ./output/BitriseDescription.xcframework output/BitriseDescription.xcframework.zip
