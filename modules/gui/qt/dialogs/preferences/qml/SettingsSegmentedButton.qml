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
    implicitHeight: VLCStyle.dp(34, VLCStyle.scale)

    property var options: [qsTr("Relative"), qsTr("Pixels")]
    property int currentIndex: 0

    signal selected(int index)

    Rectangle {
        anchors.fill: parent
        radius: VLCDesignTokens.radiusButton
        color: VLCDesignTokens.bgDark0
        border.color: VLCDesignTokens.borderMedium
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 2
            spacing: 2

            Repeater {
                model: root.options
                delegate: Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: VLCDesignTokens.radiusButton - 1
                    color: root.currentIndex === index ? "#3D270F" : "transparent"
                    border.color: root.currentIndex === index ? VLCDesignTokens.primaryOrange : "transparent"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.pixelSize: VLCStyle.fontSize_small
                        font.weight: root.currentIndex === index ? Font.DemiBold : Font.Normal
                        color: root.currentIndex === index ? VLCDesignTokens.primaryOrange : VLCDesignTokens.textSecondary
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.currentIndex = index
                            root.selected(index)
                        }
                    }
                }
            }
        }
    }
}
