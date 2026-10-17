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
    implicitHeight: mainColumn.implicitHeight + VLCStyle.margin_large * 2

    property int subTab: 0 // 0: Essential, 1: Crop, 2: Colors

    ColumnLayout {
        id: mainColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: VLCStyle.margin_normal
        spacing: VLCStyle.margin_normal

        // ═══════════════════════════════════════════════════
        // SUB-TAB SELECTOR (Essential / Crop / Colors)
        // ═══════════════════════════════════════════════════
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: VLCStyle.dp(34, VLCStyle.scale)
            color: VLCDesignTokens.bgDark0
            radius: VLCDesignTokens.radiusButton
            border.color: VLCDesignTokens.borderMedium
            border.width: 1

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Repeater {
                    model: [qsTr("Essential"), qsTr("Crop"), qsTr("Colors")]
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: VLCDesignTokens.radiusButton
                        color: root.subTab === index ? VLCDesignTokens.primaryOrange : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            font.pixelSize: VLCStyle.fontSize_small
                            font.weight: root.subTab === index ? Font.Bold : Font.Normal
                            color: root.subTab === index ? "#FFFFFF" : VLCDesignTokens.textSecondary
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.subTab = index
                        }
                    }
                }
            }
        }

        // ═══════════════════════════════════════════════════
        // 1. ESSENTIAL TAB (Hue, Brightness, Contrast, etc.)
        // ═══════════════════════════════════════════════════
        ColumnLayout {
            Layout.fillWidth: true
            visible: root.subTab === 0
            spacing: VLCStyle.margin_normal

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: essentialCol.implicitHeight + VLCStyle.margin_normal * 2
                color: VLCDesignTokens.bgDark2
                radius: VLCDesignTokens.radiusCard
                border.color: VLCDesignTokens.borderSubtle
                border.width: 1

                ColumnLayout {
                    id: essentialCol
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: VLCStyle.margin_normal
                    spacing: VLCStyle.margin_normal

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: qsTr("Picture Adjustments")
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
                        label: qsTr("Hue")
                        minValue: -180
                        maxValue: 180
                        stepSize: 1
                        value: 0
                        unit: "°"
                    }

                    Widgets.DSPSlider {
                        Layout.fillWidth: true
                        label: qsTr("Brightness")
                        minValue: 0
                        maxValue: 200
                        stepSize: 1
                        value: 100
                        unit: "%"
                    }

                    Widgets.DSPSlider {
                        Layout.fillWidth: true
                        label: qsTr("Contrast")
                        minValue: 0
                        maxValue: 200
                        stepSize: 1
                        value: 100
                        unit: "%"
                    }

                    Widgets.DSPSlider {
                        Layout.fillWidth: true
                        label: qsTr("Saturation")
                        minValue: 0
                        maxValue: 200
                        stepSize: 1
                        value: 100
                        unit: "%"
                    }

                    Widgets.DSPSlider {
                        Layout.fillWidth: true
                        label: qsTr("Gamma")
                        minValue: 1
                        maxValue: 100
                        stepSize: 1
                        value: 10
                        unit: ""
                        valueMultiplier: 0.1
                        decimals: 1
                    }

                    Widgets.DSPSlider {
                        Layout.fillWidth: true
                        label: qsTr("Sharpen Sigma")
                        minValue: 0
                        maxValue: 100
                        stepSize: 1
                        value: 0
                        unit: ""
                        valueMultiplier: 0.05
                        decimals: 2
                    }

                    Widgets.DSPSlider {
                        Layout.fillWidth: true
                        label: qsTr("Banding Removal Radius")
                        minValue: 0
                        maxValue: 64
                        stepSize: 1
                        value: 16
                        unit: " px"
                    }

                    Widgets.DSPSlider {
                        Layout.fillWidth: true
                        label: qsTr("Film Grain Variance")
                        minValue: 0
                        maxValue: 100
                        stepSize: 1
                        value: 20
                        unit: ""
                        valueMultiplier: 0.01
                        decimals: 2
                    }
                }
            }
        }

        // ═══════════════════════════════════════════════════
        // 2. CROP TAB
        // ═══════════════════════════════════════════════════
        ColumnLayout {
            Layout.fillWidth: true
            visible: root.subTab === 1
            spacing: VLCStyle.margin_normal

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: cropCol.implicitHeight + VLCStyle.margin_normal * 2
                color: VLCDesignTokens.bgDark2
                radius: VLCDesignTokens.radiusCard
                border.color: VLCDesignTokens.borderSubtle
                border.width: 1

                ColumnLayout {
                    id: cropCol
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: VLCStyle.margin_normal
                    spacing: VLCStyle.margin_normal

                    Text {
                        text: qsTr("Manual Crop (Pixels)")
                        font.pixelSize: VLCStyle.fontSize_normal
                        font.weight: Font.Bold
                        color: VLCDesignTokens.textPrimary
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        rowSpacing: VLCStyle.margin_small
                        columnSpacing: VLCStyle.margin_small

                        // Top
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: VLCStyle.dp(36, VLCStyle.scale)
                            color: VLCDesignTokens.bgDark0
                            radius: VLCDesignTokens.radiusButton
                            border.color: VLCDesignTokens.borderMedium
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: VLCStyle.margin_small
                                Text {
                                    text: qsTr("Top")
                                    color: VLCDesignTokens.textSecondary
                                    font.pixelSize: VLCStyle.fontSize_small
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: "0 px"
                                    color: VLCDesignTokens.textPrimary
                                    font.pixelSize: VLCStyle.fontSize_small
                                    font.weight: Font.DemiBold
                                }
                            }
                        }

                        // Bottom
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: VLCStyle.dp(36, VLCStyle.scale)
                            color: VLCDesignTokens.bgDark0
                            radius: VLCDesignTokens.radiusButton
                            border.color: VLCDesignTokens.borderMedium
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: VLCStyle.margin_small
                                Text {
                                    text: qsTr("Bottom")
                                    color: VLCDesignTokens.textSecondary
                                    font.pixelSize: VLCStyle.fontSize_small
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: "0 px"
                                    color: VLCDesignTokens.textPrimary
                                    font.pixelSize: VLCStyle.fontSize_small
                                    font.weight: Font.DemiBold
                                }
                            }
                        }

                        // Left
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: VLCStyle.dp(36, VLCStyle.scale)
                            color: VLCDesignTokens.bgDark0
                            radius: VLCDesignTokens.radiusButton
                            border.color: VLCDesignTokens.borderMedium
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: VLCStyle.margin_small
                                Text {
                                    text: qsTr("Left")
                                    color: VLCDesignTokens.textSecondary
                                    font.pixelSize: VLCStyle.fontSize_small
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: "0 px"
                                    color: VLCDesignTokens.textPrimary
                                    font.pixelSize: VLCStyle.fontSize_small
                                    font.weight: Font.DemiBold
                                }
                            }
                        }

                        // Right
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: VLCStyle.dp(36, VLCStyle.scale)
                            color: VLCDesignTokens.bgDark0
                            radius: VLCDesignTokens.radiusButton
                            border.color: VLCDesignTokens.borderMedium
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: VLCStyle.margin_small
                                Text {
                                    text: qsTr("Right")
                                    color: VLCDesignTokens.textSecondary
                                    font.pixelSize: VLCStyle.fontSize_small
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: "0 px"
                                    color: VLCDesignTokens.textPrimary
                                    font.pixelSize: VLCStyle.fontSize_small
                                    font.weight: Font.DemiBold
                                }
                            }
                        }
                    }
                }
            }
        }

        // ═══════════════════════════════════════════════════
        // 3. COLORS TAB (Extraction, Negate, Sepia, etc.)
        // ═══════════════════════════════════════════════════
        ColumnLayout {
            Layout.fillWidth: true
            visible: root.subTab === 2
            spacing: VLCStyle.margin_normal

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: colorsCol.implicitHeight + VLCStyle.margin_normal * 2
                color: VLCDesignTokens.bgDark2
                radius: VLCDesignTokens.radiusCard
                border.color: VLCDesignTokens.borderSubtle
                border.width: 1

                ColumnLayout {
                    id: colorsCol
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: VLCStyle.margin_normal
                    spacing: VLCStyle.margin_normal

                    Text {
                        text: qsTr("Color Filters & Effects")
                        font.pixelSize: VLCStyle.fontSize_normal
                        font.weight: Font.Bold
                        color: VLCDesignTokens.textPrimary
                    }

                    // Color Extraction
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: qsTr("Color Extraction")
                            font.pixelSize: VLCStyle.fontSize_small
                            color: VLCDesignTokens.textSecondary
                            Layout.fillWidth: true
                        }
                        Rectangle {
                            Layout.preferredWidth: VLCStyle.dp(18, VLCStyle.scale)
                            Layout.preferredHeight: VLCStyle.dp(18, VLCStyle.scale)
                            radius: 2
                            color: "#FF0000"
                        }
                        Rectangle {
                            property bool checked: false
                            Layout.preferredWidth: VLCStyle.dp(44, VLCStyle.scale)
                            Layout.preferredHeight: VLCStyle.dp(24, VLCStyle.scale)
                            radius: VLCDesignTokens.radiusButton
                            color: checked ? VLCDesignTokens.primaryOrange : VLCDesignTokens.bgDark0
                            border.color: VLCDesignTokens.borderMedium
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: parent.checked ? qsTr("ON") : qsTr("OFF")
                                font.pixelSize: VLCStyle.dp(9, VLCStyle.scale)
                                font.weight: Font.Bold
                                color: parent.checked ? "#FFFFFF" : VLCDesignTokens.textMuted
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: parent.checked = !parent.checked
                            }
                        }
                    }

                    // Color Threshold
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: qsTr("Color Threshold")
                            font.pixelSize: VLCStyle.fontSize_small
                            color: VLCDesignTokens.textSecondary
                            Layout.fillWidth: true
                        }
                        Rectangle {
                            Layout.preferredWidth: VLCStyle.dp(18, VLCStyle.scale)
                            Layout.preferredHeight: VLCStyle.dp(18, VLCStyle.scale)
                            radius: 2
                            color: "#FF0000"
                        }
                        Rectangle {
                            property bool checked: false
                            Layout.preferredWidth: VLCStyle.dp(44, VLCStyle.scale)
                            Layout.preferredHeight: VLCStyle.dp(24, VLCStyle.scale)
                            radius: VLCDesignTokens.radiusButton
                            color: checked ? VLCDesignTokens.primaryOrange : VLCDesignTokens.bgDark0
                            border.color: VLCDesignTokens.borderMedium
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: parent.checked ? qsTr("ON") : qsTr("OFF")
                                font.pixelSize: VLCStyle.dp(9, VLCStyle.scale)
                                font.weight: Font.Bold
                                color: parent.checked ? "#FFFFFF" : VLCDesignTokens.textMuted
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: parent.checked = !parent.checked
                            }
                        }
                    }

                    // Negate Colors Toggle
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: qsTr("Negate Colors")
                            font.pixelSize: VLCStyle.fontSize_small
                            color: VLCDesignTokens.textSecondary
                            Layout.fillWidth: true
                        }
                        Rectangle {
                            property bool checked: false
                            Layout.preferredWidth: VLCStyle.dp(44, VLCStyle.scale)
                            Layout.preferredHeight: VLCStyle.dp(24, VLCStyle.scale)
                            radius: VLCDesignTokens.radiusButton
                            color: checked ? VLCDesignTokens.primaryOrange : VLCDesignTokens.bgDark0
                            border.color: VLCDesignTokens.borderMedium
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: parent.checked ? qsTr("ON") : qsTr("OFF")
                                font.pixelSize: VLCStyle.dp(9, VLCStyle.scale)
                                font.weight: Font.Bold
                                color: parent.checked ? "#FFFFFF" : VLCDesignTokens.textMuted
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: parent.checked = !parent.checked
                            }
                        }
                    }

                    // Posterize Toggle
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: qsTr("Posterize")
                            font.pixelSize: VLCStyle.fontSize_small
                            color: VLCDesignTokens.textSecondary
                            Layout.fillWidth: true
                        }
                        Rectangle {
                            property bool checked: false
                            Layout.preferredWidth: VLCStyle.dp(44, VLCStyle.scale)
                            Layout.preferredHeight: VLCStyle.dp(24, VLCStyle.scale)
                            radius: VLCDesignTokens.radiusButton
                            color: checked ? VLCDesignTokens.primaryOrange : VLCDesignTokens.bgDark0
                            border.color: VLCDesignTokens.borderMedium
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: parent.checked ? qsTr("ON") : qsTr("OFF")
                                font.pixelSize: VLCStyle.dp(9, VLCStyle.scale)
                                font.weight: Font.Bold
                                color: parent.checked ? "#FFFFFF" : VLCDesignTokens.textMuted
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: parent.checked = !parent.checked
                            }
                        }
                    }

                    // Sepia Intensity
                    Widgets.DSPSlider {
                        Layout.fillWidth: true
                        label: qsTr("Sepia Intensity")
                        minValue: 0
                        maxValue: 100
                        stepSize: 1
                        value: 30
                        unit: "%"
                    }
                }
            }
        }
    }
}
