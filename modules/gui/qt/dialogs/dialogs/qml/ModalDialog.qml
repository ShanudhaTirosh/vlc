/*****************************************************************************
 * Copyright (C) 2019 VLC authors and VideoLAN
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
import QtQuick.Controls.Basic
import QtQuick.Templates as T
import QtQuick.Layouts

import VLC.MainInterface
import VLC.Widgets as Widgets
import VLC.Util
import VLC.Style

Dialog {
    id: control

    property Item rootWindow: null

    focus: true
    modal: true


    anchors.centerIn: T.Overlay.overlay

    padding: VLCStyle.margin_normal
    margins: VLCStyle.margin_large

    implicitWidth: contentWidth > 0 ? contentWidth + leftPadding + rightPadding : 0
    implicitHeight: (header && header.visible ? header.implicitHeight + spacing : 0)
                    + (footer && footer.visible ? footer.implicitHeight + spacing : 0)
                    + (contentHeight > 0 ? contentHeight + topPadding + bottomPadding : 0)

    closePolicy: Popup.CloseOnEscape

    readonly property ColorContext colorContext: ColorContext {
        id: theme
        palette: VLCStyle.palette
        colorSet: ColorContext.Window
    }

    T.Overlay.modal: Item {
        Rectangle {
            anchors.fill: blur

            visible: !blur.visible

            color: "#000000"

            opacity: 0.65
        }

        Widgets.DualKawaseBlur {
            id: blur

            anchors.fill: parent
            anchors.margins: MainCtx.windowExtendedMargin

            visible: MainCtx.backdropBlurRequested() && blur.available

            mode: Widgets.DualKawaseBlur.Mode.SixPass

            source: ShaderEffectSource {
                sourceItem: blur.visible ? control.rootWindow : null
                live: true
                hideSource: true
            }

            radius: 2
        }
    }

    background: Rectangle {
        color: VLCDesignTokens.surfaceCard
        radius: VLCDesignTokens.radiusCard
        border.color: VLCDesignTokens.borderSubtle
        border.width: 1

        Widgets.RoundedRectangleShadow {
            yOffset: VLCStyle.dp(6, VLCStyle.scale)
            blurRadius: VLCStyle.dp(12, VLCStyle.scale)
            radius: VLCDesignTokens.radiusCard

            visible: (parent.color.a > 0.0)

            opacity: 0.4

            color: "black"
        }
    }

    header: Rectangle {
        implicitHeight: control.title.length > 0 ? 44 : 0
        visible: control.title.length > 0
        color: VLCDesignTokens.surfaceDark
        radius: VLCDesignTokens.radiusCard

        // Square off bottom corners so it connects seamlessly to dialog body
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.radius
            color: parent.color
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 12
            spacing: 8

            Text {
                Layout.fillWidth: true
                text: control.title
                elide: Text.ElideRight
                font.pixelSize: 14
                font.weight: Font.DemiBold
                color: VLCDesignTokens.textPrimary
            }

            Rectangle {
                implicitWidth: 26
                implicitHeight: 26
                radius: 4
                color: closeHover.hovered ? VLCDesignTokens.surfaceHover : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    font.pixelSize: 12
                    color: closeHover.hovered ? VLCDesignTokens.textPrimary : VLCDesignTokens.textMuted
                }

                HoverHandler {
                    id: closeHover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    onTapped: control.reject()
                }
            }
        }
    }

    exit: Transition {
        OpacityAnimator { from: 1.0; to: 0.0 }
    }
    enter: Transition {
        OpacityAnimator { from: 0.0; to: 1.0 }
    }
}
