
#!/bin/bash
set -x

curl -L -O https://github.com/google/bundletool/releases/download/0.10.2/bundletool-all-0.10.2.jar
APK_SIZE=`du -hs $BITRISE_APK_PATH`
BUNDLE_SIZE=`du -hs $BITRISE_AAB_PATH`
echo $BUNDLE_SIZE
echo $APK_SIZE
java -jar bundletool-all-0.10.2.jar build-apks --bundle=$BITRISE_AAB_PATH --output=app.apks
SIZES_RAW=`java -jar bundletool-all-0.10.2.jar get-size total --apks=app.apks|python3 -c 'import sys;print(sys.stdin.read().split("\r\n")[1])'`
SIZES_IN_MB=`echo $SIZES_RAW|python3 -c 'import sys;print(", ".join(["{:0.2f}mb".format(int(x)/1024.0/1024.0) for x in sys.stdin.read().split(",")]))'`
echo $SIZES_RAW | envman add --key GENERATED_APKS_MINMAX_RAW
echo $SIZES_IN_MB | envman add --key GENERATED_APKS_MINMAX
echo $BUNDLE_SIZE | envman add --key GENERATED_BUNDLE_SIZE

#
# --- Export Environment Variables for other Steps:
# You can export Environment Variables for other Steps with
#  envman, which is automatically installed by `bitrise setup`.
# A very simple example:
# envman add --key EXAMPLE_STEP_OUTPUT --value 'the value you want to share'
# Envman can handle piped inputs, which is useful if the text you want to
# share is complex and you don't want to deal with proper bash escaping:
#  cat file_with_complex_input | envman add --KEY EXAMPLE_STEP_OUTPUT
# You can find more usage examples on envman's GitHub page
#  at: https://github.com/bitrise-io/envman

#
# --- Exit codes:
# The exit code of your Step is very important. If you return
#  with a 0 exit code `bitrise` will register your Step as "successful".
# Any non zero exit code will be registered as "failed" by `bitrise`.
