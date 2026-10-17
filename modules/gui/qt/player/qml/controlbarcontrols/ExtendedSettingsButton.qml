/*****************************************************************************
 * Copyright (C) 2021 VLC authors and VideoLAN
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


import VLC.Widgets as Widgets
import VLC.Style
import VLC.Dialogs
import VLC.Util

Widgets.IconToolButton {
    id: extdSettingsBtn

    text: VLCIcons.effect_filter

    description: qsTr("Extended settings")

    AccessibleCompat.id: "extendedSettingsButton"

    onClicked: {
        effectsDrawerLoader.active = true
        if (effectsDrawerLoader.item) {
            effectsDrawerLoader.item.visible = !effectsDrawerLoader.item.visible
        } else {
            DialogsProvider.extendedDialog()
        }
    }

    Loader {
        id: effectsDrawerLoader
        active: false
        sourceComponent: AudioDSPDrawer {
            id: drawer
            parent: (typeof rootPlayer !== 'undefined' && rootPlayer) ? rootPlayer : ((typeof g_mainDisplay !== 'undefined' && g_mainDisplay) ? g_mainDisplay : extdSettingsBtn)
            anchors.right: parent ? parent.right : undefined
            anchors.top: parent ? parent.top : undefined
            anchors.bottom: parent ? parent.bottom : undefined
            z: 99

            onCloseRequested: {
                drawer.visible = false
                effectsDrawerLoader.active = false
            }
        }
    }
}
