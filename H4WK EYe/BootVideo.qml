import QtQuick 2.15
import QtMultimedia

// H4WK EYe cinematic B&W boot video (v2 overhaul).
// Replaces H4WK EYe/BootVideo.qml. Loaded through a Loader so a missing
// QtMultimedia plugin fails closed onto the still image; boot is unaffected.
//
// Wiring (set by the Loader, see ui_v2_boot.py):
//   src ......... "@@ROOT@@BootVideo.mp4" (h264, 720x1280) on Loader.onLoaded
//   snd marker .. "file:///C:/Program%20Files/BlueStacks_msi5/H4WK EYe/state/boot_sound.png" unmutes; absent means muted loop
// Placeholders @@ROOT@@ / file:///C:/Program%20Files/BlueStacks_msi5/H4WK EYe/state/ are file URLs substituted at install.
//
// Motion budget: the video element itself is the only motion on this screen.
// All chrome below is static. The single fade-in runs once, on first frames.
Item {
    id: bootRoot
    property string src: ""

    // Sound-marker probe. Ready means the user enabled boot video sound.
    Image {
        id: snd
        visible: false
        source: "file:///C:/Program%20Files/BlueStacks_msi5/H4WK EYe/state/boot_sound.png"
    }

    // Media core. Infinite muted-unless-marked loop, plays on source,
    // one-shot fade-in on the first decoded frames.
    MediaPlayer {
        id: mp
        source: src
        loops: MediaPlayer.Infinite
        audioOutput: AudioOutput { muted: snd.status !== Image.Ready }
        videoOutput: vo
        onSourceChanged: play()
        Component.onCompleted: if (src !== "") play()
        onPlaybackStateChanged: if (playbackState === MediaPlayer.PlayingState && vo.opacity < 1) fadeIn.start()
    }

    // B&W stage behind the video.
    Rectangle {
        id: stage
        anchors.fill: parent
        color: "#000000"
    }

    VideoOutput {
        id: vo
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
        opacity: 0
    }

    NumberAnimation {
        id: fadeIn
        target: vo
        property: "opacity"
        from: 0
        to: 1
        duration: 900
        easing.type: Easing.InOutQuad
    }

    // Soft vignette edges. Static gradients, no shaders, no effects module.
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#66000000" }
            GradientStop { position: 0.16; color: "#00000000" }
            GradientStop { position: 0.84; color: "#00000000" }
            GradientStop { position: 1.0; color: "#66000000" }
        }
    }
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#55000000" }
            GradientStop { position: 0.12; color: "#00000000" }
            GradientStop { position: 0.88; color: "#00000000" }
            GradientStop { position: 1.0; color: "#55000000" }
        }
    }


    // Hairline platinum frame around the whole stage.
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 1
        border.color: "#E8EAEE"
        opacity: 0.28
    }

    // Retry a stalled or late-resolving source. No decorative timers here.
    Timer {
        interval: 800
        repeat: true
        running: true
        onTriggered: if (src !== "" && mp.playbackState !== MediaPlayer.PlayingState) mp.play()
    }
}
