import UIKit
import AVFoundation

struct Track {
    let title: String
    let artist: String
    let imageName: String
    let fileName: String
}

class ViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!

    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    private var tracks: [Track] = []
    private var currentIndex: Int = 0
    private var audioPlayer: AVAudioPlayer?
    private var isPlaying: Bool = false
    private var progressTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTracks()
        setupUI()
        loadTrack(at: currentIndex)
    }

    private func setupTracks() {
        tracks = [
            Track(title: "Track 1", artist: "2Pac",
                  imageName: "cover_1", fileName: "track1"),
            Track(title: "Track 2", artist: "Biggie",
                  imageName: "cover_2", fileName: "track2"),
            Track(title: "Track 3", artist: "Nirvana",
                  imageName: "cover_3", fileName: "track3"),
            Track(title: "Track 4", artist: "Jay z",
                  imageName: "cover_4", fileName: "track4"),
            Track(title: "Track 5", artist: "Eminem",
                  imageName: "cover_5", fileName: "track5")
        ]
    }

    private func setupUI() {
        coverImageView.contentMode = .scaleAspectFit
        updatePlayPauseIcon()
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 1
        progressSlider.value = 0
        currentTimeLabel.text = "0:00"
        durationLabel.text = "0:00"

    }

    private func loadTrack(at index: Int) {
        guard tracks.indices.contains(index) else { return }

        let track = tracks[index]
        currentIndex = index

        titleLabel.text = track.title
        artistLabel.text = track.artist
        coverImageView.image = UIImage(named: track.imageName)

        stopProgressTimer()
        audioPlayer?.stop()
        audioPlayer = nil

        if let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()

                if let duration = audioPlayer?.duration {
                    progressSlider.minimumValue = 0
                    progressSlider.maximumValue = Float(duration)
                    progressSlider.value = 0
                    currentTimeLabel.text = "0:00"
                    durationLabel.text = formatTime(duration)
                }
            } catch {
                print("Error loading audio: \(error)")
            }
        } else {
            print("Audio file not found: \(track.fileName).mp3")
        }

        if isPlaying {
            audioPlayer?.play()
            startProgressTimer()
        } else {
            stopProgressTimer()
        }
    }

    private func updatePlayPauseIcon() {
        let symbolName = isPlaying ? "pause.fill" : "play.fill"
        let image = UIImage(systemName: symbolName)
        playPauseButton.setImage(image, for: .normal)
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func startProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                             repeats: true) { [weak self] _ in
            guard let self = self,
                  let player = self.audioPlayer else { return }

            let current = player.currentTime
            self.progressSlider.value = Float(current)
            self.currentTimeLabel.text = self.formatTime(current)

            if current >= player.duration {
                self.isPlaying = false
                self.updatePlayPauseIcon()
                self.stopProgressTimer()
            }
        }
        if let timer = progressTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    private func stopProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }

    @IBAction func previousTapped(_ sender: UIButton) {
        if tracks.isEmpty { return }

        if currentIndex == 0 {
            currentIndex = tracks.count - 1
        } else {
            currentIndex -= 1
        }
        loadTrack(at: currentIndex)
    }

    @IBAction func playPauseTapped(_ sender: UIButton) {
        guard let player = audioPlayer else {
            loadTrack(at: currentIndex)
            audioPlayer?.play()
            isPlaying = true
            updatePlayPauseIcon()
            startProgressTimer()
            return
        }

        if player.isPlaying {
            player.pause()
            isPlaying = false
            stopProgressTimer()
        } else {
            player.play()
            isPlaying = true
            startProgressTimer()
        }
        updatePlayPauseIcon()
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        if tracks.isEmpty { return }

        if currentIndex == tracks.count - 1 {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
        loadTrack(at: currentIndex)
    }

    @IBAction func progressSliderChanged(_ sender: UISlider) {
        guard let player = audioPlayer else { return }

        player.currentTime = TimeInterval(sender.value)
        currentTimeLabel.text = formatTime(player.currentTime)

        if !isPlaying {
            player.prepareToPlay()
        }
    }
}

