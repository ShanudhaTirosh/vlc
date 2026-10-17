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

import VLC.MainInterface
import VLC.Style
import VLC.Widgets as Widgets
import VLC.Playlist
import VLC.Player
import VLC.Util

T.Control {
    id: root

    implicitWidth: Math.round(VLCStyle.dp(340, VLCStyle.scale))
    implicitHeight: queueDrawer.visible ? (videoBoxHeight + metadataHeight + queueHeight) : (videoBoxHeight + metadataHeight)

    width: implicitWidth
    height: implicitHeight

    objectName: "pip window"

    property real dragXMin: 0
    property real dragXMax: 0
    property real dragYMin: undefined
    property real dragYMax: undefined

    property int textStyle: Text.Normal
    property bool hideControls: MainCtx.usingTouch
    property bool showQueue: false

    readonly property real videoBoxHeight: Math.round(width * 9.0 / 16.0)
    readonly property real metadataHeight: Math.round(VLCStyle.dp(56, VLCStyle.scale))
    readonly property real queueHeight: Math.round(VLCStyle.dp(180, VLCStyle.scale))

    Accessible.role: Accessible.Graphic
    Accessible.focusable: false
    Accessible.name: qsTr("Mini Player")
    AccessibleCompat.id: "miniPlayerWindow"

    Drag.active: dragHandler.active

    Drag.onActiveChanged: {
        root.anchors.left = undefined
        root.anchors.right = undefined
        root.anchors.top = undefined
        root.anchors.bottom = undefined
        root.anchors.verticalCenter = undefined
        root.anchors.horizontalCenter = undefined
    }

    Behavior on height {
        NumberAnimation {
            duration: VLCStyle.duration_short
            easing.type: Easing.InOutQuad
        }
    }

    background: Rectangle {
        id: cardBg
        radius: VLCDesignTokens.radiusCard
        color: VLCDesignTokens.bgDark2
        border.color: VLCDesignTokens.borderSubtle
        border.width: 1
        clip: true

        Widgets.DefaultShadow {}
    }

    contentItem: ColumnLayout {
        spacing: 0
        clip: true

        // ── 1. Video / Media Area ──────────────────────────
        Item {
            id: videoArea
            Layout.fillWidth: true
            Layout.preferredHeight: root.videoBoxHeight
            clip: true

            VideoSurface {
                id: videoSurface
                anchors.fill: parent
                videoSurfaceProvider: MainCtx.videoSurfaceProvider
                visible: Player.hasVideoOutput

                Rectangle {
                    anchors.fill: parent
                    color: VLCDesignTokens.bgBlack
                    z: -1
                }
            }

            // Audio Artwork Fallback if no video
            Rectangle {
                anchors.fill: parent
                visible: !Player.hasVideoOutput
                color: VLCDesignTokens.bgBlack

                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: VLCAccessImage.uri(Player.artwork && Player.artwork.toString() ? Player.artwork : VLCStyle.noArtAlbumCover)
                    mipmap: true
                    opacity: 0.85
                }
            }

            // Interactive Drag and Tap
            DoubleClickIgnoringItem {
                anchors.fill: parent

                TapHandler {
                    gesturePolicy: TapHandler.WithinBounds
                    onDoubleTapped: (eventPoint, button) => {
                        if (eventPoint.device.type !== PointerDevice.TouchScreen)
                            MainCtx.playerView = true
                    }
                    onTapped: (eventPoint, button) => {
                        if (eventPoint.device.type === PointerDevice.TouchScreen) {
                            root.hideControls = !root.hideControls
                        } else {
                            MainPlaylistController.togglePlayPause()
                        }
                    }
                }

                DragHandler {
                    id: dragHandler
                    target: root
                    cursorShape: Qt.DragMoveCursor
                    dragThreshold: 0
                    grabPermissions: PointerHandler.CanTakeOverFromAnything
                    xAxis.minimum: root.dragXMin
                    xAxis.maximum: root.dragXMax
                    yAxis.minimum: root.dragYMin
                    yAxis.maximum: root.dragYMax
                }

                HoverHandler {
                    id: hoverHandler
                    grabPermissions: PointerHandler.CanTakeOverFromAnything
                    cursorShape: Qt.ArrowCursor
                }
            }

            // Overlay Controls (fades in on hover)
            Rectangle {
                id: overlayScrim
                anchors.fill: parent
                color: Qt.rgba(0, 0, 0, 0.55)
                opacity: (!root.hideControls && hoverHandler.hovered) ? 1.0 : 0.0

                Behavior on opacity {
                    NumberAnimation { duration: VLCStyle.duration_short }
                }

                // Close Button (Top-Left)
                Widgets.IconToolButton {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: VLCStyle.margin_xsmall
                    text: VLCIcons.close
                    font.pixelSize: VLCStyle.icon_small
                    description: qsTr("Close Miniplayer")
                    onClicked: MainPlaylistController.stop()
                }

                // Maximize / Pop-Out Button (Top-Right)
                Widgets.IconToolButton {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: VLCStyle.margin_xsmall
                    text: VLCIcons.fullscreen
                    font.pixelSize: VLCStyle.icon_small
                    description: qsTr("Expand Player")
                    onClicked: MainCtx.playerView = true
                }

                // Center Playback Trio
                RowLayout {
                    anchors.centerIn: parent
                    spacing: VLCStyle.margin_medium

                    Widgets.IconToolButton {
                        text: VLCIcons.previous
                        font.pixelSize: VLCStyle.icon_normal
                        description: qsTr("Previous")
                        onClicked: MainPlaylistController.prev()
                    }

                    Rectangle {
                        width: VLCStyle.dp(36, VLCStyle.scale)
                        height: width
                        radius: VLCDesignTokens.radiusButton
                        color: VLCDesignTokens.accentOrange

                        Text {
                            anchors.centerIn: parent
                            font.family: VLCIcons.fontFamily
                            font.pixelSize: VLCStyle.icon_normal
                            color: VLCDesignTokens.textPrimary
                            text: (Player.playingState === Player.PLAYING_STATE_PLAYING)
                                  ? VLCIcons.pause_filled
                                  : VLCIcons.play_filled
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MainPlaylistController.togglePlayPause()
                        }
                    }

                    Widgets.IconToolButton {
                        text: VLCIcons.next
                        font.pixelSize: VLCStyle.icon_normal
                        description: qsTr("Next")
                        onClicked: MainPlaylistController.next()
                    }
                }
            }

            // Seekbar at the bottom of the video preview
            Rectangle {
                id: miniSeekbar
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: VLCStyle.dp(3, VLCStyle.scale)
                color: VLCDesignTokens.bgInput

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * Helpers.clamp(Player.position, 0.0, 1.0)
                    color: VLCDesignTokens.accentOrange
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.topMargin: -VLCStyle.dp(4, VLCStyle.scale)
                    anchors.bottomMargin: -VLCStyle.dp(4, VLCStyle.scale)
                    cursorShape: Qt.PointingHandCursor
                    onPressed: (mouse) => Player.position = Helpers.clamp(mouse.x / width, 0.0, 1.0)
                    onPositionChanged: (mouse) => {
                        if (pressed)
                            Player.position = Helpers.clamp(mouse.x / width, 0.0, 1.0)
                    }
                }
            }
        }

        // ── 2. Metadata / Info Bar ────────────────────────
        Rectangle {
            id: infoBar
            Layout.fillWidth: true
            Layout.preferredHeight: root.metadataHeight
            color: VLCDesignTokens.bgDark2

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: VLCStyle.margin_normal
                anchors.rightMargin: VLCStyle.margin_normal
                spacing: VLCStyle.margin_small

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: VLCStyle.dp(3, VLCStyle.scale)

                    // Track / Video Title
                    Text {
                        Layout.fillWidth: true
                        text: Player.title ? Player.title : qsTr("VLC Media Player")
                        font.pixelSize: VLCStyle.fontSize_small
                        font.weight: Font.DemiBold
                        color: VLCDesignTokens.textPrimary
                        elide: Text.ElideRight
                        maximumLineCount: 1
                    }

                    // Metadata chips / badge indicators
                    RowLayout {
                        spacing: VLCStyle.margin_xsmall

                        Rectangle {
                            implicitWidth: badgeFolderText.implicitWidth + VLCStyle.dp(12, VLCStyle.scale)
                            implicitHeight: VLCStyle.dp(18, VLCStyle.scale)
                            radius: VLCDesignTokens.radiusButton
                            color: VLCDesignTokens.bgDark1
                            border.color: VLCDesignTokens.borderSubtle
                            border.width: 1

                            RowLayout {
                                anchors.centerIn: parent
                                spacing: VLCStyle.dp(4, VLCStyle.scale)

                                Text {
                                    font.family: VLCIcons.fontFamily
                                    font.pixelSize: VLCStyle.fontSize_xxsmall
                                    text: VLCIcons.folder
                                    color: VLCDesignTokens.textSecondary
                                }

                                Text {
                                    id: badgeFolderText
                                    text: Player.album ? Player.album : "Media"
                                    font.pixelSize: VLCStyle.fontSize_xxsmall
                                    color: VLCDesignTokens.textSecondary
                                    elide: Text.ElideRight
                                    maximumLineCount: 1
                                }
                            }
                        }

                        Rectangle {
                            implicitWidth: badgeArtistText.implicitWidth + VLCStyle.dp(12, VLCStyle.scale)
                            implicitHeight: VLCStyle.dp(18, VLCStyle.scale)
                            radius: VLCDesignTokens.radiusButton
                            color: VLCDesignTokens.bgDark1
                            border.color: VLCDesignTokens.borderSubtle
                            border.width: 1

                            RowLayout {
                                anchors.centerIn: parent
                                spacing: VLCStyle.dp(4, VLCStyle.scale)

                                Text {
                                    font.family: VLCIcons.fontFamily
                                    font.pixelSize: VLCStyle.fontSize_xxsmall
                                    text: VLCIcons.music
                                    color: VLCDesignTokens.textSecondary
                                }

                                Text {
                                    id: badgeArtistText
                                    text: Player.artist ? Player.artist : (Player.hasVideoOutput ? "Video" : "Audio")
                                    font.pixelSize: VLCStyle.fontSize_xxsmall
                                    color: VLCDesignTokens.textSecondary
                                    elide: Text.ElideRight
                                    maximumLineCount: 1
                                }
                            }
                        }
                    }
                }

                // Queue Toggle Button
                Rectangle {
                    Layout.preferredWidth: VLCStyle.dp(28, VLCStyle.scale)
                    Layout.preferredHeight: Layout.preferredWidth
                    radius: VLCDesignTokens.radiusButton
                    color: root.showQueue ? VLCDesignTokens.accentOrange : VLCDesignTokens.bgDark3
                    border.color: root.showQueue ? VLCDesignTokens.accentOrange : VLCDesignTokens.borderSubtle
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        font.family: VLCIcons.fontFamily
                        font.pixelSize: VLCStyle.icon_small
                        color: root.showQueue ? VLCDesignTokens.textPrimary : VLCDesignTokens.textSecondary
                        text: VLCIcons.playlist
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.showQueue = !root.showQueue
                    }
                }
            }
        }

        // ── 3. Queue Drawer (Expandable) ────────────────────
        Rectangle {
            id: queueDrawer
            Layout.fillWidth: true
            Layout.preferredHeight: root.queueHeight
            visible: root.showQueue
            color: VLCDesignTokens.bgDark1
            border.color: VLCDesignTokens.borderSubtle
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Queue Header
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: VLCStyle.dp(36, VLCStyle.scale)
                    color: VLCDesignTokens.bgDark2

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: VLCStyle.margin_normal
                        anchors.rightMargin: VLCStyle.margin_normal

                        Text {
                            text: qsTr("Queue")
                            font.pixelSize: VLCStyle.fontSize_normal
                            font.weight: Font.Bold
                            color: VLCDesignTokens.textPrimary
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: qsTr("%1 items").arg(playlistModel.count)
                            font.pixelSize: VLCStyle.fontSize_xxsmall
                            color: VLCDesignTokens.textMuted
                        }
                    }
                }

                // Queue List View
                ListView {
                    id: queueList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: PlaylistListModel {
                        id: playlistModel
                        playlist: MainPlaylistController.playlist
                    }

                    delegate: Rectangle {
                        width: queueList.width
                        height: VLCStyle.dp(32, VLCStyle.scale)
                        color: (model.index === MainPlaylistController.currentIndex)
                               ? Qt.rgba(211/255, 121/255, 24/255, 0.15)
                               : (itemHover.hovered ? VLCDesignTokens.bgDark2 : "transparent")

                        HoverHandler { id: itemHover }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: VLCStyle.margin_small
                            anchors.rightMargin: VLCStyle.margin_small
                            spacing: VLCStyle.margin_xsmall

                            // Handle icon
                            Text {
                                text: "="
                                font.pixelSize: VLCStyle.fontSize_small
                                color: VLCDesignTokens.textMuted
                            }

                            // Track Title
                            Text {
                                Layout.fillWidth: true
                                text: model.title ? model.title : qsTr("Track %1").arg(model.index + 1)
                                font.pixelSize: VLCStyle.fontSize_small
                                font.weight: (model.index === MainPlaylistController.currentIndex) ? Font.Bold : Font.Normal
                                color: (model.index === MainPlaylistController.currentIndex)
                                       ? VLCDesignTokens.accentOrange
                                       : VLCDesignTokens.textPrimary
                                elide: Text.ElideRight
                                maximumLineCount: 1
                            }

                            // Duration
                            Text {
                                text: model.duration ? model.duration.formatHMS() : ""
                                font.pixelSize: VLCStyle.fontSize_xxsmall
                                color: VLCDesignTokens.textSecondary
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MainPlaylistController.goTo(model.index)
                        }
                    }
                }
            }
        }
    }
}
