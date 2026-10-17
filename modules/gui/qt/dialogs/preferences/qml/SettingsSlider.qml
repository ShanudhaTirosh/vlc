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

Item {
    id: root

    implicitWidth: VLCStyle.dp(280, VLCStyle.scale)
    implicitHeight: VLCStyle.dp(38, VLCStyle.scale)

    property real minValue: 0
    property real maxValue: 100
    property real value: 50
    property string minLabel: "0%"
    property string midLabel: "50%"
    property string maxLabel: "100%"

    signal valueChangedByUser(real newVal)

    ColumnLayout {
        anchors.fill: parent
        spacing: 4

        // Slider track and thumb container
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: VLCStyle.dp(16, VLCStyle.scale)

            // Background Track
            Rectangle {
                id: trackBg
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: VLCStyle.dp(6, VLCStyle.scale)
                radius: 3
                color: VLCDesignTokens.bgDark0
                border.color: VLCDesignTokens.borderMedium
                border.width: 1

                // Active Orange Fill
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: Math.max(0, Math.min(parent.width, (root.value - root.minValue) / (root.maxValue - root.minValue) * parent.width))
                    radius: 3
                    color: VLCDesignTokens.primaryOrange
                }

                // Tick Marks
                Row {
                    anchors.fill: parent
                    Repeater {
                        model: 7
                        Rectangle {
                            width: 1
                            height: parent.height
                            x: (index / 6) * trackBg.width
                            color: "#333333"
                        }
                    }
                }
            }

            // Orange Needle Thumb
            Rectangle {
                id: thumb
                width: VLCStyle.dp(4, VLCStyle.scale)
                height: VLCStyle.dp(14, VLCStyle.scale)
                radius: 1
                color: VLCDesignTokens.primaryOrange
                anchors.verticalCenter: parent.verticalCenter
                x: Math.max(0, Math.min(parent.width - width, (root.value - root.minValue) / (root.maxValue - root.minValue) * parent.width - width / 2))
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                function updatePos(mouseX) {
                    var norm = Math.max(0.0, Math.min(1.0, mouseX / width))
                    root.value = Math.round(root.minValue + norm * (root.maxValue - root.minValue))
                    root.valueChangedByUser(root.value)
                }

                onPressed: (mouse) => updatePos(mouse.x)
                onPositionChanged: (mouse) => {
                    if (pressed) updatePos(mouse.x)
                }
            }
        }

        // Percentage / Value Labels below track
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: VLCStyle.dp(14, VLCStyle.scale)

            Text {
                anchors.left: parent.left
                text: root.minLabel
                font.pixelSize: VLCStyle.dp(10, VLCStyle.scale)
                color: VLCDesignTokens.textMuted
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.midLabel
                font.pixelSize: VLCStyle.dp(10, VLCStyle.scale)
                color: VLCDesignTokens.textMuted
            }

            Text {
                anchors.right: parent.right
                text: root.maxLabel
                font.pixelSize: VLCStyle.dp(10, VLCStyle.scale)
                color: VLCDesignTokens.textMuted
            }
        }
    }
}
