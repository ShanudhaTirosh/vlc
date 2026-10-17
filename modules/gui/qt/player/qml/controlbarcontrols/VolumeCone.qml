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
import VLC.MainInterface
import VLC.Widgets as Widgets
import VLC.Util

Item {
    id: root

    property bool paintOnly: false
    readonly property var _player: paintOnly ? ({ muted: false, volume: 0.5 }) : Player
    readonly property int _maxvol: MainCtx.maxVolume
    readonly property real _maxvolpos: _maxvol / 100.0

    // Dimensions from VLC Community Redesign
    implicitWidth: VLCDesignTokens.coneVolumeWidth
    implicitHeight: VLCDesignTokens.coneVolumeHeight

    focus: true
    activeFocusOnTab: true

    Keys.onUpPressed: {
        if (!paintOnly) {
            Player.muted = false
            Player.setVolumeUp()
        }
    }
    Keys.onRightPressed: Keys.onUpPressed(null)
    Keys.onDownPressed: {
        if (!paintOnly) {
            Player.muted = false
            Player.setVolumeDown()
        }
    }
    Keys.onLeftPressed: Keys.onDownPressed(null)

    Accessible.role: Accessible.Slider
    Accessible.name: qsTr("Volume")
    AccessibleCompat.id: "volumeConeSlider"
    Accessible.onIncreaseAction: {
        if (!paintOnly) {
            Player.muted = false
            Player.setVolumeUp()
        }
    }
    Accessible.onDecreaseAction: {
        if (!paintOnly) {
            Player.muted = false
            Player.setVolumeDown()
        }
    }

    // Normalized volume value (0.0 to 1.0)
    readonly property real currentVolume: {
        if (_player.muted)
            return 0.0
        return Math.max(0.0, Math.min(1.0, _player.volume / _maxvolpos))
    }

    // Redraw canvas whenever volume or dimensions change
    onCurrentVolumeChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true

        renderTarget: Canvas.FramebufferObject
        renderStrategy: Canvas.Immediate

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()

            const w = width
            const h = height
            const leftH = h * 0.35   // Narrow left height (muted/low)
            const rightH = h * 0.90  // Wide right height (max volume)
            const centerY = h / 2.0
            const radius = 3.0

            const x0 = radius
            const y0Top = centerY - leftH / 2.0
            const y0Bottom = centerY + leftH / 2.0

            const x1 = w - radius
            const y1Top = centerY - rightH / 2.0
            const y1Bottom = centerY + rightH / 2.0

            // Helper function to build tapered cone path
            function buildConePath(targetX) {
                const endX = Math.min(targetX, x1)
                const ratio = Math.max(0.0, Math.min(1.0, (endX - x0) / (x1 - x0)))
                const currTop = y0Top + (y1Top - y0Top) * ratio
                const currBottom = y0Bottom + (y1Bottom - y0Bottom) * ratio

                ctx.beginPath()
                // Left rounded edge
                ctx.moveTo(x0, y0Top)
                ctx.arc(x0, centerY, leftH / 2.0, -Math.PI / 2, Math.PI / 2, true)
                // Bottom slope to endX
                ctx.lineTo(endX, currBottom)
                // Right vertical cut / edge
                ctx.lineTo(endX, currTop)
                // Top slope back to start
                ctx.closePath()
            }

            // 1. Draw Background Track (unfilled)
            ctx.save()
            buildConePath(x1)
            ctx.fillStyle = VLCDesignTokens.bgInput
            ctx.fill()
            ctx.lineWidth = 1.0
            ctx.strokeStyle = VLCDesignTokens.borderSubtle
            ctx.stroke()
            ctx.restore()

            // 2. Draw Active Volume Fill (Gradient)
            if (root.currentVolume > 0.01) {
                const fillWidth = x0 + (x1 - x0) * root.currentVolume

                ctx.save()
                buildConePath(fillWidth)

                // Linear gradient matching redesign mockups (Lime -> Orange -> Red)
                const grad = ctx.createLinearGradient(x0, 0, x1, 0)
                grad.addColorStop(0.0, VLCDesignTokens.accentLime)
                grad.addColorStop(0.65, VLCDesignTokens.accentOrange)
                grad.addColorStop(1.0, VLCDesignTokens.accentRed)

                ctx.fillStyle = grad
                ctx.fill()
                ctx.restore()

                // 3. Draw Thumb Indicator Needle
                ctx.save()
                const ratio = root.currentVolume
                const thumbTop = y0Top + (y1Top - y0Top) * ratio - 1.0
                const thumbBottom = y0Bottom + (y1Bottom - y0Bottom) * ratio + 1.0

                ctx.beginPath()
                ctx.moveTo(fillWidth, thumbTop)
                ctx.lineTo(fillWidth, thumbBottom)
                ctx.lineWidth = 2.0
                ctx.strokeStyle = "#FFFFFF"
                ctx.stroke()
                ctx.restore()
            }
        }
    }

    // Interaction handling
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        enabled: !root.paintOnly

        cursorShape: Qt.PointingHandCursor

        function updateVolume(mouseEvent) {
            const clampedX = Math.max(0.0, Math.min(width, mouseEvent.x))
            const newVol = (clampedX / width) * root._maxvolpos

            Player.muted = false
            Player.volume = Math.max(0.0, Math.min(root._maxvolpos, newVol))
        }

        onPressed: (mouse) => updateVolume(mouse)
        onPositionChanged: (mouse) => {
            if (pressed)
                updateVolume(mouse)
        }

        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) {
                Player.muted = false
                Player.setVolumeUp()
            } else if (wheel.angleDelta.y < 0) {
                Player.muted = false
                Player.setVolumeDown()
            }
        }

        T.ToolTip.visible: containsMouse
        T.ToolTip.delay: VLCStyle.delayToolTipAppear
        T.ToolTip.text: Math.round(root._player.volume * 100) + "%"
    }
}
