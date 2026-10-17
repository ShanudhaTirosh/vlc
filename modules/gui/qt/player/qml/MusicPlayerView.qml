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
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Window

import VLC.MainInterface
import VLC.Style
import VLC.Widgets as Widgets
import VLC.Player
import VLC.Util

FocusScope {
    id: root

    implicitWidth: VLCStyle.dp(720, VLCStyle.scale)
    implicitHeight: VLCStyle.dp(600, VLCStyle.scale)

    property url coverSource: VLCAccessImage.uri(Player.artwork && Player.artwork.toString() ? Player.artwork : VLCStyle.noArtAlbumCover)
    property string trackTitle: Player.title ? Player.title : qsTr("Untitled Track")
    property string trackArtist: Player.artist ? Player.artist : qsTr("Unknown Artist")
    property string trackAlbum: Player.album ? Player.album : ""

    Accessible.role: Accessible.Pane
    Accessible.name: qsTr("Music Player View")
    AccessibleCompat.id: "musicPlayerView"

    ColumnLayout {
        anchors.centerIn: parent
        width: Math.min(parent.width - VLCStyle.margin_xxlarge * 2, VLCStyle.dp(680, VLCStyle.scale))
        spacing: VLCStyle.margin_medium

        // Audio format chip / badge (Lossless / Stereo)
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: VLCStyle.margin_xsmall

            Rectangle {
                implicitWidth: badgeText.implicitWidth + VLCStyle.dp(16, VLCStyle.scale)
                implicitHeight: VLCStyle.dp(22, VLCStyle.scale)
                radius: VLCDesignTokens.radiusButton
                color: VLCDesignTokens.bgDark2
                border.color: VLCDesignTokens.borderSubtle
                border.width: 1

                RowLayout {
                    anchors.centerIn: parent
                    spacing: VLCStyle.dp(6, VLCStyle.scale)

                    Rectangle {
                        width: VLCStyle.dp(6, VLCStyle.scale)
                        height: VLCStyle.dp(6, VLCStyle.scale)
                        radius: width / 2
                        color: VLCDesignTokens.accentOrange
                    }

                    Text {
                        id: badgeText
                        text: qsTr("LOSSLESS AUDIO")
                        font.pixelSize: VLCStyle.fontSize_xxsmall
                        font.weight: Font.Bold
                        font.capitalization: Font.AllUppercase
                        color: VLCDesignTokens.textSecondary
                    }
                }
            }

            Rectangle {
                visible: trackAlbum.length > 0
                implicitWidth: albumBadgeText.implicitWidth + VLCStyle.dp(16, VLCStyle.scale)
                implicitHeight: VLCStyle.dp(22, VLCStyle.scale)
                radius: VLCDesignTokens.radiusButton
                color: VLCDesignTokens.bgDark2
                border.color: VLCDesignTokens.borderSubtle
                border.width: 1

                Text {
                    id: albumBadgeText
                    anchors.centerIn: parent
                    text: trackAlbum
                    font.pixelSize: VLCStyle.fontSize_xxsmall
                    font.weight: Font.Medium
                    color: VLCDesignTokens.textMuted
                    elide: Text.ElideRight
                    maximumLineCount: 1
                }
            }
        }

        // Album Art with 12px corner radius and drop shadow
        Item {
            id: coverContainer
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: Math.min(root.height * 0.42, VLCStyle.dp(300, VLCStyle.scale))
            Layout.preferredHeight: Layout.preferredWidth

            // Drop shadows behind album art
            Widgets.RoundedRectangleShadow {
                color: Qt.rgba(0, 0, 0, 0.45)
                yOffset: VLCStyle.dp(16, VLCStyle.scale)
                blurRadius: VLCStyle.dp(36, VLCStyle.scale)
            }

            Widgets.RoundedRectangleShadow {
                color: Qt.rgba(0, 0, 0, 0.3)
                yOffset: VLCStyle.dp(4, VLCStyle.scale)
                blurRadius: VLCStyle.dp(10, VLCStyle.scale)
            }

            // Cover Image with exact rounded corners
            Rectangle {
                id: coverMask
                anchors.fill: parent
                radius: VLCDesignTokens.radiusAlbumArt
                color: VLCDesignTokens.bgDark2
                clip: true

                Image {
                    id: coverImage
                    anchors.fill: parent
                    source: root.coverSource
                    fillMode: Image.PreserveAspectCrop
                    mipmap: true
                    asynchronous: true
                    cache: true

                    onStatusChanged: {
                        if (status === Image.Error)
                            source = VLCStyle.noArtAlbumCover
                    }
                }

                // Subtle inner border stroke
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    border.color: Qt.rgba(1, 1, 1, 0.08)
                    border.width: 1
                }
            }
        }

        // Track Title & Artist Information
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            spacing: VLCStyle.margin_xxsmall

            Text {
                id: titleText
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                text: root.trackTitle
                font.pixelSize: VLCStyle.fontSize_xxlarge
                font.weight: Font.Bold
                color: VLCDesignTokens.textPrimary
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            Text {
                id: artistText
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                text: root.trackArtist
                font.pixelSize: VLCStyle.fontSize_normal
                font.weight: Font.Normal
                color: VLCDesignTokens.textSecondary
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                maximumLineCount: 1
            }
        }

        // Waveform Seek Bar with Flanking Timestamps
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: VLCStyle.margin_small

            // Current Time
            Text {
                id: currentTimeText
                Layout.preferredWidth: VLCStyle.dp(56, VLCStyle.scale)
                horizontalAlignment: Text.AlignRight
                text: Player.time.formatHMS()
                font.pixelSize: VLCStyle.fontSize_small
                font.weight: Font.Medium
                color: VLCDesignTokens.textSecondary
            }

            // Waveform Seek Bar
            WaveformSeekBar {
                id: waveform
                Layout.fillWidth: true
                Layout.preferredHeight: VLCStyle.dp(48, VLCStyle.scale)
            }

            // Total / Remaining Time
            Text {
                id: remainingTimeText
                Layout.preferredWidth: VLCStyle.dp(56, VLCStyle.scale)
                horizontalAlignment: Text.AlignLeft
                text: MainCtx.showRemainingTime && Player.remainingTime.valid()
                      ? "-" + Player.remainingTime.formatHMS()
                      : Player.length.formatHMS()
                font.pixelSize: VLCStyle.fontSize_small
                font.weight: Font.Medium
                color: VLCDesignTokens.textSecondary

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: MainCtx.showRemainingTime = !MainCtx.showRemainingTime
                }
            }
        }
    }
}
