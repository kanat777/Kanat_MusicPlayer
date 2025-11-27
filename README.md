# Kanat_MusicPlayer

Simple music player app built with UIKit as part of iOS development assignment.

## Overview

The app plays a small playlist of local MP3 tracks.
User can see the current track cover, title, artist name and control playback with Previous / Play–Pause / Next buttons.

- **Framework**: UIKit
- **Language**: Swift
- **Minimum iOS**: 15.0
- **Layout**: Auto Layout + UIStackView (Interface Builder)
- **Audio**: `AVAudioPlayer` (local `.mp3` files in the bundle)

---

## Features

### UI & Layout

- Main screen uses a vertical `UIStackView`:
  - Album cover (`UIImageView`) with `scaleAspectFit`
  - Track title label (`UILabel`, bold, centered)
  - Artist name label (`UILabel`, secondary text, centered)
  - Horizontal `UIStackView` for control buttons:
    - Previous (`UIButton` with SF Symbol `backward.fill`)
    - Play / Pause (`UIButton` with SF Symbol `play.fill` / `pause.fill`)
    - Next (`UIButton` with SF Symbol `forward.fill`)
- Auto Layout constraints:
  - Stack view pinned to safe area with equal leading / trailing / top / bottom insets
  - Layout scales correctly on different iPhone screen sizes

### Data Model

```swift
struct Track {
    let title: String
    let artist: String
    let imageName: String
    let fileName: String
}

