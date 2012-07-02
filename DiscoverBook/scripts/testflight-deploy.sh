#!/bin/bash

# create ipa
xcrun -sdk iphoneos \
PackageApplication \
-v "${ARCHIVE_PRODUCTS_PATH}/Applications/${FULL_PRODUCT_NAME}" \
-o "${ARCHIVE_PATH}/../${PRODUCT_NAME}.ipa" \
--sign "${MOBILEPROVISION_DEVELOPER_NAME}" \
--embed "${MOBILEPROVISION_FILE}"

cd "${ARCHIVE_PATH}/dSYMs"; rm -f "${FULL_PRODUCT_NAME}.dSYM.zip"; zip -r "${FULL_PRODUCT_NAME}.dSYM.zip" "${FULL_PRODUCT_NAME}.dSYM"; cd -

xcodebuild -scheme DiscoverBook -configuration Release

xcrun -sdk iphoneos PackageApplication \
 -v "/Users/twer/Library/Developer/Xcode/DerivedData/DiscoverBook-aiahaxzqwiflyyhfnmxuokqnglbb/Build/Products/Release-iphoneos/DiscoverBook.app" \
 -o "/Users/twer/Code/objective-c/DiscoverBook/DiscoverBook.ipa" \
 --sign c1320e20bc25d19ce7bb74adaf4f64a4e2619b3f \
 --embed "/Users/twer/Code/objective-c/DiscoverBook/DiscoverBook/scripts/84920B61-1329-41BF-A85D-C8864A5B43EC.mobileprovision"

curl 'http://testflightapp.com/api/builds.json' \
-F file="@/Users/twer/Code/objective-c/DiscoverBook/DiscoverBook.ipa" \
-F dsym="@/Users/twer/Code/objective-c/DiscoverBook/DiscoverBook.app.dSYM.zip" \
-F api_token="d19e50be4b0826eec4d440cec38d9aa5_MjE4MjU0MjAxMS0xMS0xNSAxODowMDo0MC44MzY2MDI" \
-F team_token="9fdd4ffe966bdba0fa4d8191c7bb2452_MTA1MTg4MjAxMi0wNi0yOSAwMToxNTo1MS43NTIyNjI" \
-F notes='This build was uploaded via the upload API' \
-F notify=True \
-F distribution_lists='Developers' -v
