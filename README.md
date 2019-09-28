# SPCommonLibrary

# swift package 管理
      .package(url: "https://github.com/peng1207/SPCommonLibrary.git", from: "0.0.1.28")

# 用pod管理
    source 'https://github.com/peng1207/huangshupengSpecs.git'
    source 'https://github.com/CocoaPods/Specs.git'
    /*下载所有功能*/
    pod  'SPCommonLibrary'
    ## 按需要功能下载
    pod 'SPCommonLibrary/Public'
    pod 'SPCommonLibrary/Share'
    pod 'SPCommonLibrary/Request'
    pod 'SPCommonLibrary/ImageManager'
    pod 'SPCommonLibrary/Recording'

# 需要添加的权限
    NSCameraUsageDescription   摄像头权限
    NSMicrophoneUsageDescription 录音权限
    NSPhotoLibraryAddUsageDescription 添加图片到相册权限
    NSPhotoLibraryUsageDescription 相册权限
    NSSpeechRecognitionUsageDescription 实时语音转文字的权限
