    import UIKit
    import MediaPlayer

    class ViewController: UIViewController {
        @IBOutlet weak var playPauseButton: UIButton!
        @IBAction func playPauseButtonTap(_ sender: Any) {
            if self.audioPlayer.rate != 0.0 {
                pause()
            } else {
                play()
            }
        }

        private var audioPlayer: AVPlayer!
        private var hasPlayed = false

        override func viewDidLoad() {
            super.viewDidLoad()

            let fileUrl = Bundle.main.url(forResource: "temp/intro", withExtension: ".mp3")
            let item = AVPlayerItem(url: fileUrl!)
            self.audioPlayer = AVPlayer(playerItem: item)
            let audioSession = AVAudioSession.sharedInstance()
            do { // play on speakers if headphones not plugged in
                try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            } catch let error as NSError {
                print("Override headphones failed, probably because none are available: \(error.localizedDescription)")
            }
            do {
                try audioSession.setCategory(.playback, mode: .spokenAudio)
                try audioSession.setActive(true)
            } catch let error as NSError {
                print("Warning: Setting audio category to .playback|.spokenAudio failed: \(error.localizedDescription)")
            }
            playPauseButton.setTitle("Play", for: .normal)
        }

        func play() {
            playPauseButton.setTitle("Pause", for: .normal)
            self.audioPlayer.play()
            if(!hasPlayed){
                self.setupRemoteTransportControls()
                self.hasPlayed = true
            }
        }

        func pause() {
            playPauseButton.setTitle("Play", for: .normal)
            self.audioPlayer.pause()
        }

        // MARK: Remote Transport Protocol
        @objc private func handlePlay(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
            print(".......................")
            print(self.audioPlayer.currentTime)
            guard self.audioPlayer?.rate == 0.0 else { return .commandFailed }
            print("attempting to play")
            self.audioPlayer.play()
            print("play() invoked")
            return .success
        }

        @objc private func handlePause(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
            print(".......................")
            print(self.audioPlayer.currentTime)
            guard self.audioPlayer.rate != 0.0 else { return .commandFailed }
            print("attempting to pause")
            self.pause()
            print("pause() invoked")
            return .success
        }

        private func setupRemoteTransportControls() {
            let commandCenter = MPRemoteCommandCenter.shared()
            commandCenter.playCommand.addTarget(self, action: #selector(self.handlePlay))
            commandCenter.pauseCommand.addTarget(self, action: #selector(self.handlePause))
            var nowPlayingInfo = [String : Any]()
            nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "Major title"
            nowPlayingInfo[MPMediaItemPropertyTitle] = "Minor Title"
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.audioPlayer.currentTime
            if let duration = audioPlayer.currentItem?.asset.duration {
                nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds(duration)
            }
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.audioPlayer.rate
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }

