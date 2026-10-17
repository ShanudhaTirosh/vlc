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
pragma Singleton
import QtQuick

import VLC.MainInterface

QtObject {
    id: designTokens

    readonly property real scale: MainCtx.intfScaleFactor

    // ==========================================
    // Color Palette (from Figma Community Design)
    // ==========================================

    // VLC Signature Accents
    readonly property color accentOrange: "#D37918"       // Primary Brand Orange
    readonly property color accentOrangeLight: "#E8851A"  // Hover / Active highlight
    readonly property color accentOrangeDark: "#AB6314"   // Gradient fill start
    readonly property color accentOrangeDeep: "#371F06"   // Dark gradient root

    // Alternative Theme Accents
    readonly property color accentPurple: "#8A38F5"       // Purple variant
    readonly property color accentPurpleLight: "#8E42FF"
    readonly property color accentPink: "#F052B3"         // Pink variant
    readonly property color accentGreen: "#19A234"        // High volume / Status OK
    readonly property color accentLime: "#95D318"         // Mid-volume gradient
    readonly property color accentBlue: "#185DD3"         // Stream / Info
    readonly property color accentRed: "#FF3737"          // Overdrive volume / Alert

    // Surface Neutrals (Dark Mode)
    readonly property color bgBlack: "#090909"            // Deepest black (video surface)
    readonly property color bgDark1: "#151515"            // Main control bar & top chrome
    readonly property color bgDark2: "#1E1E1E"            // Sidebar panels & drawers
    readonly property color bgDark3: "#262626"            // Modal dialogs & settings
    readonly property color bgInput: "#0E0E0E"            // Input fields & slider tracks
    readonly property color borderSubtle: "#373737"       // Subtle dividing borders
    readonly property color borderFocus: "#D37918"        // Focused outline border

    // Surface Neutrals (Light Mode)
    readonly property color bgLightShell: "#D8D8D8"
    readonly property color bgLightCard: "#EAEAEA"
    readonly property color bgLightPanel: "#FFFFFF"
    readonly property color textLightPrimary: "#111111"
    readonly property color textLightSecondary: "#666666"

    // Typography Colors
    readonly property color textPrimary: "#FFFFFF"
    readonly property color textSecondary: "#8F8F8F"
    readonly property color textMuted: "#6B6B6B"
    readonly property color textDisabled: "#444444"

    // Active Theme Accent (configurable dynamically)
    property color currentAccent: accentOrange

    // ==========================================
    // Geometries & Radii (Rectangular Utilitarian)
    // ==========================================

    readonly property int radiusNone: 0
    readonly property int radiusButton: MainCtx.dp(4, scale)
    readonly property int radiusPanel: MainCtx.dp(6, scale)
    readonly property int radiusCard: MainCtx.dp(8, scale)
    readonly property int radiusAlbumArt: MainCtx.dp(12, scale)

    // Seek Bar Metrics
    readonly property int seekbarHeightResting: MainCtx.dp(4, scale)
    readonly property int seekbarHeightHover: MainCtx.dp(8, scale)
    readonly property int seekbarThumbWidth: MainCtx.dp(4, scale)
    readonly property int seekbarThumbHeight: MainCtx.dp(12, scale)

    // Traffic Cone Volume Metrics
    readonly property int coneVolumeWidth: MainCtx.dp(88, scale)
    readonly property int coneVolumeHeight: MainCtx.dp(18, scale)
    readonly property int coneVolumeRadiusLeft: MainCtx.dp(3, scale)
    readonly property int coneVolumeRadiusRight: MainCtx.dp(3, scale)

    // Sidebar & Navigation Drawer
    readonly property int sidebarWidth: MainCtx.dp(320, scale)
    readonly property int navRailWidth: MainCtx.dp(56, scale)
    readonly property int topbarHeight: MainCtx.dp(44, scale)
    readonly property int controlbarHeight: MainCtx.dp(64, scale)
}
