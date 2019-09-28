//
//  SPRecordingManager.swift
//  Alamofire
//
//  Created by 黄树鹏 on 2019/9/19.
//

import Foundation
import AVFoundation
/// 录音管理系统
open class SPRecordingManager : NSObject{
    fileprivate var audioRecorder : AVAudioRecorder?
    /// 录制音频的保存文件路径
    fileprivate var filePath : String = ""
    private func sp_init(){
        do {
            let fileUrl = URL(fileURLWithPath: filePath)
            
            let recorderSetting = [
                AVEncoderBitRateKey: AVAudioQuality.min
                /// 采样率
                ,AVSampleRateKey : 11025
                ///
                ,AVFormatIDKey : kAudioFormatLinearPCM
                /// 通道
                ,AVNumberOfChannelsKey : 1
                /// 采样的位数
                ,AVLinearPCMBitDepthKey : 16
                ,AVLinearPCMIsFloatKey : false
                ,AVLinearPCMIsBigEndianKey : false
                ] as [String : Any]
            self.audioRecorder = try AVAudioRecorder(url: fileUrl, settings:  recorderSetting)
            self.audioRecorder?.delegate = self
            self.audioRecorder?.isMeteringEnabled = true
        }catch {
            sp_log(message: "初始化失败")
        }
    }
    /// 判断权限
    private func sp_auth(){
        SPAuthorizatio.sp_isRecord { [weak self](auth) in
            if auth {
                //  有权限
                self?.sp_init()
            }else{
                // 没有权限
            }
        }
    }
    public func sp_init(file : String){
        self.filePath = file
       
    }
    /// 开启录制  先调用初始化 成功之后在调用
    public func sp_start(){
        audioRecorder?.prepareToRecord()
        audioRecorder?.record()
    }
    /// 停止录制
    public func sp_stop(){
        if let isRecord = audioRecorder?.isRecording , isRecord == true{
            audioRecorder?.stop()
            audioRecorder?.deleteRecording()
        }
        audioRecorder = nil
    }
    /// 暂停录制
    public func sp_pause(){
        if let isRecord = audioRecorder?.isRecording , isRecord == true{
            audioRecorder?.pause()
        }
    }
}
extension SPRecordingManager : AVAudioRecorderDelegate {
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        sp_log(message: "录制音频完成")
    }
    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
      
    }
}


// 文字转语音
// 语音转文字
// 录音
