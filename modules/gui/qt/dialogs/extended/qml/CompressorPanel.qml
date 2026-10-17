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

    property real rmsPeak: 0.2
    property real attack: 25.0
    property real release: 100.0
    property real threshold: -11.0
    property real ratio: 4.0
    property real kneeRadius: 5.0
    property real makeupGain: 7.0

    function resetDefaults() {
        rmsPeak = 0.2
        attack = 25.0
        release = 100.0
        threshold = -11.0
        ratio = 4.0
        kneeRadius = 5.0
        makeupGain = 7.0
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

            // Controls Toolbar: Enable and Reset
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

                Item { Layout.fillWidth: true }

                // Reset Button
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
                        text: qsTr("Reset")
                        font.pixelSize: VLCStyle.fontSize_xxsmall
                        font.weight: Font.Medium
                        color: VLCDesignTokens.textSecondary
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.resetDefaults()
                    }
                }
            }

            // 7 Compressor Parameter Sliders (Exact Figma community design)
            Widgets.DSPSlider {
                Layout.fillWidth: true
                label: qsTr("RMS / Peak")
                from: 0.0
                to: 1.0
                value: root.rmsPeak
                stepSize: 0.01
                unit: ""
                decimals: 2
                onValueModified: (v) => root.rmsPeak = v
            }

            Widgets.DSPSlider {
                Layout.fillWidth: true
                label: qsTr("Attack")
                from: 1.5
                to: 400.0
                value: root.attack
                stepSize: 0.5
                unit: "ms"
                decimals: 1
                onValueModified: (v) => root.attack = v
            }

            Widgets.DSPSlider {
                Layout.fillWidth: true
                label: qsTr("Release")
                from: 2.0
                to: 800.0
                value: root.release
                stepSize: 1.0
                unit: "ms"
                decimals: 1
                onValueModified: (v) => root.release = v
            }

            Widgets.DSPSlider {
                Layout.fillWidth: true
                label: qsTr("Threshold")
                from: -30.0
                to: 0.0
                value: root.threshold
                stepSize: 0.5
                unit: "dB"
                decimals: 1
                onValueModified: (v) => root.threshold = v
            }

            Widgets.DSPSlider {
                Layout.fillWidth: true
                label: qsTr("Ratio")
                from: 1.0
                to: 20.0
                value: root.ratio
                stepSize: 0.1
                unit: ": 1"
                decimals: 1
                onValueModified: (v) => root.ratio = v
            }

            Widgets.DSPSlider {
                Layout.fillWidth: true
                label: qsTr("Knee Radius")
                from: 1.0
                to: 10.0
                value: root.kneeRadius
                stepSize: 0.1
                unit: "dB"
                decimals: 1
                onValueModified: (v) => root.kneeRadius = v
            }

            Widgets.DSPSlider {
                Layout.fillWidth: true
                label: qsTr("Makeup Gain")
                from: 0.0
                to: 24.0
                value: root.makeupGain
                stepSize: 0.5
                unit: "dB"
                decimals: 1
                onValueModified: (v) => root.makeupGain = v
            }
        }
    }
}
