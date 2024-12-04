#apk ipa all
Platform=$1
APP=YOUYU
#debug release
ENV=$2
#打包路径
saveDir=$MY_HOME_PATH$APP'/';
#plist文件
exportOptions_path="$(pwd)/ExportOptions.plist"
#ipa名称
ipa_name=$APP'-'$ENV'.ipa'

### 如果文件夹不存在的话，创建
createDirWhenNotFound(){
  dirname=$1
  if [ ! -d $dirname  ];then
    mkdir $dirname
    echo "创建文件夹:$dirname"
  fi
}

### 编译ipa
compileIpa() {
  archive_path=$1
  output_path=$saveDir
  xcodebuild -exportArchive -archivePath ${archive_path} -exportPath ${output_path} -exportOptionsPlist ${exportOptions_path}
  pushd $output_path
  for file in $(ls ./);
  do
  if [ -f $file ] && [[ $file == *".ipa" ]]
  then
     mv $file $ipa_name
  else
      if [ -f $file ] && [[ $file == *".apk" ]]
        then
        echo $file is not file \| dir.
        else
          echo $file is not file \| dir.
          rm -rf $APP"-"$ENV.xcarchive
          rm -rf DistributionSummary.plist
          rm -rf ExportOptions.plist
          rm -rf Packaging.log
          #删除其他无效文件
          #rm -rf $file
      fi
  fi
  done
  pushd $MY_HOME_PATH
  #压缩
  zip -m -r $APP'.zip' $APP

}

createDirWhenNotFound $saveDir
#打包ios&android
if [ $Platform == 'all'  ];then

    fvm flutter build apk --dart-define=ENV_FLAG=$ENV
    echo "android:"$APP"-"$ENV
    pushd build/app/outputs/flutter-apk/
    mv app-release*.apk $saveDir'/'$APP'-'$ENV'.apk'
    popd

    fvm flutter build ipa --dart-define=ENV_FLAG=$ENV
    echo "ios:"$APP"-"$ENV
    pushd build/ios/archive/
    mv *.xcarchive $saveDir'/'$APP'-'$ENV'.xcarchive'
    popd
    compileIpa $saveDir'/'$APP'-'$ENV'.xcarchive'

else
    #打包ios || android
    fvm flutter build $Platform --release --no-shrink --dart-define=ENV_FLAG=$ENV
    if [ $Platform == 'apk'  ];then
        echo "android:"$APP"-"$ENV
        cd build/app/outputs/flutter-apk/
        mv app-release*.apk $saveDir'/'$APP'-'$ENV'.apk'
    else
        echo "ios:"$APP"-"$ENV
        pushd build/ios/archive/
        mv *.xcarchive $saveDir'/'$APP'-'$ENV'.xcarchive'
        popd
        compileIpa $saveDir'/'$APP'-'$ENV'.xcarchive'
    fi
fi