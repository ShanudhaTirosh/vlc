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

import VLC.Style

Item {
    id: root

    implicitWidth: VLCStyle.dp(600, VLCStyle.scale)
    implicitHeight: Math.max(VLCStyle.dp(38, VLCStyle.scale), contentLayout.implicitHeight)

    property string label: ""
    property bool hasInfo: true
    default property alias control: controlSlot.data

    RowLayout {
        id: contentLayout
        anchors.fill: parent
        spacing: VLCStyle.margin_normal

        RowLayout {
            spacing: VLCStyle.margin_xsmall
            Layout.fillWidth: true

            Text {
                text: root.label
                font.pixelSize: VLCStyle.fontSize_small
                color: VLCDesignTokens.textPrimary
            }

            Text {
                text: "ⓘ"
                font.pixelSize: VLCStyle.dp(12, VLCStyle.scale)
                color: VLCDesignTokens.textMuted
                visible: root.hasInfo
            }
        }

        Item {
            id: controlSlot
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
    }
}
