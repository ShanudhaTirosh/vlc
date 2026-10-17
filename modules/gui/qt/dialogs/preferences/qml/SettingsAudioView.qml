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
import QtQuick.Controls

import VLC.Style

Flickable {
    id: root

    contentWidth: width
    contentHeight: mainCol.implicitHeight + VLCStyle.margin_xlarge * 2
    clip: true

    ColumnLayout {
        id: mainCol
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: VLCStyle.margin_large
        spacing: VLCStyle.margin_xlarge

        // ═══════════════════════════════════════════════════
        // 1. OUTPUT
        // ═══════════════════════════════════════════════════
        ColumnLayout {
            Layout.fillWidth: true
            spacing: VLCStyle.margin_normal

            Text {
                text: qsTr("Output")
                font.pixelSize: VLCStyle.fontSize_normal
                font.weight: Font.Bold
                color: VLCDesignTokens.textPrimary
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Enable audio")
                SettingsToggle { checked: true }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Output device")
                SettingsComboBox {
                    model: [qsTr("System default"), qsTr("Default Audio Output"), qsTr("Speakers (Realtek)"), qsTr("Digital Audio (S/PDIF)")]
                    currentIndex: 0
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Speaker setup")
                SettingsComboBox {
                    model: [qsTr("Automatic"), qsTr("Stereo"), qsTr("5.1 Surround"), qsTr("7.1 Surround"), qsTr("Headphones")]
                    currentIndex: 0
                }
            }
        }

        // ═══════════════════════════════════════════════════
        // 2. VOLUME
        // ═══════════════════════════════════════════════════
        ColumnLayout {
            Layout.fillWidth: true
            spacing: VLCStyle.margin_normal

            Text {
                text: qsTr("Volume")
                font.pixelSize: VLCStyle.fontSize_normal
                font.weight: Font.Bold
                color: VLCDesignTokens.textPrimary
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Maximum volume")
                SettingsSlider {
                    minValue: 100
                    maxValue: 300
                    value: 200
                    minLabel: "100%"
                    midLabel: "200%"
                    maxLabel: "300%"
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Startup volume")
                SettingsSegmentedButton {
                    options: [qsTr("Remember last volume"), qsTr("Always starts at: 200%")]
                    currentIndex: 0
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Volume step")

                Rectangle {
                    width: VLCStyle.dp(280, VLCStyle.scale)
                    height: VLCStyle.dp(34, VLCStyle.scale)
                    radius: VLCDesignTokens.radiusButton
                    color: VLCDesignTokens.bgDark0
                    border.color: VLCDesignTokens.borderMedium
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: VLCStyle.margin_normal
                        anchors.rightMargin: VLCStyle.margin_normal

                        Text {
                            text: "1"
                            font.pixelSize: VLCStyle.fontSize_small
                            color: VLCDesignTokens.textPrimary
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }

        // ═══════════════════════════════════════════════════
        // 3. LOUDNESS
        // ═══════════════════════════════════════════════════
        ColumnLayout {
            Layout.fillWidth: true
            spacing: VLCStyle.margin_normal

            Text {
                text: qsTr("Loudness")
                font.pixelSize: VLCStyle.fontSize_normal
                font.weight: Font.Bold
                color: VLCDesignTokens.textPrimary
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Normalize loudness")
                SettingsToggle { checked: false }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Target level")

                Rectangle {
                    width: VLCStyle.dp(280, VLCStyle.scale)
                    height: VLCStyle.dp(34, VLCStyle.scale)
                    radius: VLCDesignTokens.radiusButton
                    color: VLCDesignTokens.bgDark0
                    border.color: VLCDesignTokens.borderMedium
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: VLCStyle.margin_normal
                        anchors.rightMargin: VLCStyle.margin_normal

                        Text {
                            text: "1"
                            font.pixelSize: VLCStyle.fontSize_small
                            color: VLCDesignTokens.textPrimary
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Night mode")
                SettingsToggle { checked: false }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Replay gain")
                SettingsComboBox {
                    model: [qsTr("Off"), qsTr("Track"), qsTr("Album")]
                    currentIndex: 0
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Replay gain preamp")

                Rectangle {
                    width: VLCStyle.dp(280, VLCStyle.scale)
                    height: VLCStyle.dp(34, VLCStyle.scale)
                    radius: VLCDesignTokens.radiusButton
                    color: VLCDesignTokens.bgDark0
                    border.color: VLCDesignTokens.borderMedium
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: VLCStyle.margin_normal
                        anchors.rightMargin: VLCStyle.margin_normal

                        Text {
                            text: "0.0"
                            font.pixelSize: VLCStyle.fontSize_small
                            color: VLCDesignTokens.textPrimary
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }
    }
}
