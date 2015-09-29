# This script compiles the static library for every architecture, creates a fat binary and puts
# it together with the public headers into a .framework file

set -e

FRAMEWORK="${BUILT_PRODUCTS_DIR}/${PROJECT_NAME}.framework"

# Recreate framework structure
rm -rf "${FRAMEWORK}"
mkdir -p "${FRAMEWORK}/Versions/A"

# Copy (public) headers into framework
# The -a ensures that the headers maintain the source modification date so that we don't constantly
# cause propagating rebuilds of files that import these headers.
cp -a "${BUILT_PRODUCTS_DIR}/include/${PROJECT_NAME}" "${FRAMEWORK}/Versions/A/Headers/"

# Compile for all architectures
xcodebuild -project "${PROJECT_FILE_PATH}" -configuration "Release" -sdk iphonesimulator -arch i386 clean build TARGET_BUILD_DIR="${BUILT_PRODUCTS_DIR}/build-i386"
xcodebuild -project "${PROJECT_FILE_PATH}" -configuration "Release" -sdk iphonesimulator -arch x86_64 clean build TARGET_BUILD_DIR="${BUILT_PRODUCTS_DIR}/build-x86_64"
xcodebuild -project "${PROJECT_FILE_PATH}" -configuration "Release" -sdk iphoneos -arch armv7 clean build TARGET_BUILD_DIR="${BUILT_PRODUCTS_DIR}/build-armv7"
xcodebuild -project "${PROJECT_FILE_PATH}" -configuration "Release" -sdk iphoneos -arch armv7s clean build TARGET_BUILD_DIR="${BUILT_PRODUCTS_DIR}/build-armv7s"
xcodebuild -project "${PROJECT_FILE_PATH}" -configuration "Release" -sdk iphoneos -arch arm64 clean build TARGET_BUILD_DIR="${BUILT_PRODUCTS_DIR}/build-arm64"

# Merge into fat binary
lipo -create -output "${BUILT_PRODUCTS_DIR}/lib${PROJECT_NAME}.a.fat" "${BUILT_PRODUCTS_DIR}/build-i386/lib${PROJECT_NAME}.a" "${BUILT_PRODUCTS_DIR}/build-x86_64/lib${PROJECT_NAME}.a" "${BUILT_PRODUCTS_DIR}/build-armv7/lib${PROJECT_NAME}.a" "${BUILT_PRODUCTS_DIR}/build-armv7s/lib${PROJECT_NAME}.a" "${BUILT_PRODUCTS_DIR}/build-arm64/lib${PROJECT_NAME}.a"

# Copy fat binary into framework
cp "${BUILT_PRODUCTS_DIR}/lib${PROJECT_NAME}.a.fat" "${FRAMEWORK}/Versions/A/${PROJECT_NAME}"

# Create "Current" links within framework
ln -s "A" "${FRAMEWORK}/Versions/Current"
ln -s "Versions/Current/Headers" "${FRAMEWORK}/Headers"
ln -s "Versions/Current/${PROJECT_NAME}" "${FRAMEWORK}/${PROJECT_NAME}"
