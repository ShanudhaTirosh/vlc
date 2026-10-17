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

T.Control {
    id: root

    implicitWidth: VLCStyle.dp(280, VLCStyle.scale)
    implicitHeight: VLCStyle.dp(34, VLCStyle.scale)

    property var model: []
    property int currentIndex: 0
    property string currentText: (model && model.length > currentIndex && currentIndex >= 0) ? model[currentIndex] : ""

    signal activated(int index)

    background: Rectangle {
        radius: VLCDesignTokens.radiusButton
        color: VLCDesignTokens.bgDark0
        border.color: popup.visible ? VLCDesignTokens.primaryOrange : (mouseArea.containsMouse ? VLCDesignTokens.borderMedium : VLCDesignTokens.borderSubtle)
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: VLCStyle.margin_normal
            anchors.rightMargin: VLCStyle.margin_normal

            Text {
                text: root.currentText
                font.pixelSize: VLCStyle.fontSize_small
                color: VLCDesignTokens.textPrimary
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: "▼"
                font.pixelSize: VLCStyle.dp(10, VLCStyle.scale)
                color: VLCDesignTokens.textMuted
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: popup.visible = !popup.visible
    }

    T.Popup {
        id: popup
        y: root.height + 4
        width: root.width
        padding: 4
        closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside

        background: Rectangle {
            color: VLCDesignTokens.bgDark1
            radius: VLCDesignTokens.radiusButton
            border.color: VLCDesignTokens.borderSubtle
            border.width: 1

            Widgets.DefaultShadow {}
        }

        contentItem: Column {
            spacing: 2

            Repeater {
                model: root.model
                delegate: Rectangle {
                    width: parent.width
                    height: VLCStyle.dp(30, VLCStyle.scale)
                    radius: VLCDesignTokens.radiusButton - 1
                    color: (root.currentIndex === index) ? VLCDesignTokens.primaryOrange : (itemMouse.containsMouse ? VLCDesignTokens.bgDark2 : "transparent")

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: VLCStyle.margin_small
                        anchors.rightMargin: VLCStyle.margin_small
                        verticalAlignment: Text.AlignVCenter
                        text: modelData
                        font.pixelSize: VLCStyle.fontSize_small
                        color: (root.currentIndex === index) ? "#FFFFFF" : VLCDesignTokens.textPrimary
                    }

                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.currentIndex = index
                            root.activated(index)
                            popup.close()
                        }
                    }
                }
            }
        }
    }
}
