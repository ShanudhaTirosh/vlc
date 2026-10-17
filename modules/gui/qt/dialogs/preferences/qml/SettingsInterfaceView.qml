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
import VLC.Dialogs

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
        // 1. SKIN
        // ═══════════════════════════════════════════════════
        ColumnLayout {
            Layout.fillWidth: true
            spacing: VLCStyle.margin_normal

            Text {
                text: qsTr("Skin")
                font.pixelSize: VLCStyle.fontSize_normal
                font.weight: Font.Bold
                color: VLCDesignTokens.textPrimary
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Use a custom skin")
                SettingsToggle { checked: false }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Skin file")

                RowLayout {
                    spacing: VLCStyle.margin_small

                    Rectangle {
                        width: VLCStyle.dp(200, VLCStyle.scale)
                        height: VLCStyle.dp(34, VLCStyle.scale)
                        radius: VLCDesignTokens.radiusButton
                        color: VLCDesignTokens.bgDark0
                        border.color: VLCDesignTokens.borderMedium
                        border.width: 1
                    }

                    Rectangle {
                        width: VLCStyle.dp(72, VLCStyle.scale)
                        height: VLCStyle.dp(34, VLCStyle.scale)
                        radius: VLCDesignTokens.radiusButton
                        color: VLCDesignTokens.bgDark2
                        border.color: VLCDesignTokens.borderMedium
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Browse")
                            font.pixelSize: VLCStyle.fontSize_small
                            color: VLCDesignTokens.textPrimary
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: DialogsProvider.showSimpleOpen()
                        }
                    }
                }
            }
        }

        // ═══════════════════════════════════════════════════
        // 2. WINDOW
        // ═══════════════════════════════════════════════════
        ColumnLayout {
            Layout.fillWidth: true
            spacing: VLCStyle.margin_normal

            Text {
                text: qsTr("Window")
                font.pixelSize: VLCStyle.fontSize_normal
                font.weight: Font.Bold
                color: VLCDesignTokens.textPrimary
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Play video inside main window")
                SettingsToggle { checked: true }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Resize window to fit video")
                SettingsComboBox {
                    model: [qsTr("Never"), qsTr("Always"), qsTr("Only when larger")]
                    currentIndex: 0
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Remember window size and position")
                SettingsToggle { checked: true }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Keep window above other windows")
                SettingsToggle { checked: false }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Show window decorations")
                SettingsToggle { checked: true }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Show the file name in the title bar")
                SettingsToggle { checked: true }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Open fullscreen on")
                SettingsComboBox {
                    model: [qsTr("Current screen"), qsTr("Primary screen"), qsTr("Screen 1"), qsTr("Screen 2")]
                    currentIndex: 0
                }
            }
        }

        // ═══════════════════════════════════════════════════
        // 3. PLAYBACK CONTROLS
        // ═══════════════════════════════════════════════════
        ColumnLayout {
            Layout.fillWidth: true
            spacing: VLCStyle.margin_normal

            Text {
                text: qsTr("Playback Controls")
                font.pixelSize: VLCStyle.fontSize_normal
                font.weight: Font.Bold
                color: VLCDesignTokens.textPrimary
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Start in compact mode")
                SettingsToggle { checked: false }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Auto-hide the controls")
                SettingsComboBox {
                    model: [qsTr("In fullscreen only"), qsTr("Always"), qsTr("Never")]
                    currentIndex: 0
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Hide after")
                SettingsSlider {
                    minValue: 0
                    maxValue: 10
                    value: 2
                    minLabel: "0 s"
                    midLabel: "5 s"
                    maxLabel: "10 s"
                }
            }

            SettingsRow {
                Layout.fillWidth: true
                label: qsTr("Show controls in fullscreen")
                SettingsToggle { checked: true }
            }
        }
    }
}
