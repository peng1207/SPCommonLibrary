# SPCommonLibrary
# 下载所有的功能
    pod 'SPCommonLibrary'

#  只是下载公共类
    pod 'SPCommonLibrary/Public'
#  下载公共类和分享类 
    pod 'SPCommonLibrary/Share'
# 下载公共类和请求类
    pod 'SPCommonLibrary/Request'
# 下载公共类和选择相册图片 支持多选 图片裁剪
    pod 'SPCommonLibrary/ImageManager'
# 下载公共类和录音功能
    pod 'SPCommonLibrary/Recording'

# swift package 管理
      .package(url: "https://github.com/peng1207/SPCommonLibrary.git", from: "0.0.1.28")

# 用pod管理
    source 'https://github.com/peng1207/huangshupengSpecs.git'
    source 'https://github.com/CocoaPods/Specs.git'
 
    pod  'SPCommonLibrary'

