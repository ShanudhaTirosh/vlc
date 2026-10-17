/*****************************************************************************
 * Copyright (C) 2026 VLC authors and VideoLAN
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * ( at your option ) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/

import QtQuick
import QtQuick.Templates as T
import QtQuick.Layouts

import VLC.Style
import VLC.Widgets as Widgets
import VLC.Util

FocusScope {
    id: root

    implicitWidth: VLCStyle.dp(400, VLCStyle.scale)
    implicitHeight: VLCStyle.dp(720, VLCStyle.scale)

    // Primary Category Tabs: 0: Playback, 1: Video, 2: Audio, 3: Subtitles
    property int primaryTab: 2
    property int currentTab: 0 // Secondary audio sub-tab: 0: Equalizer, 1: Compressor, 2: Spatializer, 3: Widener

    signal closeRequested()

    Accessible.role: Accessible.Pane
    Accessible.name: qsTr("Adjustments & Effects Drawer")
    AccessibleCompat.id: "audioDSPDrawer"

    Rectangle {
        anchors.fill: parent
        color: VLCDesignTokens.bgDark1
        border.color: VLCDesignTokens.borderSubtle
        border.width: 1

        Widgets.DefaultShadow {}
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // ── Header Bar ─────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: VLCStyle.dp(48, VLCStyle.scale)
            color: VLCDesignTokens.bgDark2
            border.color: VLCDesignTokens.borderSubtle
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: VLCStyle.margin_normal
                anchors.rightMargin: VLCStyle.margin_normal

                Text {
                    text: {
                        switch (root.primaryTab) {
                        case 0: return qsTr("Playback Speed & Controls")
                        case 1: return qsTr("Video Effects & Adjustments")
                        case 2: return qsTr("Audio DSP & Equalizer")
                        case 3: return qsTr("Subtitles & Synchronization")
                        default: return qsTr("Adjustments & Effects")
                        }
                    }
                    font.pixelSize: VLCStyle.fontSize_normal
                    font.weight: Font.Bold
                    color: VLCDesignTokens.textPrimary
                }

                Item { Layout.fillWidth: true }

                Widgets.IconToolButton {
                    text: VLCIcons.close
                    font.pixelSize: VLCStyle.icon_small
                    description: qsTr("Close Drawer")
                    onClicked: root.closeRequested()
                }
            }
        }

        // ── Primary Category Tabs ([Playback] [Video] [Audio] [Subtitles]) ────
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: VLCStyle.dp(42, VLCStyle.scale)
            color: VLCDesignTokens.bgDark2

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Repeater {
                    model: [
                        { name: qsTr("Playback"), id: 0, icon: "▶" },
                        { name: qsTr("Video"), id: 1, icon: "🎦" },
                        { name: qsTr("Audio"), id: 2, icon: "🎚" },
                        { name: qsTr("Subtitles"), id: 3, icon: "💬" }
                    ]

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: (root.primaryTab === modelData.id) ? VLCDesignTokens.bgDark1 : "transparent"

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: VLCStyle.margin_xxsmall

                            Text {
                                text: modelData.name
                                font.pixelSize: VLCStyle.fontSize_small
                                font.weight: (root.primaryTab === modelData.id) ? Font.SemiBold : Font.Normal
                                color: (root.primaryTab === modelData.id) ? VLCDesignTokens.textPrimary : VLCDesignTokens.textSecondary
                            }
                        }

                        // Vibrant Orange Active Tab Underline
                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: VLCStyle.dp(2, VLCStyle.scale)
                            color: VLCDesignTokens.primaryOrange
                            visible: root.primaryTab === modelData.id
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.primaryTab = modelData.id
                        }
                    }
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: VLCDesignTokens.borderSubtle
            }
        }

        // ── Audio Sub-Tab Switcher (Only visible when Audio primary tab is active) ──
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: VLCStyle.dp(36, VLCStyle.scale)
            color: VLCDesignTokens.bgDark0
            visible: root.primaryTab === 2

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Repeater {
                    model: [
                        { name: qsTr("Equalizer"), id: 0 },
                        { name: qsTr("Compressor"), id: 1 },
                        { name: qsTr("Spatializer"), id: 2 },
                        { name: qsTr("Widener"), id: 3 }
                    ]

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: (root.currentTab === modelData.id) ? VLCDesignTokens.bgDark2 : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: modelData.name
                            font.pixelSize: VLCStyle.dp(11, VLCStyle.scale)
                            font.weight: (root.currentTab === modelData.id) ? Font.SemiBold : Font.Normal
                            color: (root.currentTab === modelData.id) ? VLCDesignTokens.accentOrange : VLCDesignTokens.textSecondary
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: VLCStyle.dp(2, VLCStyle.scale)
                            color: VLCDesignTokens.accentOrange
                            visible: root.currentTab === modelData.id
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.currentTab = modelData.id
                        }
                    }
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: VLCDesignTokens.borderSubtle
            }
        }

        // ── Scrollable Tab Panels ──────────────────────────
        Flickable {
            id: flickable
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentWidth: width
            contentHeight: panelLoader.item ? panelLoader.item.implicitHeight + VLCStyle.margin_large * 2 : height

            Loader {
                id: panelLoader
                anchors.top: parent.top
                anchors.topMargin: VLCStyle.margin_normal
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - VLCStyle.margin_normal * 2

                sourceComponent: {
                    switch (root.primaryTab) {
                    case 0:
                        return playbackComp
                    case 1:
                        return videoComp
                    case 2:
                        switch (root.currentTab) {
                        case 0: return equalizerComp
                        case 1: return compressorComp
                        case 2: return spatializerComp
                        case 3: return stereoWidenerComp
                        default: return equalizerComp
                        }
                    case 3:
                        return subtitlesComp
                    default:
                        return equalizerComp
                    }
                }
            }

            Widgets.ScrollBarExt {
                flickable: flickable
            }
        }
    }

    Component {
        id: equalizerComp
        EqualizerPanel {}
    }

    Component {
        id: compressorComp
        CompressorPanel {}
    }

    Component {
        id: spatializerComp
        SpatializerPanel {}
    }

    Component {
        id: stereoWidenerComp
        StereoWidenerPanel {}
    }

    Component {
        id: videoComp
        VideoEffectsPanel {}
    }

    Component {
        id: subtitlesComp
        SubtitleSyncPanel {}
    }

    Component {
        id: playbackComp
        Rectangle {
            implicitWidth: VLCStyle.dp(380, VLCStyle.scale)
            implicitHeight: VLCStyle.dp(200, VLCStyle.scale)
            color: VLCDesignTokens.bgDark2
            radius: VLCDesignTokens.radiusCard
            border.color: VLCDesignTokens.borderSubtle
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: VLCStyle.margin_normal
                spacing: VLCStyle.margin_normal

                Text {
                    text: qsTr("Playback Rate")
                    font.pixelSize: VLCStyle.fontSize_normal
                    font.weight: Font.Bold
                    color: VLCDesignTokens.textPrimary
                }

                Widgets.DSPSlider {
                    Layout.fillWidth: true
                    label: qsTr("Speed")
                    minValue: 25
                    maxValue: 400
                    stepSize: 5
                    value: Math.round(Player.rate * 100)
                    unit: "x"
                    valueMultiplier: 0.01
                    decimals: 2

                    onValueChanged: {
                        var r = value * 0.01
                        if (Math.abs(Player.rate - r) > 0.01)
                            Player.rate = r
                    }
                }
            }
        }
    }
}
