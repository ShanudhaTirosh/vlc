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

T.Control {
    id: root

    implicitWidth: VLCStyle.dp(56, VLCStyle.scale)
    implicitHeight: VLCStyle.dp(26, VLCStyle.scale)

    property bool checked: false
    signal toggled(bool isChecked)

    background: Rectangle {
        radius: VLCDesignTokens.radiusButton
        color: root.checked ? VLCDesignTokens.bgDark0 : VLCDesignTokens.bgDark0
        border.color: VLCDesignTokens.borderMedium
        border.width: 1

        // Active orange indicator block or thumb
        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 2
            width: VLCStyle.dp(26, VLCStyle.scale)
            x: root.checked ? (parent.width - width - 2) : 2
            radius: VLCDesignTokens.radiusButton - 1
            color: root.checked ? VLCDesignTokens.primaryOrange : VLCDesignTokens.bgDark3

            Behavior on x {
                NumberAnimation { duration: VLCStyle.duration_short; easing.type: Easing.InOutQuad }
            }
        }

        // Text label inside the non-thumb region
        Text {
            anchors.verticalCenter: parent.verticalCenter
            x: root.checked ? VLCStyle.dp(8, VLCStyle.scale) : parent.width - width - VLCStyle.dp(8, VLCStyle.scale)
            text: root.checked ? qsTr("ON") : qsTr("OFF")
            font.pixelSize: VLCStyle.dp(9, VLCStyle.scale)
            font.weight: Font.Bold
            color: root.checked ? VLCDesignTokens.accentOrange : VLCDesignTokens.textMuted
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.checked = !root.checked
            root.toggled(root.checked)
        }
    }
}
