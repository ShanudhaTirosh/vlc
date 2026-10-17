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
import VLC.Player
import VLC.Dialogs

Item {
    id: root

    implicitWidth: VLCStyle.dp(380, VLCStyle.scale)
    implicitHeight: mainColumn.implicitHeight + VLCStyle.margin_large * 2

    // Custom Delay Estimator
    DelayEstimator {
        id: delayEstimatorPrimary
        onDelayChanged: Player.addSubtitleDelay(delayEstimatorPrimary.delay)
    }

    ColumnLayout {
        id: mainColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: VLCStyle.margin_normal
        spacing: VLCStyle.margin_normal

        // ═══════════════════════════════════════════════════
        // 1. DEFAULTS SECTION
        // ═══════════════════════════════════════════════════
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: defaultsCol.implicitHeight + VLCStyle.margin_normal * 2
            color: VLCDesignTokens.bgDark2
            radius: VLCDesignTokens.radiusCard
            border.color: VLCDesignTokens.borderSubtle
            border.width: 1

            ColumnLayout {
                id: defaultsCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: VLCStyle.margin_normal
                spacing: VLCStyle.margin_small

                Text {
                    text: qsTr("Defaults")
                    font.pixelSize: VLCStyle.fontSize_normal
                    font.weight: Font.Bold
                    color: VLCDesignTokens.textPrimary
                }

                // Subtitle Track
                RowLayout {
                    Layout.fillWidth: true
                    spacing: VLCStyle.margin_small

                    Text {
                        text: qsTr("Subtitle Track")
                        font.pixelSize: VLCStyle.fontSize_small
                        color: VLCDesignTokens.textSecondary
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.preferredWidth: VLCStyle.dp(160, VLCStyle.scale)
                        Layout.preferredHeight: VLCStyle.dp(32, VLCStyle.scale)
                        color: VLCDesignTokens.bgDark0
                        radius: VLCDesignTokens.radiusButton
                        border.color: VLCDesignTokens.borderMedium
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: VLCStyle.margin_small
                            anchors.rightMargin: VLCStyle.margin_small

                            Text {
                                text: Player.subtitleTracks.count > 0 ? (Player.currentSubtitleTrack >= 0 ? (Player.currentSubtitleTrack + 1).toString() : qsTr("Disable")) : qsTr("1")
                                font.pixelSize: VLCStyle.fontSize_small
                                color: VLCDesignTokens.textPrimary
                                Layout.fillWidth: true
                            }

                            Text {
                                text: "▼"
                                font.pixelSize: VLCStyle.dp(10, VLCStyle.scale)
                                color: VLCDesignTokens.textMuted
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (Player.subtitleTracks.count > 0) {
                                    // Cycle subtitle track
                                    var nextTrack = (Player.currentSubtitleTrack + 1) % (Player.subtitleTracks.count + 1)
                                    Player.currentSubtitleTrack = nextTrack === Player.subtitleTracks.count ? -1 : nextTrack
                                }
                            }
                        }
                    }
                }

                // Subtitle Language
                RowLayout {
                    Layout.fillWidth: true
                    spacing: VLCStyle.margin_small

                    Text {
                        text: qsTr("Subtitle Language")
                        font.pixelSize: VLCStyle.fontSize_small
                        color: VLCDesignTokens.textSecondary
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.preferredWidth: VLCStyle.dp(160, VLCStyle.scale)
                        Layout.preferredHeight: VLCStyle.dp(32, VLCStyle.scale)
                        color: VLCDesignTokens.bgDark0
                        radius: VLCDesignTokens.radiusButton
                        border.color: VLCDesignTokens.borderMedium
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: VLCStyle.margin_small
                            anchors.rightMargin: VLCStyle.margin_small

                            Text {
                                text: qsTr("English")
                                font.pixelSize: VLCStyle.fontSize_small
                                color: VLCDesignTokens.textPrimary
                                Layout.fillWidth: true
                            }

                            Text {
                                text: "▼"
                                font.pixelSize: VLCStyle.dp(10, VLCStyle.scale)
                                color: VLCDesignTokens.textMuted
                            }
                        }
                    }
                }
            }
        }

        // ═══════════════════════════════════════════════════
        // 2. SYNCHRONIZATION SECTION
        // ═══════════════════════════════════════════════════
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: syncCol.implicitHeight + VLCStyle.margin_normal * 2
            color: VLCDesignTokens.bgDark2
            radius: VLCDesignTokens.radiusCard
            border.color: VLCDesignTokens.borderSubtle
            border.width: 1

            ColumnLayout {
                id: syncCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: VLCStyle.margin_normal
                spacing: VLCStyle.margin_normal

                Text {
                    text: qsTr("Synchronization")
                    font.pixelSize: VLCStyle.fontSize_normal
                    font.weight: Font.Bold
                    color: VLCDesignTokens.textPrimary
                }

                // Subtitle Track Delay Slider (-10s to +10s)
                Widgets.DSPSlider {
                    Layout.fillWidth: true
                    label: qsTr("Subtitle Track Delay")
                    minValue: -10000
                    maxValue: 10000
                    stepSize: 50
                    value: Player.subtitleDelayMS
                    unit: " s"
                    valueMultiplier: 0.001
                    decimals: 3

                    onValueChanged: {
                        if (Player.subtitleDelayMS !== value) {
                            Player.subtitleDelayMS = value
                        }
                    }

                    Connections {
                        target: Player
                        function onSubtitleDelayChanged() {
                            value = Player.subtitleDelayMS
                        }
                    }
                }

                // Subtitle Speed (fps)
                Widgets.DSPSlider {
                    Layout.fillWidth: true
                    label: qsTr("Subtitle Speed")
                    minValue: 0
                    maxValue: 600
                    stepSize: 5
                    value: Math.round(Player.subtitleFPS * 10)
                    unit: " fps"
                    valueMultiplier: 0.1
                    decimals: 3

                    onValueChanged: {
                        var fpsVal = value * 0.1
                        if (Math.abs(Player.subtitleFPS - fpsVal) > 0.01) {
                            Player.subtitleFPS = fpsVal
                        }
                    }
                }

                // Subtitle Duration Factor
                Widgets.DSPSlider {
                    Layout.fillWidth: true
                    label: qsTr("Subtitle Duration Factor")
                    minValue: 0
                    maxValue: 500
                    stepSize: 1
                    value: 0
                    unit: ""
                    valueMultiplier: 0.01
                    decimals: 3
                }

                // Voice Heard / Text Seen Estimator Controls
                RowLayout {
                    Layout.fillWidth: true
                    spacing: VLCStyle.margin_small

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: VLCStyle.dp(32, VLCStyle.scale)
                        radius: VLCDesignTokens.radiusButton
                        color: delayEstimatorPrimary.isHeardTimeMarked ? VLCDesignTokens.primaryOrange : VLCDesignTokens.bgDark3
                        border.color: VLCDesignTokens.borderMedium
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Voice Heard")
                            font.pixelSize: VLCStyle.fontSize_small
                            font.weight: Font.DemiBold
                            color: delayEstimatorPrimary.isHeardTimeMarked ? "#FFFFFF" : VLCDesignTokens.textPrimary
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: delayEstimatorPrimary.markHeardTime()
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: VLCStyle.dp(32, VLCStyle.scale)
                        radius: VLCDesignTokens.radiusButton
                        color: delayEstimatorPrimary.isSpottedTimeMarked ? VLCDesignTokens.primaryOrange : VLCDesignTokens.bgDark3
                        border.color: VLCDesignTokens.borderMedium
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Text Seen")
                            font.pixelSize: VLCStyle.fontSize_small
                            font.weight: Font.DemiBold
                            color: delayEstimatorPrimary.isSpottedTimeMarked ? "#FFFFFF" : VLCDesignTokens.textPrimary
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: delayEstimatorPrimary.markSpottedTime()
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: VLCStyle.dp(64, VLCStyle.scale)
                        Layout.preferredHeight: VLCStyle.dp(32, VLCStyle.scale)
                        radius: VLCDesignTokens.radiusButton
                        color: VLCDesignTokens.bgDark3
                        border.color: VLCDesignTokens.borderMedium
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Reset")
                            font.pixelSize: VLCStyle.fontSize_small
                            color: VLCDesignTokens.textSecondary
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Player.subtitleDelayMS = 0
                                delayEstimatorPrimary.reset()
                            }
                        }
                    }
                }
            }
        }

        // ═══════════════════════════════════════════════════
        // 3. APPEARANCE SECTION
        // ═══════════════════════════════════════════════════
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: appearanceCol.implicitHeight + VLCStyle.margin_normal * 2
            color: VLCDesignTokens.bgDark2
            radius: VLCDesignTokens.radiusCard
            border.color: VLCDesignTokens.borderSubtle
            border.width: 1

            ColumnLayout {
                id: appearanceCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: VLCStyle.margin_normal
                spacing: VLCStyle.margin_normal

                Text {
                    text: qsTr("Appearance")
                    font.pixelSize: VLCStyle.fontSize_normal
                    font.weight: Font.Bold
                    color: VLCDesignTokens.textPrimary
                }

                // Embedded Sub Format (Toggle)
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: qsTr("Embedded Sub Format")
                        font.pixelSize: VLCStyle.fontSize_small
                        color: VLCDesignTokens.textSecondary
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        id: subFormatToggle
                        property bool checked: false
                        Layout.preferredWidth: VLCStyle.dp(56, VLCStyle.scale)
                        Layout.preferredHeight: VLCStyle.dp(26, VLCStyle.scale)
                        radius: VLCDesignTokens.radiusButton
                        color: checked ? VLCDesignTokens.primaryOrange : VLCDesignTokens.bgDark0
                        border.color: checked ? VLCDesignTokens.primaryOrange : VLCDesignTokens.borderMedium
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: subFormatToggle.checked ? qsTr("ON") : qsTr("OFF")
                            font.pixelSize: VLCStyle.dp(10, VLCStyle.scale)
                            font.weight: Font.Bold
                            color: subFormatToggle.checked ? "#FFFFFF" : VLCDesignTokens.textMuted
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: subFormatToggle.checked = !subFormatToggle.checked
                        }
                    }
                }

                // Subtitle Font
                RowLayout {
                    Layout.fillWidth: true
                    spacing: VLCStyle.margin_small

                    Text {
                        text: qsTr("Subtitle Font")
                        font.pixelSize: VLCStyle.fontSize_small
                        color: VLCDesignTokens.textSecondary
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.preferredWidth: VLCStyle.dp(160, VLCStyle.scale)
                        Layout.preferredHeight: VLCStyle.dp(32, VLCStyle.scale)
                        color: VLCDesignTokens.bgDark0
                        radius: VLCDesignTokens.radiusButton
                        border.color: VLCDesignTokens.borderMedium
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: VLCStyle.margin_small
                            anchors.rightMargin: VLCStyle.margin_small

                            Text {
                                text: qsTr("Inter")
                                font.pixelSize: VLCStyle.fontSize_small
                                color: VLCDesignTokens.textPrimary
                                Layout.fillWidth: true
                            }

                            Text {
                                text: "▼"
                                font.pixelSize: VLCStyle.dp(10, VLCStyle.scale)
                                color: VLCDesignTokens.textMuted
                            }
                        }
                    }
                }

                // Text Color
                RowLayout {
                    Layout.fillWidth: true
                    spacing: VLCStyle.margin_small

                    Text {
                        text: qsTr("Text Color")
                        font.pixelSize: VLCStyle.fontSize_small
                        color: VLCDesignTokens.textSecondary
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.preferredWidth: VLCStyle.dp(160, VLCStyle.scale)
                        Layout.preferredHeight: VLCStyle.dp(32, VLCStyle.scale)
                        color: VLCDesignTokens.bgDark0
                        radius: VLCDesignTokens.radiusButton
                        border.color: VLCDesignTokens.borderMedium
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: VLCStyle.margin_small
                            anchors.rightMargin: VLCStyle.margin_small

                            Text {
                                text: "#B8B8B8"
                                font.pixelSize: VLCStyle.fontSize_small
                                font.family: "Monospace"
                                color: VLCDesignTokens.textPrimary
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                Layout.preferredWidth: VLCStyle.dp(18, VLCStyle.scale)
                                Layout.preferredHeight: VLCStyle.dp(18, VLCStyle.scale)
                                radius: 2
                                color: "#B8B8B8"
                                border.color: VLCDesignTokens.borderSubtle
                                border.width: 1
                            }
                        }
                    }
                }

                // Outline Color
                RowLayout {
                    Layout.fillWidth: true
                    spacing: VLCStyle.margin_small

                    Text {
                        text: qsTr("Outline Color")
                        font.pixelSize: VLCStyle.fontSize_small
                        color: VLCDesignTokens.textSecondary
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.preferredWidth: VLCStyle.dp(160, VLCStyle.scale)
                        Layout.preferredHeight: VLCStyle.dp(32, VLCStyle.scale)
                        color: VLCDesignTokens.bgDark0
                        radius: VLCDesignTokens.radiusButton
                        border.color: VLCDesignTokens.borderMedium
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: VLCStyle.margin_small
                            anchors.rightMargin: VLCStyle.margin_small

                            Text {
                                text: "#0C0C0C"
                                font.pixelSize: VLCStyle.fontSize_small
                                font.family: "Monospace"
                                color: VLCDesignTokens.textPrimary
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                Layout.preferredWidth: VLCStyle.dp(18, VLCStyle.scale)
                                Layout.preferredHeight: VLCStyle.dp(18, VLCStyle.scale)
                                radius: 2
                                color: "#0C0C0C"
                                border.color: VLCDesignTokens.borderSubtle
                                border.width: 1
                            }
                        }
                    }
                }
            }
        }

        // ═══════════════════════════════════════════════════
        // 4. PRESETS ACCORDION
        // ═══════════════════════════════════════════════════
        Rectangle {
            id: presetAccordion
            property bool expanded: false
            Layout.fillWidth: true
            Layout.preferredHeight: expanded ? VLCStyle.dp(110, VLCStyle.scale) : VLCStyle.dp(44, VLCStyle.scale)
            color: VLCDesignTokens.bgDark2
            radius: VLCDesignTokens.radiusCard
            border.color: VLCDesignTokens.borderSubtle
            border.width: 1
            clip: true

            Behavior on Layout.preferredHeight {
                NumberAnimation { duration: VLCStyle.duration_short; easing.type: Easing.InOutQuad }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: VLCStyle.margin_normal
                spacing: VLCStyle.margin_small

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: qsTr("Default Preset")
                        font.pixelSize: VLCStyle.fontSize_normal
                        font.weight: Font.DemiBold
                        color: VLCDesignTokens.textPrimary
                        Layout.fillWidth: true
                    }

                    Text {
                        text: presetAccordion.expanded ? "▲" : "▼"
                        font.pixelSize: VLCStyle.dp(11, VLCStyle.scale)
                        color: VLCDesignTokens.textSecondary
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    visible: presetAccordion.expanded
                    spacing: VLCStyle.margin_small

                    Repeater {
                        model: [qsTr("Default"), qsTr("High Contrast"), qsTr("Yellow"), qsTr("SubRip")]
                        delegate: Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: VLCStyle.dp(30, VLCStyle.scale)
                            radius: VLCDesignTokens.radiusButton
                            color: index === 0 ? VLCDesignTokens.primaryOrange : VLCDesignTokens.bgDark0
                            border.color: VLCDesignTokens.borderMedium
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                font.pixelSize: VLCStyle.dp(11, VLCStyle.scale)
                                color: index === 0 ? "#FFFFFF" : VLCDesignTokens.textSecondary
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }
                }
            }

            MouseArea {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: VLCStyle.dp(44, VLCStyle.scale)
                cursorShape: Qt.PointingHandCursor
                onClicked: presetAccordion.expanded = !presetAccordion.expanded
            }
        }

        // ═══════════════════════════════════════════════════
        // 5. OPEN ADVANCED SETTINGS BUTTON
        // ═══════════════════════════════════════════════════
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: VLCStyle.dp(44, VLCStyle.scale)
            color: "transparent"
            radius: VLCDesignTokens.radiusButton

            RowLayout {
                anchors.centerIn: parent
                spacing: VLCStyle.margin_small

                Text {
                    text: "⚙"
                    font.pixelSize: VLCStyle.fontSize_normal
                    color: VLCDesignTokens.textSecondary
                }

                Text {
                    text: qsTr("Open Advanced Settings")
                    font.pixelSize: VLCStyle.fontSize_small
                    font.weight: Font.DemiBold
                    color: VLCDesignTokens.textSecondary
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: parent.color = VLCDesignTokens.bgDark2
                onExited: parent.color = "transparent"
                onClicked: DialogsProvider.prefsDialog()
            }
        }
    }
}
