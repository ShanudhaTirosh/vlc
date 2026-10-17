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

import VLC.Player
import VLC.Style
import VLC.Widgets as Widgets
import VLC.Util
import VLC.MainInterface

FocusScope {
    id: root

    implicitWidth: VLCStyle.dp(600, VLCStyle.scale)
    implicitHeight: VLCStyle.dp(56, VLCStyle.scale)

    property color activeColor: VLCDesignTokens.accentOrange
    property color activeHoverColor: VLCDesignTokens.accentOrangeLight
    property color inactiveColor: VLCDesignTokens.borderSubtle
    property color hoverTrackColor: "#555555"

    readonly property real currentPosition: Helpers.clamp(Player.position, 0.0, 1.0)
    property real hoverPosition: -1.0
    property bool isHovered: hoverArea.containsMouse
    property bool isScrubbing: false

    Accessible.role: Accessible.Slider
    Accessible.name: qsTr("Audio Waveform Progress")
    AccessibleCompat.id: "waveformSeekBar"

    activeFocusOnTab: true

    Keys.onRightPressed: Player.jumpFwd()
    Keys.onLeftPressed: Player.jumpBwd()
    Keys.onSpacePressed: Player.togglePlayPause()

    onCurrentPositionChanged: canvas.requestPaint()
    onHoverPositionChanged: canvas.requestPaint()
    onIsHoveredChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent
        renderStrategy: Canvas.Threaded

        onPaint: {
            const ctx = getContext("2d")
            const w = width
            const h = height

            ctx.clearRect(0, 0, w, h)

            if (w <= 0 || h <= 0)
                return

            const barW = Math.max(1, Math.round(VLCStyle.dp(3, VLCStyle.scale)))
            const gap = Math.max(1, Math.round(VLCStyle.dp(2, VLCStyle.scale)))
            const step = barW + gap
            const count = Math.floor(w / step)

            if (count <= 0)
                return

            const playedRatio = root.currentPosition
            const hoverRatio = (root.isHovered && root.hoverPosition >= 0) ? (root.hoverPosition / w) : -1.0
            const midY = h / 2.0
            const minBarHeight = Math.max(4, Math.round(VLCStyle.dp(4, VLCStyle.scale)))
            const maxHalfH = (h / 2.0) - Math.round(VLCStyle.dp(3, VLCStyle.scale))

            // Seed based on track title string hash
            let seed = 42
            const titleStr = Player.title ? Player.title : "VLC"
            for (let s = 0; s < titleStr.length; ++s) {
                seed = ((seed << 5) - seed) + titleStr.charCodeAt(s)
                seed |= 0
            }

            for (let i = 0; i < count; ++i) {
                const x = i * step
                const ratio = i / count

                // Waveform window curve (smooth bell curve envelope)
                const window = Math.sin(Math.PI * ratio)

                // Deterministic harmonics pseudo-random pattern
                const h1 = Math.sin(i * 0.18 + (seed % 17))
                const h2 = Math.sin(i * 0.37 + (seed % 23))
                const h3 = Math.cos(i * 0.73 + (seed % 31))
                const rawAmp = 0.35 + 0.35 * Math.abs(h1 * 0.5 + h2 * 0.3 + h3 * 0.2)
                const barHalfHeight = Math.max(minBarHeight / 2.0, maxHalfH * rawAmp * Math.max(0.2, window))

                const barTop = midY - barHalfHeight
                const barHeight = barHalfHeight * 2.0

                // Color determination
                if (ratio <= playedRatio) {
                    ctx.fillStyle = (hoverRatio >= 0 && ratio <= hoverRatio)
                                    ? root.activeHoverColor.toString()
                                    : root.activeColor.toString()
                } else if (hoverRatio >= 0 && ratio <= hoverRatio) {
                    ctx.fillStyle = root.hoverTrackColor.toString()
                } else {
                    ctx.fillStyle = root.inactiveColor.toString()
                }

                // Draw rounded vertical bar
                const radius = Math.min(barW / 2.0, 1.5)
                ctx.beginPath()
                ctx.moveTo(x + radius, barTop)
                ctx.lineTo(x + barW - radius, barTop)
                ctx.arcTo(x + barW, barTop, x + barW, barTop + radius, radius)
                ctx.lineTo(x + barW, barTop + barHeight - radius)
                ctx.arcTo(x + barW, barTop + barHeight, x + barW - radius, barTop + barHeight, radius)
                ctx.lineTo(x + radius, barTop + barHeight)
                ctx.arcTo(x, barTop + barHeight, x, barTop + barHeight - radius, radius)
                ctx.lineTo(x, barTop + radius)
                ctx.arcTo(x, barTop, x + radius, barTop, radius)
                ctx.closePath()
                ctx.fill()
            }

            // Needle thumb indicator on playhead
            const thumbX = playedRatio * w
            ctx.fillStyle = VLCDesignTokens.textPrimary.toString()
            ctx.fillRect(thumbX - 1, 0, 2, h)
        }
    }

    // Hover tooltip showing scrub time
    Rectangle {
        id: tooltipBubble
        visible: root.isHovered && root.hoverPosition >= 0 && Player.length.valid()
        x: Helpers.clamp(root.hoverPosition - (width / 2), 0, root.width - width)
        y: -height - VLCStyle.dp(6, VLCStyle.scale)
        width: timeLabel.implicitWidth + VLCStyle.dp(12, VLCStyle.scale)
        height: timeLabel.implicitHeight + VLCStyle.dp(6, VLCStyle.scale)
        color: VLCDesignTokens.bgDark3
        radius: VLCDesignTokens.radiusButton
        border.color: VLCDesignTokens.borderSubtle
        border.width: 1

        Text {
            id: timeLabel
            anchors.centerIn: parent
            color: VLCDesignTokens.textPrimary
            font.pixelSize: VLCStyle.fontSize_small
            font.weight: Font.Medium
            text: {
                if (!root.isHovered || root.hoverPosition < 0 || !Player.length.valid())
                    return ""
                const fraction = Helpers.clamp(root.hoverPosition / root.width, 0.0, 1.0)
                return Player.length.scale(fraction).formatHMS()
            }
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        function seekToMouse(mouseX) {
            const fraction = Helpers.clamp(mouseX / width, 0.0, 1.0)
            Player.position = fraction
        }

        onPositionChanged: (mouse) => {
            root.hoverPosition = mouse.x
            if (root.isScrubbing)
                seekToMouse(mouse.x)
        }

        onPressed: (mouse) => {
            root.forceActiveFocus()
            root.isScrubbing = true
            seekToMouse(mouse.x)
        }

        onReleased: {
            root.isScrubbing = false
        }

        onExited: {
            root.hoverPosition = -1.0
            root.isScrubbing = false
        }

        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0)
                Player.jumpFwd()
            else if (wheel.angleDelta.y < 0)
                Player.jumpBwd()
        }
    }
}
