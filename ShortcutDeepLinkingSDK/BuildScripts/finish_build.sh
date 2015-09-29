# This script copies all files that will be distributed into the project dir

set -e

FRAMEWORK="${BUILT_PRODUCTS_DIR}/${PROJECT_NAME}.framework"

rm -rf "${PROJECT_DIR}/build"
mkdir -p "${PROJECT_DIR}/build"

cp -R "${FRAMEWORK}" "${PROJECT_DIR}/build/"

cp "${PROJECT_DIR}/README.md" "${PROJECT_DIR}/build/"
cp "${PROJECT_DIR}/LICENSE.txt" "${PROJECT_DIR}/build/"

open "${PROJECT_DIR}/build"
