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
import VLC.Widgets as Widgets
import VLC.Util

FocusScope {
    id: root

    implicitWidth: VLCStyle.dp(380, VLCStyle.scale)
    implicitHeight: mainLayout.implicitHeight + VLCStyle.margin_normal * 2

    property bool isExpanded: true
    property bool isEnabled: true
    property bool is2Pass: false

    readonly property var bandLabels: [
        "60 Hz", "170 Hz", "310 Hz", "600 Hz",
        "1 KHz", "3 KHz", "6 KHz", "12 KHz", "14 KHz", "16 KHz"
    ]

    property var bandValues: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    property real preampValue: 12.0

    readonly property var presets: [
        { name: "Flat", bands: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], preamp: 0 },
        { name: "Rock", bands: [4.8, 3.2, -1.6, -3.2, 0.0, 2.4, 4.0, 5.6, 5.6, 5.6], preamp: 5 },
        { name: "Pop", bands: [-1.6, 1.6, 4.0, 4.8, 3.2, -1.0, -1.6, -1.6, -1.6, -1.6], preamp: 4 },
        { name: "Classical", bands: [4.8, 3.2, 2.4, 2.4, -1.6, -1.6, 0.0, 2.4, 3.2, 4.0], preamp: 4 },
        { name: "Jazz", bands: [3.2, 2.4, 1.0, 1.6, -1.6, -1.6, 0.0, 1.6, 2.4, 3.2], preamp: 4 },
        { name: "Bass Boost", bands: [7.0, 6.0, 4.5, 2.0, 0.0, -1.0, -2.0, -2.0, -2.0, -2.0], preamp: 3 },
        { name: "Vocal", bands: [-1.6, -2.0, -1.0, 1.6, 4.0, 4.5, 3.0, 1.0, -1.0, -2.0], preamp: 2 }
    ]

    function applyPreset(index) {
        if (index < 0 || index >= presets.length)
            return
        const p = presets[index]
        preampValue = p.preamp
        const newBands = []
        for (let i = 0; i < p.bands.length; ++i)
            newBands.push(p.bands[i])
        bandValues = newBands
    }

    function resetFlat() {
        applyPreset(0)
    }

    Rectangle {
        anchors.fill: parent
        radius: VLCDesignTokens.radiusCard
        color: VLCDesignTokens.bgDark2
        border.color: VLCDesignTokens.borderSubtle
        border.width: 1
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: VLCStyle.margin_normal
        spacing: VLCStyle.margin_small

        // Collapsible Header (Matching Figma "Collapse Settings" / "Expand Settings")
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: VLCStyle.dp(36, VLCStyle.scale)
            radius: VLCDesignTokens.radiusButton
            color: headerHover.hovered ? VLCDesignTokens.bgDark3 : "transparent"

            HoverHandler { id: headerHover }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: VLCStyle.margin_xsmall
                anchors.rightMargin: VLCStyle.margin_xsmall

                Text {
                    text: root.isExpanded ? qsTr("Collapse Settings") : qsTr("Expand Settings")
                    font.pixelSize: VLCStyle.fontSize_small
                    font.weight: Font.SemiBold
                    color: VLCDesignTokens.textPrimary
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: root.isExpanded ? "v" : ">"
                    font.pixelSize: VLCStyle.fontSize_small
                    font.weight: Font.Bold
                    color: VLCDesignTokens.textSecondary
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.isExpanded = !root.isExpanded
            }
        }

        // Expanded Content
        ColumnLayout {
            Layout.fillWidth: true
            visible: root.isExpanded
            spacing: VLCStyle.margin_small

            // Controls Toolbar: Enable, 2-Pass, and Reset
            RowLayout {
                Layout.fillWidth: true
                spacing: VLCStyle.margin_small

                // Master Enable Toggle
                Rectangle {
                    implicitWidth: enableRow.implicitWidth + VLCStyle.dp(16, VLCStyle.scale)
                    implicitHeight: VLCStyle.dp(26, VLCStyle.scale)
                    radius: VLCDesignTokens.radiusButton
                    color: root.isEnabled ? Qt.rgba(211/255, 121/255, 24/255, 0.2) : VLCDesignTokens.bgDark3
                    border.color: root.isEnabled ? VLCDesignTokens.accentOrange : VLCDesignTokens.borderSubtle
                    border.width: 1

                    RowLayout {
                        id: enableRow
                        anchors.centerIn: parent
                        spacing: VLCStyle.dp(6, VLCStyle.scale)

                        Rectangle {
                            width: VLCStyle.dp(8, VLCStyle.scale)
                            height: width
                            radius: width / 2
                            color: root.isEnabled ? VLCDesignTokens.accentOrange : VLCDesignTokens.textMuted
                        }

                        Text {
                            text: qsTr("Enable")
                            font.pixelSize: VLCStyle.fontSize_xxsmall
                            font.weight: Font.SemiBold
                            color: root.isEnabled ? VLCDesignTokens.textPrimary : VLCDesignTokens.textSecondary
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.isEnabled = !root.isEnabled
                    }
                }

                // 2-Pass Toggle
                Rectangle {
                    implicitWidth: passText.implicitWidth + VLCStyle.dp(16, VLCStyle.scale)
                    implicitHeight: VLCStyle.dp(26, VLCStyle.scale)
                    radius: VLCDesignTokens.radiusButton
                    color: root.is2Pass ? Qt.rgba(211/255, 121/255, 24/255, 0.2) : VLCDesignTokens.bgDark3
                    border.color: root.is2Pass ? VLCDesignTokens.accentOrange : VLCDesignTokens.borderSubtle
                    border.width: 1

                    Text {
                        id: passText
                        anchors.centerIn: parent
                        text: qsTr("2-Pass")
                        font.pixelSize: VLCStyle.fontSize_xxsmall
                        font.weight: Font.Medium
                        color: root.is2Pass ? VLCDesignTokens.textPrimary : VLCDesignTokens.textSecondary
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.is2Pass = !root.is2Pass
                    }
                }

                Item { Layout.fillWidth: true }

                // Reset Flat Button
                Rectangle {
                    implicitWidth: resetText.implicitWidth + VLCStyle.dp(16, VLCStyle.scale)
                    implicitHeight: VLCStyle.dp(26, VLCStyle.scale)
                    radius: VLCDesignTokens.radiusButton
                    color: resetHover.hovered ? VLCDesignTokens.bgDark3 : "transparent"
                    border.color: VLCDesignTokens.borderSubtle
                    border.width: 1

                    HoverHandler { id: resetHover }

                    Text {
                        id: resetText
                        anchors.centerIn: parent
                        text: qsTr("Flat")
                        font.pixelSize: VLCStyle.fontSize_xxsmall
                        font.weight: Font.Medium
                        color: VLCDesignTokens.textSecondary
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.resetFlat()
                    }
                }
            }

            // Preamp Slider
            Widgets.DSPSlider {
                Layout.fillWidth: true
                label: qsTr("Preamp")
                from: -20.0
                to: 20.0
                value: root.preampValue
                unit: "dB"
                onValueModified: (v) => root.preampValue = v
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: VLCDesignTokens.borderSubtle
            }

            // 10 Frequency Band Sliders (exact Figma layout)
            Repeater {
                model: root.bandLabels.length

                Widgets.DSPSlider {
                    Layout.fillWidth: true
                    label: root.bandLabels[index]
                    from: -20.0
                    to: 20.0
                    value: root.bandValues[index]
                    unit: "dB"
                    onValueModified: (v) => {
                        const copy = root.bandValues.slice()
                        copy[index] = v
                        root.bandValues = copy
                    }
                }
            }
        }
    }
}
