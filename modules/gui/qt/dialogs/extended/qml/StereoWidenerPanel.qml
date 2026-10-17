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
import VLC.Util

Item {
    id: root

    implicitWidth: VLCStyle.dp(380, VLCStyle.scale)
    implicitHeight: mainCol.implicitHeight + VLCStyle.margin_large * 2

    ColumnLayout {
        id: mainCol
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: VLCStyle.margin_normal
        spacing: VLCStyle.margin_normal

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: contentCol.implicitHeight + VLCStyle.margin_normal * 2
            color: VLCDesignTokens.bgDark2
            radius: VLCDesignTokens.radiusCard
            border.color: VLCDesignTokens.borderSubtle
            border.width: 1

            ColumnLayout {
                id: contentCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: VLCStyle.margin_normal
                spacing: VLCStyle.margin_normal

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: qsTr("Stereo Widener")
                        font.pixelSize: VLCStyle.fontSize_normal
                        font.weight: Font.Bold
                        color: VLCDesignTokens.textPrimary
                        Layout.fillWidth: true
                    }
                    Text {
                        text: "▼"
                        font.pixelSize: VLCStyle.dp(10, VLCStyle.scale)
                        color: VLCDesignTokens.textMuted
                    }
                }

                Widgets.DSPSlider {
                    Layout.fillWidth: true
                    label: qsTr("Delay Time")
                    minValue: 0
                    maxValue: 100
                    stepSize: 1
                    value: 20
                    unit: " ms"
                    valueMultiplier: 1.0
                    decimals: 1
                }

                Widgets.DSPSlider {
                    Layout.fillWidth: true
                    label: qsTr("Feedback Gain")
                    minValue: 0
                    maxValue: 100
                    stepSize: 1
                    value: 20
                    unit: " %"
                    valueMultiplier: 0.01
                    decimals: 2
                }

                Widgets.DSPSlider {
                    Layout.fillWidth: true
                    label: qsTr("Crossfeed")
                    minValue: 0
                    maxValue: 100
                    stepSize: 1
                    value: 30
                    unit: " %"
                    valueMultiplier: 0.01
                    decimals: 2
                }

                Widgets.DSPSlider {
                    Layout.fillWidth: true
                    label: qsTr("Dry Mix")
                    minValue: 0
                    maxValue: 100
                    stepSize: 1
                    value: 80
                    unit: " %"
                    valueMultiplier: 0.01
                    decimals: 2
                }
            }
        }
    }
}
