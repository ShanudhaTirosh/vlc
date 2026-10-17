/*****************************************************************************
 * Copyright (C) 2022 VLC authors and VideoLAN
 *
 * Authors: Benjamin Arnaud <bunjee@omega.gg>
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

import VLC.MainInterface
import VLC.Style
import VLC.Player
import VLC.Util
import VLC.Widgets as Widgets

TracksPage {
    id: root

    preferredWidth: VLCStyle.dp(480, VLCStyle.scale)

    ColumnLayout {
        anchors.fill: parent
        spacing: VLCStyle.margin_normal

        Widgets.SubtitleLabel {
            Layout.fillWidth: true
            text: qsTr("Subtitle Synchronization")
            color: VLCDesignTokens.textPrimary
            font.pixelSize: VLCStyle.fontSize_normal
            font.weight: Font.Bold
        }

        // ── Primary Subtitle Delay ───────────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: primarySyncCol.implicitHeight + VLCStyle.margin_normal * 2
            color: VLCDesignTokens.bgDark2
            radius: VLCDesignTokens.radiusCard
            border.color: VLCDesignTokens.borderSubtle
            border.width: 1

            DelayEstimator {
                id: delayEstimatorPrimary
                onDelayChanged: Player.addSubtitleDelay(delayEstimatorPrimary.delay)
            }

            ColumnLayout {
                id: primarySyncCol
                anchors.fill: parent
                anchors.margins: VLCStyle.margin_normal
                spacing: VLCStyle.margin_small

                Widgets.DSPSlider {
                    id: primarySlider
                    Layout.fillWidth: true
                    label: qsTr("Primary Subtitle Delay")
                    minValue: -10000
                    maxValue: 10000
                    stepSize: 50
                    value: Player.subtitleDelayMS
                    unit: " s"
                    valueMultiplier: 0.001
                    decimals: 3

                    onValueChanged: {
                        if (Player.subtitleDelayMS !== value)
                            Player.subtitleDelayMS = value
                    }

                    Connections {
                        target: Player
                        function onSubtitleDelayChanged() {
                            primarySlider.value = Player.subtitleDelayMS
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignRight
                    spacing: VLCStyle.margin_small

                    Rectangle {
                        Layout.preferredWidth: VLCStyle.dp(100, VLCStyle.scale)
                        Layout.preferredHeight: VLCStyle.dp(28, VLCStyle.scale)
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
                            onClicked: {
                                delayEstimatorPrimary.markHeardTime()
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: VLCStyle.dp(100, VLCStyle.scale)
                        Layout.preferredHeight: VLCStyle.dp(28, VLCStyle.scale)
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
                            onClicked: {
                                delayEstimatorPrimary.markSpottedTime()
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: VLCStyle.dp(60, VLCStyle.scale)
                        Layout.preferredHeight: VLCStyle.dp(28, VLCStyle.scale)
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

        // ── Secondary Subtitle Delay (if applicable) ─────────
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: secondarySyncCol.implicitHeight + VLCStyle.margin_normal * 2
            color: VLCDesignTokens.bgDark2
            radius: VLCDesignTokens.radiusCard
            border.color: VLCDesignTokens.borderSubtle
            border.width: 1

            DelayEstimator {
                id: delayEstimatorSecondary
                onDelayChanged: Player.addSecondarySubtitleDelay(delayEstimatorSecondary.delay)
            }

            ColumnLayout {
                id: secondarySyncCol
                anchors.fill: parent
                anchors.margins: VLCStyle.margin_normal
                spacing: VLCStyle.margin_small

                Widgets.DSPSlider {
                    id: secondarySlider
                    Layout.fillWidth: true
                    label: qsTr("Secondary Subtitle Delay")
                    minValue: -10000
                    maxValue: 10000
                    stepSize: 50
                    value: Player.secondarySubtitleDelayMS
                    unit: " s"
                    valueMultiplier: 0.001
                    decimals: 3

                    onValueChanged: {
                        if (Player.secondarySubtitleDelayMS !== value)
                            Player.secondarySubtitleDelayMS = value
                    }

                    Connections {
                        target: Player
                        function onSecondarySubtitleDelayChanged() {
                            secondarySlider.value = Player.secondarySubtitleDelayMS
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignRight
                    spacing: VLCStyle.margin_small

                    Rectangle {
                        Layout.preferredWidth: VLCStyle.dp(100, VLCStyle.scale)
                        Layout.preferredHeight: VLCStyle.dp(28, VLCStyle.scale)
                        radius: VLCDesignTokens.radiusButton
                        color: delayEstimatorSecondary.isHeardTimeMarked ? VLCDesignTokens.primaryOrange : VLCDesignTokens.bgDark3
                        border.color: VLCDesignTokens.borderMedium
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Voice Heard")
                            font.pixelSize: VLCStyle.fontSize_small
                            font.weight: Font.DemiBold
                            color: delayEstimatorSecondary.isHeardTimeMarked ? "#FFFFFF" : VLCDesignTokens.textPrimary
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: delayEstimatorSecondary.markHeardTime()
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: VLCStyle.dp(100, VLCStyle.scale)
                        Layout.preferredHeight: VLCStyle.dp(28, VLCStyle.scale)
                        radius: VLCDesignTokens.radiusButton
                        color: delayEstimatorSecondary.isSpottedTimeMarked ? VLCDesignTokens.primaryOrange : VLCDesignTokens.bgDark3
                        border.color: VLCDesignTokens.borderMedium
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Text Seen")
                            font.pixelSize: VLCStyle.fontSize_small
                            font.weight: Font.DemiBold
                            color: delayEstimatorSecondary.isSpottedTimeMarked ? "#FFFFFF" : VLCDesignTokens.textPrimary
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: delayEstimatorSecondary.markSpottedTime()
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: VLCStyle.dp(60, VLCStyle.scale)
                        Layout.preferredHeight: VLCStyle.dp(28, VLCStyle.scale)
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
                                Player.secondarySubtitleDelayMS = 0
                                delayEstimatorSecondary.reset()
                            }
                        }
                    }
                }
            }
        }

        // ── Subtitle Speed (fps) ─────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: speedCol.implicitHeight + VLCStyle.margin_normal * 2
            color: VLCDesignTokens.bgDark2
            radius: VLCDesignTokens.radiusCard
            border.color: VLCDesignTokens.borderSubtle
            border.width: 1

            ColumnLayout {
                id: speedCol
                anchors.fill: parent
                anchors.margins: VLCStyle.margin_normal
                spacing: VLCStyle.margin_small

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
                        if (Math.abs(Player.subtitleFPS - fpsVal) > 0.01)
                            Player.subtitleFPS = fpsVal
                    }
                }
            }
        }
    }
}
