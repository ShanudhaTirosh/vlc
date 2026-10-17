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
        // 1. TRACKS & LANGUAGES
        // ═══════════════════════════════════════════════════
        ColumnLayout {
            Layout.fillWidth: true
            spacing: VLCStyle.margin_normal

            Text {
                text: qsTr("Tracks & Languages")
                font.pixelSize: VLCStyle.fontSize_normal
                font.weight: Font.Bold
                color: VLCDesignTokens.textPrimary
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Enable subtitles")
                SettingsToggle { checked: true }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Preferred language")
                SettingsComboBox {
                    model: [qsTr("System language"), qsTr("English"), qsTr("French"), qsTr("German"), qsTr("Spanish"), qsTr("Japanese")]
                    currentIndex: 0
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Text encoding")
                SettingsComboBox {
                    model: [qsTr("Automatic"), qsTr("UTF-8"), qsTr("ISO-8859-1"), qsTr("Windows-1252")]
                    currentIndex: 0
                }
            }
        }

        // ═══════════════════════════════════════════════════
        // 2. LOADING SUBTITLES
        // ═══════════════════════════════════════════════════
        ColumnLayout {
            Layout.fillWidth: true
            spacing: VLCStyle.margin_normal

            Text {
                text: qsTr("Loading Subtitles")
                font.pixelSize: VLCStyle.fontSize_normal
                font.weight: Font.Bold
                color: VLCDesignTokens.textPrimary
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Load subtitle files automatically")
                SettingsToggle { checked: true }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("File name matching")
                SettingsComboBox {
                    model: [qsTr("Title with extra characters"), qsTr("Exact match"), qsTr("Fuzzy match"), qsTr("All subtitles")]
                    currentIndex: 0
                }
            }
        }

        // ═══════════════════════════════════════════════════
        // 3. APPEARANCE
        // ═══════════════════════════════════════════════════
        ColumnLayout {
            Layout.fillWidth: true
            spacing: VLCStyle.margin_normal

            Text {
                text: qsTr("Appearance")
                font.pixelSize: VLCStyle.fontSize_normal
                font.weight: Font.Bold
                color: VLCDesignTokens.textPrimary
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Font")
                SettingsComboBox {
                    model: [qsTr("System, sans-serif"), qsTr("Inter"), qsTr("Roboto"), qsTr("Arial"), qsTr("Monospace")]
                    currentIndex: 0
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Size values")
                SettingsSegmentedButton {
                    options: [qsTr("Relative"), qsTr("Pixels")]
                    currentIndex: 0
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Font size")
                SettingsComboBox {
                    model: [qsTr("Automatic"), qsTr("Smaller"), qsTr("Small"), qsTr("Normal"), qsTr("Large"), qsTr("Larger")]
                    currentIndex: 0
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Bold")
                SettingsToggle { checked: false }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Text color")

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
                            text: "#FFFFFF"
                            font.pixelSize: VLCStyle.fontSize_small
                            font.family: "Monospace"
                            color: VLCDesignTokens.textPrimary
                            Layout.fillWidth: true
                        }

                        Rectangle {
                            width: VLCStyle.dp(18, VLCStyle.scale)
                            height: VLCStyle.dp(18, VLCStyle.scale)
                            radius: 2
                            color: "#FFFFFF"
                            border.color: VLCDesignTokens.borderSubtle
                            border.width: 1
                        }
                    }
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Text opacity")
                SettingsSlider {
                    value: 50
                    minLabel: "0%"
                    midLabel: "50%"
                    maxLabel: "100%"
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Outline thickness")
                SettingsComboBox {
                    model: [qsTr("None"), qsTr("Thin"), qsTr("Normal"), qsTr("Thick")]
                    currentIndex: 2
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Outline color")

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
                            text: "#000000"
                            font.pixelSize: VLCStyle.fontSize_small
                            font.family: "Monospace"
                            color: VLCDesignTokens.textPrimary
                            Layout.fillWidth: true
                        }

                        Rectangle {
                            width: VLCStyle.dp(18, VLCStyle.scale)
                            height: VLCStyle.dp(18, VLCStyle.scale)
                            radius: 2
                            color: "#000000"
                            border.color: VLCDesignTokens.borderSubtle
                            border.width: 1
                        }
                    }
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Shadow")
                SettingsToggle { checked: true }
            }
        }
    }
}
