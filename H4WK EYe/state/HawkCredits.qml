import QtQuick 2.15
import QtQuick.Shapes 1.15

/* =============================================================================
 * H4WK EYe - Credits                                            [v11 "atelier"]
 *
 * Reference IA, executed live (no pasted screenshots):
 *   header band (eagle hero + nebula + angular light + brand lockup + title)
 *     -> "Our Team" (large winged-eye emblem on the divider, ROMULUS | BLAZE-X)
 *     -> [Special Thanks | Join Our Community]
 *     -> footer
 *
 * Artisan art assets only (eagle, feather, crest, discord). All text is live.
 * Palette: flat violet identity. Colors as #AARRGGBB. No emoji. No neon glow.
 * ========================================================================== */

Item {
    id: root
    width: parent ? parent.width : 960
    property string pState: "file:///C:/Program%20Files/BlueStacks_msi5/H4WK%20EYe/state/"

    // ================= remote (live) content + updater =================
    readonly property string pApi: "https://raw.githubusercontent.com/blaze0089/h4wk-eye/main/"
    readonly property string pRoot: "file:///C:/Program%20Files/BlueStacks_msi5/H4WK%20EYe/"
    readonly property string pVersion: "6.0.4.12"
    property var pThanks: []
    property string pThanksState: "idle"
    property var pLinks: ({})
    property string pUpdateState: "idle"
    property string pUpdateVersion: ""

    readonly property var pLinkDefaults: ({
        "romulus_discord": "https://dsc.gg/romulus",
        "romulus_youtube": "https://youtube.com/@romulus_ff",
        "blazex_discord": "https://discord.gg/PzKAG83V7T",
        "blazex_github": "https://github.com/blaze0089",
        "join": "https://dsc.gg/romulus"
    })

    readonly property var pDefaultThanks: [
        { "name": "Romulus", "note": "YouTube - @romulus_ff", "url": "https://youtube.com/@romulus_ff" },
        { "name": "Blaze-X", "note": "Founder - GitHub", "url": "https://github.com/blaze0089" }
    ]

    readonly property var pThanksList: (pThanks && pThanks.length > 0) ? pThanks : pDefaultThanks

    readonly property var pThanksLoop: {
        var a = pThanksList, r = []
        for (var i = 0; i < a.length; i++) r.push(a[i])
        for (var j = 0; j < a.length; j++) r.push(a[j])
        return r
    }

    function fLink(k) {
        try { if (pLinks && pLinks[k] && pLinks[k].length > 0) return pLinks[k] } catch (e) {}
        return pLinkDefaults[k]
    }
    function fLinkLabel(u) { return String(u).replace(/^https?:\/\//, "") }

    function fThanksApply(st, txt) {
        if (st === 200) {
            var o = null
            try { o = JSON.parse(txt) } catch (e) { o = null }
            if (o && o.thanks && o.thanks.length > 0) {
                pThanks = o.thanks
                if (o.links) pLinks = o.links
                pThanksState = "live"
            } else { pThanksState = "empty" }
        } else { pThanksState = "offline" }
    }
    function fThanksFail() { pThanksState = "offline" }
    function fLoadThanks() {
        pThanksState = "loading"
        var self = root
        try {
            var x = new XMLHttpRequest()
            x.open("GET", pApi + "special_thanks.json?t=" + Date.now(), true)
            x.onreadystatechange = function() {
                if (x.readyState === XMLHttpRequest.DONE) self.fThanksApply(x.status, x.responseText)
            }
            x.onerror = function() { self.fThanksFail() }
            x.send()
        } catch (e) { pThanksState = "offline" }
    }

    function fUpdApply(st, txt) {
        if (st === 200) {
            var o = null
            try { o = JSON.parse(txt) } catch (e) { o = null }
            if (o && o.version) {
                pUpdateVersion = o.version
                pUpdateState = (o.version === pVersion) ? "latest" : "available"
            } else { pUpdateState = "error" }
        } else if (st === 404) { pUpdateState = "latest" }
        else { pUpdateState = "error" }
    }
    function fUpdFail() { pUpdateState = "offline" }
    function fCheckUpdate() {
        if (pUpdateState === "checking") return
        if (pUpdateState === "available") {
            pUpdateState = "updating"
            Qt.openUrlExternally(pRoot + "update.cmd")
            return
        }
        pUpdateState = "checking"
        pUpdateVersion = ""
        var self = root
        try {
            var x = new XMLHttpRequest()
            x.open("GET", pApi + "update.json?t=" + Date.now(), true)
            x.onreadystatechange = function() {
                if (x.readyState === XMLHttpRequest.DONE) self.fUpdApply(x.status, x.responseText)
            }
            x.onerror = function() { self.fUpdFail() }
            x.send()
        } catch (e) { pUpdateState = "error" }
    }

    function fUpdateLabel() {
        if (pUpdateState === "checking") return "Checking..."
        if (pUpdateState === "available") return "Update now"
        if (pUpdateState === "updating") return "Updating..."
        if (pUpdateState === "latest") return "Up to date"
        return "Check for updates"
    }
    function fUpdPrimary() {
        return pUpdateState === "available" || pUpdateState === "updating"
    }
    function fUpdIcon() {
        if (pUpdateState === "latest") return "\uE73E"
        if (pUpdateState === "checking" || pUpdateState === "updating") return "\uE895"
        return "\uE72C"
    }
    function fUpdateHint() {
        if (pUpdateState === "available") return "v" + pUpdateVersion + " is available"
        if (pUpdateState === "offline") return "No internet connection"
        if (pUpdateState === "error") return "Couldn't reach the update server"
        if (pUpdateState === "updating") return "Applying changes..."
        return ""
    }

    Timer {
        interval: 120000
        repeat: true
        running: root.visible
        onTriggered: root.fLoadThanks()
    }

    Component.onCompleted: root.fLoadThanks()

    readonly property real padX: 20
    readonly property real contentW: Math.min(Math.max(360, width - padX * 2), 960)
    readonly property real gap: 14
    readonly property real leftW: Math.round((contentW - gap) * 0.46)
    readonly property real rightW: contentW - gap - leftW
    implicitHeight: col.implicitHeight + 20

    // ---- palette ----
    readonly property color ink:        "#F6F4FC"
    readonly property color inkSilver:  "#E4DEF6"
    readonly property color ink2:       "#A79FC2"
    readonly property color ink3:       "#7C7593"
    readonly property color panelTop:   "#1A1430"
    readonly property color panelBot:   "#110D20"
    readonly property color hair:       "#2C2547"
    readonly property color hairHi:     "#514185"
    readonly property color violet:     "#8B5CF6"
    readonly property color violetHi:   "#BEA6FF"
    readonly property color violetDeep: "#5B2CE0"
    readonly property color chip:       "#241C40"

    Column {
        id: col
        x: (parent.width - width) / 2
        y: 10
        width: root.contentW
        spacing: 16

        // ============================ HEADER BAND ============================
        Rectangle {
            id: hdr
            width: parent.width
            height: 208
            radius: 18
            clip: true
            border.width: 1
            border.color: root.hair
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "#1C1636" }
                GradientStop { position: 0.55; color: "#150F27" }
                GradientStop { position: 1.0; color: "#0A0714" }
            }

            // deep violet nebula behind the eagle
            Shape {
                width: 720
                height: 560
                x: hdr.width - 560
                y: hdr.height - 380
                ShapePath {
                    strokeColor: "transparent"
                    fillGradient: RadialGradient {
                        centerX: 300
                        centerY: 300
                        centerRadius: 280
                        GradientStop { position: 0.0; color: "#7A8B5CF6" }
                        GradientStop { position: 0.42; color: "#338B5CF6" }
                        GradientStop { position: 1.0; color: "#008B5CF6" }
                    }
                    PathSvg { path: "M0 0 H720 V560 H0 Z" }
                }
            }

            // bright angular light streaks (left)
            Rectangle {
                width: 2; height: 560; x: 132; y: -190; rotation: 33
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0.0; color: "#00FFFFFF" }
                    GradientStop { position: 0.48; color: "#6FB79BFF" }
                    GradientStop { position: 1.0; color: "#00FFFFFF" }
                }
            }
            Rectangle {
                width: 1; height: 560; x: 170; y: -190; rotation: 33
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0.0; color: "#00FFFFFF" }
                    GradientStop { position: 0.5; color: "#3F8B5CF6" }
                    GradientStop { position: 1.0; color: "#00FFFFFF" }
                }
            }
            Rectangle { width: 1; height: 560; color: "#2A2350"; opacity: 0.9; rotation: 33; x: 74; y: -190 }
            Rectangle { width: 1; height: 560; color: "#221C42"; opacity: 0.7; rotation: 33; x: 208; y: -190 }
            Rectangle { width: 2; height: 150; color: "#4ABEA6FF"; opacity: 0.55; rotation: 33; x: 46; y: -150 }
            Rectangle { width: 2; height: 150; color: "#3F8B5CF6"; opacity: 0.5; rotation: 33; x: 246; y: -150 }

            // soft horizon bloom under the eagle
            Rectangle {
                height: 96
                width: hdr.width * 0.62
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -34
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0.0; color: "#008B5CF6" }
                    GradientStop { position: 1.0; color: "#5C8B5CF6" }
                }
            }

            // eagle hero, bleeding off the right edge
            Image {
                source: root.pState + "credits_eagle.png"
                width: 556
                height: 250
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: 0.99
                anchors.right: parent.right
                anchors.rightMargin: -52
                anchors.verticalCenter: parent.verticalCenter
            }

            // bright horizon line at the bottom
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 1
                width: parent.width
                height: 2
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0;  color: "#00A57CFF" }
                    GradientStop { position: 0.5;  color: "#00A57CFF" }
                    GradientStop { position: 0.66; color: "#CCA57CFF" }
                    GradientStop { position: 1.0;  color: "#00A57CFF" }
                }
            }

            // top highlight
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 1
                anchors.leftMargin: 18
                anchors.rightMargin: 18
                height: 1
                color: "#FFFFFF"
                opacity: 0.07
            }

            // brand lockup + title
            Column {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.verticalCenter: parent.verticalCenter
                spacing: 7

                Row {
                    spacing: 10
                    Image {
                        source: root.pState + "h4wk_crest_light.png"
                        width: 40
                        height: 27
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: 0.95
                    }
                    Text {
                        text: "H4WK EYe"
                        color: root.violetHi
                        font.family: "Segoe UI"
                        font.pixelSize: 12
                        font.bold: true
                        font.letterSpacing: 3.4
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Text {
                    text: "Credits"
                    color: root.ink
                    font.family: "Segoe UI"
                    font.pixelSize: 44
                    font.bold: true
                    font.letterSpacing: 0.2
                }
                Text {
                    text: "About H4WK EYe and its makers."
                    color: root.ink2
                    font.family: "Segoe UI"
                    font.pixelSize: 13
                    font.letterSpacing: 0.4
                }
                Rectangle {
                    width: 56; height: 3; radius: 1.5
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#BEA6FF" }
                        GradientStop { position: 1.0; color: "#5B2CE0" }
                    }
                }
            }
            // check for updates
            Row {
                spacing: 12
                anchors.left: parent.left
                anchors.leftMargin: 300
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 24

                Rectangle {
                    id: updBtn
                    height: 34
                    width: updRow.width + 34
                    radius: 17
                    anchors.verticalCenter: parent.verticalCenter
                    border.width: 1
                    border.color: root.fUpdPrimary()
                                  ? (upHov.containsMouse ? "#D9C8FF" : "#BEA6FF")
                                  : (upHov.containsMouse ? root.violetHi : root.hairHi)
                    gradient: Gradient {
                        orientation: Gradient.Vertical
                        GradientStop {
                            position: 0.0
                            color: root.fUpdPrimary() ? (upHov.containsMouse ? "#A57CFF" : "#8B5CF6")
                                                      : (upHov.containsMouse ? "#332A56" : "#2A2148")
                        }
                        GradientStop {
                            position: 1.0
                            color: root.fUpdPrimary() ? (upHov.containsMouse ? "#7C4DFF" : "#5B2CE0")
                                                      : (upHov.containsMouse ? "#241C40" : "#1A1430")
                        }
                    }

                    Row {
                        id: updRow
                        anchors.centerIn: parent
                        spacing: 8
                        Text {
                            text: root.fUpdIcon()
                            color: root.fUpdPrimary() ? "#FFFFFF" : root.violetHi
                            font.family: "Segoe MDL2 Assets"
                            font.pixelSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: root.fUpdateLabel()
                            color: root.fUpdPrimary() ? "#FFFFFF" : root.ink
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    MouseArea {
                        id: upHov
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.fCheckUpdate()
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.fUpdateHint()
                    color: root.ink2
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    visible: text.length > 0
                }
            }
        }

        // ============================== OUR TEAM ==============================
        Rectangle {
            id: team
            width: parent.width
            height: teamCol.height + 50
            radius: 18
            clip: true
            border.width: 1
            border.color: root.hair
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: root.panelTop }
                GradientStop { position: 1.0; color: root.panelBot }
            }

            // bottom violet bloom
            Shape {
                width: 640
                height: 340
                x: (team.width - 640) / 2
                y: team.height - 250
                ShapePath {
                    strokeColor: "transparent"
                    fillGradient: RadialGradient {
                        centerX: 320
                        centerY: 300
                        centerRadius: 240
                        GradientStop { position: 0.0; color: "#4A7C4DFF" }
                        GradientStop { position: 0.5; color: "#1E7C4DFF" }
                        GradientStop { position: 1.0; color: "#007C4DFF" }
                    }
                    PathSvg { path: "M0 0 H640 V340 H0 Z" }
                }
            }

            // feather watermark (both edges)
            Image {
                source: root.pState + "credits_wing.png"
                width: 268
                height: 238
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: 0.2
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: -30
                anchors.bottomMargin: -40
            }
            Image {
                source: root.pState + "credits_wing.png"
                width: 240
                height: 214
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: 0.14
                mirror: true
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: -40
                anchors.bottomMargin: -34
            }

            // angular hairlines
            Rectangle { width: 1; height: 340; color: "#241E48"; opacity: 0.7; rotation: 34; x: 34; y: -70 }
            Rectangle { width: 1; height: 340; color: "#221C42"; opacity: 0.55; rotation: 34; x: 70; y: -70 }
            Rectangle { width: 1; height: 340; color: "#221C42"; opacity: 0.5; rotation: -34; x: team.width - 40; y: -70 }
            Rectangle { width: 2; height: 150; color: "#4A8B5CF6"; opacity: 0.5; rotation: 34; x: team.width - 96; y: -46 }
            Rectangle { width: 2; height: 130; color: "#3FBEA6FF"; opacity: 0.42; rotation: 34; x: 34; y: team.height - 84 }

            // horizon line at bottom
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 1
                width: parent.width
                height: 2
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0;  color: "#007C4DFF" }
                    GradientStop { position: 0.5;  color: "#8F9571FF" }
                    GradientStop { position: 1.0;  color: "#007C4DFF" }
                }
            }

            // top highlight
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 1
                anchors.leftMargin: 18
                anchors.rightMargin: 18
                height: 1
                color: "#FFFFFF"
                opacity: 0.06
            }

            Column {
                id: teamCol
                x: 28
                width: parent.width - 56
                anchors.top: parent.top
                anchors.topMargin: 24
                spacing: 18

                // heading
                Row {
                    spacing: 12
                    Item {
                        width: 24
                        height: 22
                        anchors.verticalCenter: parent.verticalCenter
                        Rectangle { x: 2;  y: 2; width: 3; height: 18; radius: 1.5; color: root.violetHi;   transform: Rotation { origin.x: 1.5; origin.y: 9; angle: -22 } }
                        Rectangle { x: 10; y: 2; width: 3; height: 18; radius: 1.5; color: root.violet;     transform: Rotation { origin.x: 1.5; origin.y: 9; angle: -22 } }
                        Rectangle { x: 18; y: 2; width: 3; height: 18; radius: 1.5; color: root.violetDeep; transform: Rotation { origin.x: 1.5; origin.y: 9; angle: -22 } }
                    }
                    Column {
                        spacing: 3
                        anchors.verticalCenter: parent.verticalCenter
                        Text { text: "Our Team"; color: root.ink; font.family: "Segoe UI"; font.pixelSize: 20; font.bold: true }
                        Text { text: "The minds behind H4WK EYe."; color: root.ink2; font.family: "Segoe UI"; font.pixelSize: 12; font.letterSpacing: 0.3 }
                    }
                }

                // big winged-eye emblem on the divider
                Item {
                    width: parent.width
                    height: 118

                    // glow behind the emblem
                    Shape {
                        width: 380
                        height: 240
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        ShapePath {
                            strokeColor: "transparent"
                            fillGradient: RadialGradient {
                                centerX: 190
                                centerY: 120
                                centerRadius: 130
                                GradientStop { position: 0.0; color: "#8A8B5CF6" }
                                GradientStop { position: 0.5; color: "#338B5CF6" }
                                GradientStop { position: 1.0; color: "#008B5CF6" }
                            }
                            PathSvg { path: "M0 0 H380 V240 H0 Z" }
                        }
                    }

                    // left rule + angular cap
                    Rectangle {
                        width: 232; height: 2
                        anchors.right: parent.horizontalCenter
                        anchors.rightMargin: 104
                        anchors.verticalCenter: parent.verticalCenter
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: "#00231E42" }
                            GradientStop { position: 1.0; color: "#E0A57CFF" }
                        }
                    }
                    Rectangle { width: 10; height: 2; color: "#E0BEA6FF"; rotation: -34; anchors.right: parent.horizontalCenter; anchors.rightMargin: 336; anchors.verticalCenter: parent.verticalCenter }

                    // right rule + angular cap
                    Rectangle {
                        width: 232; height: 2
                        anchors.left: parent.horizontalCenter
                        anchors.leftMargin: 104
                        anchors.verticalCenter: parent.verticalCenter
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: "#E0A57CFF" }
                            GradientStop { position: 1.0; color: "#00231E42" }
                        }
                    }
                    Rectangle { width: 10; height: 2; color: "#E0BEA6FF"; rotation: 34; anchors.left: parent.horizontalCenter; anchors.leftMargin: 336; anchors.verticalCenter: parent.verticalCenter }

                    Image {
                        source: root.pState + "h4wk_crest_tint.png"
                        width: 192
                        height: 128
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // contributors
                Item {
                    id: mwrap
                    width: parent.width
                    height: Math.max(m1.height, m2.height)
                    readonly property real sideW: (width - 168) / 2

                    Column {
                        id: m1
                        width: mwrap.sideW
                        anchors.left: parent.left
                        anchors.top: parent.top
                        spacing: 6
                        Text { text: "ROMULUS"; color: root.inkSilver; font.family: "Segoe UI"; font.pixelSize: 26; font.bold: true; font.letterSpacing: 6.0; width: parent.width; horizontalAlignment: Text.AlignHCenter }
                        Text {
                            text: root.fLinkLabel(root.fLink("romulus_discord"))
                            color: rl.hovered ? root.violetHi : root.violet
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            font.bold: true
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            HoverHandler { id: rl }
                            TapHandler { onTapped: Qt.openUrlExternally(root.fLink("romulus_discord")) }
                        }
                    }

                    Rectangle {
                        width: 1
                        height: Math.min(mwrap.height, 78)
                        color: root.hairHi
                        opacity: 0.7
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 2
                    }

                    Column {
                        id: m2
                        width: mwrap.sideW
                        anchors.right: parent.right
                        anchors.top: parent.top
                        spacing: 6
                        Text { text: "BLAZE-X"; color: root.inkSilver; font.family: "Segoe UI"; font.pixelSize: 26; font.bold: true; font.letterSpacing: 6.0; width: parent.width; horizontalAlignment: Text.AlignHCenter }
                        Text {
                            text: root.fLinkLabel(root.fLink("blazex_discord"))
                            color: bl.hovered ? root.violetHi : root.violet
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            font.bold: true
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            HoverHandler { id: bl }
                            TapHandler { onTapped: Qt.openUrlExternally(root.fLink("blazex_discord")) }
                        }
                        Text {
                            text: root.fLinkLabel(root.fLink("blazex_github"))
                            color: bg.hovered ? root.violetHi : root.violet
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            font.bold: true
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            HoverHandler { id: bg }
                            TapHandler { onTapped: Qt.openUrlExternally(root.fLink("blazex_github")) }
                        }
                    }
                }
            }
        }

        // ======================= THANKS | COMMUNITY =======================
        Row {
            width: parent.width
            spacing: root.gap

            // ---- Special Thanks ----
            Rectangle {
                id: thanks
                width: root.leftW
                height: 196
                radius: 18
                clip: true
                border.width: 1
                border.color: root.hair
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: root.panelTop }
                    GradientStop { position: 1.0; color: root.panelBot }
                }
                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: 1
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    height: 1
                    color: "#FFFFFF"
                    opacity: 0.06
                }
                Image {
                    source: root.pState + "credits_wing.png"
                    width: 210
                    height: 188
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    opacity: 0.24
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: -30
                    anchors.bottomMargin: -26
                }
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                    width: parent.width
                    height: 2
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#007C4DFF" }
                        GradientStop { position: 0.55; color: "#9A9571FF" }
                        GradientStop { position: 1.0; color: "#007C4DFF" }
                    }
                }
                Rectangle { width: 1; height: 220; color: "#221C42"; opacity: 0.55; rotation: 34; x: 24; y: -50 }

                Shape {
                    width: 26; height: 26
                    x: 18; y: 19
                    ShapePath {
                        fillColor: root.violetHi
                        strokeColor: "transparent"
                        startX: 13; startY: 0
                        PathLine { x: 17.2; y: 8.4 }
                        PathLine { x: 26;   y: 9.5 }
                        PathLine { x: 19.5; y: 15.6 }
                        PathLine { x: 21.2; y: 24.2 }
                        PathLine { x: 13;   y: 19.9 }
                        PathLine { x: 4.8;  y: 24.2 }
                        PathLine { x: 6.5;  y: 15.6 }
                        PathLine { x: 0;    y: 9.5 }
                        PathLine { x: 8.8;  y: 8.4 }
                        PathLine { x: 13;   y: 0 }
                    }
                }
                Text {
                    x: 56
                    y: 19
                    text: "Special Thanks"
                    color: root.ink
                    font.family: "Segoe UI"
                    font.pixelSize: 17
                    font.bold: true
                }
                Text {
                    x: 18
                    y: 48
                    width: parent.width - 36
                    text: "To everyone who supports H4WK EYe."
                    color: root.ink2
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    elide: Text.ElideRight
                }

                Item {
                    id: thanksView
                    x: 18
                    y: 72
                    width: parent.width - 36
                    height: parent.height - 86
                    clip: true

                    Column {
                        id: thanksTrack
                        width: parent.width
                        readonly property real unit: root.pThanksList.length * 40

                        Repeater {
                            model: root.pThanksLoop
                            delegate: Item {
                                width: thanksTrack.width
                                height: 40

                                Text {
                                    id: tnm
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: (modelData && modelData.name) ? modelData.name : ""
                                    color: root.inkSilver
                                    font.family: "Segoe UI"
                                    font.pixelSize: 14
                                    font.bold: true
                                }
                                Text {
                                    anchors.left: tnm.right
                                    anchors.leftMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: (modelData && modelData.note) ? ("\u00B7 " + modelData.note) : ""
                                    color: root.ink3
                                    font.family: "Segoe UI"
                                    font.pixelSize: 11
                                }
                                Rectangle {
                                    width: parent.width
                                    height: 1
                                    color: root.hair
                                    opacity: 0.5
                                    anchors.bottom: parent.bottom
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: (modelData && modelData.url) ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    onClicked: if (modelData && modelData.url) Qt.openUrlExternally(modelData.url)
                                }
                            }
                        }
                    }

                    NumberAnimation {
                        target: thanksTrack
                        property: "y"
                        from: 0
                        to: -thanksTrack.unit
                        duration: Math.max(6000, root.pThanksList.length * 4200)
                        loops: Animation.Infinite
                        running: root.pThanksList.length > 1
                    }
                }
            }

            // ---- Join Our Community ----
            Rectangle {
                id: comm
                width: root.rightW
                height: 196
                radius: 18
                clip: true
                border.width: 1
                border.color: root.hair
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: root.panelTop }
                    GradientStop { position: 1.0; color: root.panelBot }
                }
                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: 1
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    height: 1
                    color: "#FFFFFF"
                    opacity: 0.06
                }
                Shape {
                    width: 420
                    height: 260
                    x: comm.width - 260
                    y: comm.height - 170
                    ShapePath {
                        strokeColor: "transparent"
                        fillGradient: RadialGradient {
                            centerX: 150
                            centerY: 150
                            centerRadius: 150
                            GradientStop { position: 0.0; color: "#4A7C4DFF" }
                            GradientStop { position: 1.0; color: "#007C4DFF" }
                        }
                        PathSvg { path: "M0 0 H420 V260 H0 Z" }
                    }
                }
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                    width: parent.width
                    height: 2
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#007C4DFF" }
                        GradientStop { position: 0.5; color: "#009571FF" }
                        GradientStop { position: 1.0; color: "#8F9571FF" }
                    }
                }
                Rectangle { width: 1; height: 220; color: "#221C42"; opacity: 0.55; rotation: 34; x: 24; y: -50 }

                Rectangle {
                    width: 38; height: 38; radius: 11
                    x: 18; y: 17
                    color: "#1E1734"
                    border.width: 1
                    border.color: root.hairHi
                    Image {
                        anchors.centerIn: parent
                        source: root.pState + "h4wk_discord.png"
                        width: 22
                        height: 22
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                }
                Text {
                    x: 66
                    y: 17
                    text: "Join Our Community"
                    color: root.ink
                    font.family: "Segoe UI"
                    font.pixelSize: 17
                    font.bold: true
                }
                Text {
                    x: 18
                    y: 62
                    width: parent.width - 36
                    text: "Get support, share feedback and be part of our community."
                    color: root.ink2
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    wrapMode: Text.WordWrap
                    lineHeight: 1.3
                }
                Rectangle {
                    id: jbtn
                    width: 172; height: 42; radius: 12
                    x: 18
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 16
                    gradient: Gradient {
                        orientation: Gradient.Vertical
                        GradientStop { position: 0.0; color: jcArea.containsMouse ? "#A57CFF" : "#8B5CF6" }
                        GradientStop { position: 1.0; color: jcArea.containsMouse ? "#7C4DFF" : "#5B2CE0" }
                    }
                    border.width: 1
                    border.color: root.violetHi
                    Row {
                        anchors.centerIn: parent
                        spacing: 9
                        Image {
                            source: root.pState + "h4wk_discord.png"
                            width: 16
                            height: 16
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text { text: "Join Discord"; color: "#FFFFFF"; font.family: "Segoe UI"; font.pixelSize: 12; font.bold: true; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "\u2192"; color: "#FFFFFF"; font.family: "Segoe UI"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                    }
                    MouseArea { id: jcArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: Qt.openUrlExternally(root.fLink("join")) }
                }
            }
        }

        // ============================== FOOTER ==============================
        Item {
            width: parent.width
            height: 46
            Rectangle {
                width: parent.width; height: 1
                color: root.hair
                anchors.top: parent.top
            }
            Text {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 11
                text: "\u00A9 2026 H4WK EYe Technologies \u00B7 v6.0.4.12 \u00B7 HWK-604-NX"
                color: root.ink3
                font.family: "Segoe UI"
                font.pixelSize: 11
            }
            Text {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 11
                text: "Pie 64-bit \u00B7 Vulkan \u00B7 Stable"
                color: root.ink3
                font.family: "Segoe UI"
                font.pixelSize: 11
            }
        }
    }
}
