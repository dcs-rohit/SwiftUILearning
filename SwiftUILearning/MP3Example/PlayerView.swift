//
//  PlayerView.swift
//  SwiftUILearning
//
//  Created by differenz157 on 19/02/21.
//

import SwiftUI
import AVKit

class audioSettings: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    var playing = false
    @Published var playValue: TimeInterval = 0.0
    var playerDuration: TimeInterval = 146
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var totalDuration:String = "0"
    
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                if playing == false {
                    if (audioPlayer == nil) {
                        
                        
                        audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                        audioPlayer?.prepareToPlay()
                        
                        audioPlayer?.play()
                        playing = true
                    }
                    
                }
                if playing == false {
                    
                    audioPlayer?.play()
                    playing = true
                }
                
                
            } catch {
                print("Could not find and play the sound file.")
            }
        }
        
    }

    func stopSound() {
        //   if playing == true {
        audioPlayer?.stop()
        audioPlayer = nil
        playing = false
        playValue = 0.0
        //   }
    }
    
    func pauseSound() {
        if playing == true {
            audioPlayer?.pause()
            playing = false
        }
    }
    
    func changeSliderValue() {
        if playing == true {
            pauseSound()
            audioPlayer?.currentTime = playValue
            
        }
        
        if playing == false {
            audioPlayer?.play()
            playing = true
        }
    }
    func getHourMinutesSecond(seconds:Int)->String{
        let (h,m,s) = (seconds / 3600,(seconds % 3600)/60,(seconds % 3600) % 60)
        var str:String = ""
        if(h>0)
        {
           str =  String(format:"%02d:%02d:%02d", arguments: [h,m,s])
        }
        else {
            str = String(format:"%02d:%02d", arguments: [m,s])
        }
        return str
    }
     
    func getTotalDuration(sound: String, type: String)->String{
        let path = Bundle.main.path(forResource: sound, ofType: type)!
        let mp3URL = URL(fileURLWithPath: path)
        let audioAsset = AVURLAsset.init(url: mp3URL , options: nil)
        let duration = audioAsset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        totalDuration = self.getHourMinutesSecond(seconds: Int(durationInSeconds))
        return  totalDuration
    }
}

struct myExperienceFearChunk: View {
    @ObservedObject var audiosettings = audioSettings()
    @State private var playButton: Image = Image(systemName: "play.circle")
    @State private var startTimer : String = "00:00"
    
    var body: some View {
        
        VStack {
            Text(startTimer)
                .font(.system(size: 72))
                .font(.largeTitle)
                .foregroundColor(.green)
                .padding()
        HStack {
           
            Button(action: {
                if (self.playButton == Image(systemName: "play.circle")) {
                    print("All Done")
                    self.audiosettings.playSound(sound: "song", type: "mp3")
                    self.audiosettings.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    self.playButton = Image(systemName: "pause.circle")
                    
                } else {
                    
                    self.audiosettings.pauseSound()
                    self.playButton = Image(systemName: "play.circle")
                }
            }) {
                self.playButton
                    .foregroundColor(Color.white)
                    .font(.system(size: 44))
            }
            Button(action: {
                print("All Done")
                self.audiosettings.stopSound()
                self.playButton = Image(systemName: "play.circle")
                self.audiosettings.playValue = 0.0
                
            }) {
                Image(systemName: "stop.circle")
                    .foregroundColor(Color.white)
                    .font(.system(size: 44))
            }
        }
            HStack{
                Text(startTimer)
            Slider(value: $audiosettings.playValue, in: TimeInterval(0.0)...audiosettings.playerDuration, onEditingChanged: { _ in
            self.audiosettings.changeSliderValue()
        })
       
                Text(self.audiosettings.getTotalDuration(sound: "song", type: "mp3"))
            }.padding()
            .onReceive(audiosettings.timer) { _ in
                
                if self.audiosettings.playing {
                    if let currentTime = self.audiosettings.audioPlayer?.currentTime {
                      
                        self.audiosettings.playValue = currentTime
                        startTimer = audiosettings.getHourMinutesSecond(seconds: Int(currentTime))
                        if currentTime == TimeInterval(0.0) {
                            self.audiosettings.playing = false
                        }
                    }
                    
                }
                else {
                    self.audiosettings.playing = false
                    self.audiosettings.timer.upstream.connect().cancel()
                }
            }
        }
    }
}
