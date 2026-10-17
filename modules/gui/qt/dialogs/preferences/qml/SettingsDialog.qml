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
import QtQuick.Controls

import VLC.Style
import VLC.Widgets as Widgets

T.Popup {
    id: root

    implicitWidth: Math.min(VLCStyle.dp(1078, VLCStyle.scale), parent ? parent.width - 40 : 1000)
    implicitHeight: Math.min(VLCStyle.dp(895, VLCStyle.scale), parent ? parent.height - 40 : 800)

    anchors.centerIn: parent ? parent : undefined
    modal: true
    focus: true
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside

    property string currentCategory: "Subtitles"

    background: Rectangle {
        radius: VLCDesignTokens.radiusCard
        color: VLCDesignTokens.bgDark1
        border.color: VLCDesignTokens.borderSubtle
        border.width: 1

        Widgets.DefaultShadow {}
    }

    contentItem: RowLayout {
        anchors.fill: parent
        spacing: 0

        // ═══════════════════════════════════════════════════
        // LEFT SIDEBAR (220px)
        // ═══════════════════════════════════════════════════
        Rectangle {
            Layout.preferredWidth: VLCStyle.dp(220, VLCStyle.scale)
            Layout.fillHeight: true
            color: VLCDesignTokens.bgDark2
            border.color: VLCDesignTokens.borderSubtle
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: VLCStyle.margin_normal
                spacing: VLCStyle.margin_small

                // Search Bar
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: VLCStyle.dp(34, VLCStyle.scale)
                    color: VLCDesignTokens.bgDark0
                    radius: VLCDesignTokens.radiusButton
                    border.color: VLCDesignTokens.borderMedium
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: VLCStyle.margin_small
                        anchors.rightMargin: VLCStyle.margin_small
                        spacing: VLCStyle.margin_xsmall

                        Text {
                            text: "🔍"
                            font.pixelSize: VLCStyle.dp(12, VLCStyle.scale)
                            color: VLCDesignTokens.textMuted
                        }

                        TextInput {
                            Layout.fillWidth: true
                            color: VLCDesignTokens.textPrimary
                            font.pixelSize: VLCStyle.fontSize_small
                            selectByMouse: true

                            Text {
                                text: qsTr("Search")
                                color: VLCDesignTokens.textMuted
                                font.pixelSize: VLCStyle.fontSize_small
                                visible: !parent.text && !parent.activeFocus
                            }
                        }
                    }
                }

                // Category Navigation List
                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentHeight: navCol.implicitHeight
                    clip: true

                    ColumnLayout {
                        id: navCol
                        width: parent.width
                        spacing: VLCStyle.margin_small

                        // ── APP GROUP ───────────────────────
                        Text {
                            text: qsTr("APP")
                            font.pixelSize: VLCStyle.dp(11, VLCStyle.scale)
                            font.weight: Font.Bold
                            color: VLCDesignTokens.textMuted
                            Layout.topMargin: VLCStyle.margin_xsmall
                            Layout.leftMargin: VLCStyle.margin_xsmall
                        }

                        Repeater {
                            model: [
                                { name: qsTr("General"), icon: "⚙", id: "General" },
                                { name: qsTr("Interface"), icon: "📐", id: "Interface" },
                                { name: qsTr("Privacy"), icon: "🛡", id: "Privacy" },
                                { name: qsTr("Controls"), icon: "⌨", id: "Controls" }
                            ]
                            delegate: CategoryButton {
                                name: modelData.name
                                iconTxt: modelData.icon
                                isSelected: root.currentCategory === modelData.id
                                onClicked: root.currentCategory = modelData.id
                            }
                        }

                        // ── MEDIA GROUP ─────────────────────
                        Text {
                            text: qsTr("MEDIA")
                            font.pixelSize: VLCStyle.dp(11, VLCStyle.scale)
                            font.weight: Font.Bold
                            color: VLCDesignTokens.textMuted
                            Layout.topMargin: VLCStyle.margin_normal
                            Layout.leftMargin: VLCStyle.margin_xsmall
                        }

                        Repeater {
                            model: [
                                { name: qsTr("Playback"), icon: "▶", id: "Playback" },
                                { name: qsTr("Video"), icon: "🎦", id: "Video" },
                                { name: qsTr("Audio"), icon: "🎚", id: "Audio" },
                                { name: qsTr("Subtitles"), icon: "💬", id: "Subtitles" },
                                { name: qsTr("Library"), icon: "📁", id: "Library" }
                            ]
                            delegate: CategoryButton {
                                name: modelData.name
                                iconTxt: modelData.icon
                                isSelected: root.currentCategory === modelData.id
                                onClicked: root.currentCategory = modelData.id
                            }
                        }

                        // ── SYSTEM GROUP ────────────────────
                        Text {
                            text: qsTr("SYSTEM")
                            font.pixelSize: VLCStyle.dp(11, VLCStyle.scale)
                            font.weight: Font.Bold
                            color: VLCDesignTokens.textMuted
                            Layout.topMargin: VLCStyle.margin_normal
                            Layout.leftMargin: VLCStyle.margin_xsmall
                        }

                        Repeater {
                            model: [
                                { name: qsTr("Network"), icon: "🌐", id: "Network" },
                                { name: qsTr("Performance"), icon: "⚡", id: "Performance" },
                                { name: qsTr("Recording"), icon: "⏺", id: "Recording" },
                                { name: qsTr("Extensions"), icon: "🧩", id: "Extensions" }
                            ]
                            delegate: CategoryButton {
                                name: modelData.name
                                iconTxt: modelData.icon
                                isSelected: root.currentCategory === modelData.id
                                onClicked: root.currentCategory = modelData.id
                            }
                        }
                    }
                }
            }
        }

        // ═══════════════════════════════════════════════════
        // RIGHT CONTENT PANE
        // ═══════════════════════════════════════════════════
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Header Bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: VLCStyle.dp(56, VLCStyle.scale)
                color: VLCDesignTokens.bgDark1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: VLCStyle.margin_xlarge
                    anchors.rightMargin: VLCStyle.margin_xlarge

                    Text {
                        text: {
                            switch (root.currentCategory) {
                            case "Subtitles": return qsTr("Subtitle Defaults")
                            case "Audio": return qsTr("Audio Defaults")
                            case "Interface": return qsTr("Interface Settings")
                            case "Video": return qsTr("Video Defaults")
                            case "Playback": return qsTr("Playback Defaults")
                            default: return root.currentCategory + " " + qsTr("Settings")
                            }
                        }
                        font.pixelSize: VLCStyle.fontSize_large
                        font.weight: Font.Bold
                        color: VLCDesignTokens.textPrimary
                    }

                    Item { Layout.fillWidth: true }

                    Widgets.IconToolButton {
                        text: VLCIcons.close
                        font.pixelSize: VLCStyle.icon_small
                        description: qsTr("Close")
                        onClicked: root.close()
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

            // View Content Container
            Loader {
                Layout.fillWidth: true
                Layout.fillHeight: true

                sourceComponent: {
                    switch (root.currentCategory) {
                    case "Subtitles": return subtitlesViewComp
                    case "Audio": return audioViewComp
                    case "Interface": return interfaceViewComp
                    default: return subtitlesViewComp
                    }
                }
            }
        }
    }

    // Component View Definitions
    Component {
        id: subtitlesViewComp
        SettingsSubtitlesView {}
    }

    Component {
        id: audioViewComp
        SettingsAudioView {}
    }

    Component {
        id: interfaceViewComp
        SettingsInterfaceView {}
    }

    // Nav Item Component
    component CategoryButton: Rectangle {
        property string name: ""
        property string iconTxt: ""
        property bool isSelected: false
        signal clicked()

        Layout.fillWidth: true
        Layout.preferredHeight: VLCStyle.dp(34, VLCStyle.scale)
        radius: VLCDesignTokens.radiusButton
        color: isSelected ? VLCDesignTokens.bgDark3 : (itemMouse.containsMouse ? VLCDesignTokens.bgDark1 : "transparent")

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: VLCStyle.margin_small
            anchors.rightMargin: VLCStyle.margin_small
            spacing: VLCStyle.margin_small

            Text {
                text: iconTxt
                font.pixelSize: VLCStyle.dp(12, VLCStyle.scale)
                color: isSelected ? VLCDesignTokens.primaryOrange : VLCDesignTokens.textSecondary
            }

            Text {
                text: name
                font.pixelSize: VLCStyle.fontSize_small
                font.weight: isSelected ? Font.DemiBold : Font.Normal
                color: isSelected ? VLCDesignTokens.textPrimary : VLCDesignTokens.textSecondary
                Layout.fillWidth: true
            }
        }

        MouseArea {
            id: itemMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.clicked()
        }
    }
}
