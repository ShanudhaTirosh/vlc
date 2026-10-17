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
import VLC.Util

FocusScope {
    id: root

    implicitWidth: VLCStyle.dp(340, VLCStyle.scale)
    implicitHeight: VLCStyle.dp(48, VLCStyle.scale)

    property string label: ""
    property real from: -20.0
    property real to: 20.0
    property real value: 0.0
    property real stepSize: 0.1
    property string unit: "dB"
    property int decimals: 1

    property color trackColor: VLCDesignTokens.bgInput
    property color progressColor: VLCDesignTokens.accentOrange
    property color thumbColor: VLCDesignTokens.accentOrange
    property color thumbHoverColor: VLCDesignTokens.accentOrangeLight

    signal valueModified(real newValue)

    readonly property real normalizedPosition: {
        if (to === from)
            return 0.0
        return Helpers.clamp((value - from) / (to - from), 0.0, 1.0)
    }

    Accessible.role: Accessible.Slider
    Accessible.name: label
    Accessible.value: value.toFixed(decimals) + " " + unit

    activeFocusOnTab: true

    Keys.onLeftPressed: {
        root.value = Math.max(root.from, root.value - root.stepSize)
        root.valueModified(root.value)
    }
    Keys.onRightPressed: {
        root.value = Math.min(root.to, root.value + root.stepSize)
        root.valueModified(root.value)
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: VLCStyle.dp(6, VLCStyle.scale)

        // Top Row: Parameter Label on Left, Dark Value Box on Right
        RowLayout {
            Layout.fillWidth: true

            Text {
                id: labelItem
                Layout.fillWidth: true
                text: root.label
                font.pixelSize: VLCStyle.fontSize_small
                font.weight: Font.Medium
                color: root.activeFocus ? VLCDesignTokens.textPrimary : VLCDesignTokens.textSecondary
                elide: Text.ElideRight
            }

            // Exact Figma numeric value box
            Rectangle {
                id: valueBox
                implicitWidth: Math.max(VLCStyle.dp(68, VLCStyle.scale), valueText.implicitWidth + VLCStyle.dp(16, VLCStyle.scale))
                implicitHeight: VLCStyle.dp(22, VLCStyle.scale)
                radius: VLCDesignTokens.radiusButton
                color: VLCDesignTokens.bgInput
                border.color: root.activeFocus ? VLCDesignTokens.accentOrange : VLCDesignTokens.borderSubtle
                border.width: 1

                Text {
                    id: valueText
                    anchors.centerIn: parent
                    text: root.value.toFixed(root.decimals) + (root.unit.length > 0 ? (" " + root.unit) : "")
                    font.pixelSize: VLCStyle.fontSize_xxsmall
                    font.weight: Font.SemiBold
                    color: VLCDesignTokens.textPrimary
                }
            }
        }

        // Bottom Row: Custom Dark Horizontal Track with Orange Fill and Needle Thumb
        Item {
            id: trackContainer
            Layout.fillWidth: true
            Layout.preferredHeight: VLCStyle.dp(14, VLCStyle.scale)

            // Groove Track
            Rectangle {
                id: groove
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: VLCStyle.dp(6, VLCStyle.scale)
                radius: VLCStyle.dp(2, VLCStyle.scale)
                color: root.trackColor

                // Progress Fill
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * root.normalizedPosition
                    radius: parent.radius
                    color: root.progressColor
                }
            }

            // Needle Thumb (Figma vertical rectangle needle)
            Rectangle {
                id: thumb
                width: VLCStyle.dp(4, VLCStyle.scale)
                height: VLCStyle.dp(14, VLCStyle.scale)
                radius: 1
                color: mouseArea.containsMouse ? root.thumbHoverColor : root.thumbColor
                anchors.verticalCenter: parent.verticalCenter
                x: Math.round(groove.width * root.normalizedPosition - width / 2.0)
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                function updateValueFromMouse(mouseX) {
                    const frac = Helpers.clamp(mouseX / width, 0.0, 1.0)
                    const rawVal = root.from + frac * (root.to - root.from)
                    const steppedVal = Math.round(rawVal / root.stepSize) * root.stepSize
                    root.value = Helpers.clamp(steppedVal, root.from, root.to)
                    root.valueModified(root.value)
                }

                onPressed: (mouse) => {
                    root.forceActiveFocus()
                    updateValueFromMouse(mouse.x)
                }

                onPositionChanged: (mouse) => {
                    if (pressed)
                        updateValueFromMouse(mouse.x)
                }

                onWheel: (wheel) => {
                    if (wheel.angleDelta.y > 0) {
                        root.value = Math.min(root.to, root.value + root.stepSize)
                    } else if (wheel.angleDelta.y < 0) {
                        root.value = Math.max(root.from, root.value - root.stepSize)
                    }
                    root.valueModified(root.value)
                }
            }
        }
    }
}
