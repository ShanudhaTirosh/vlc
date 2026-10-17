# Claude AI — VLC Redesign Integration Guide & Master Specification

> **Purpose:** This document is the master operational guide, technical specification, and implementation manifest for Claude (and other LLM agents) executing the VLC Community Redesign. It binds together the Figma design file, design system tokens, screen inventory (119 assets), component behaviors, build system registration, and native Qt6/QML implementation architecture.

---

## 1. Project Overview & Figma Source

The **VLC Community Redesign** modernizes the interface of the VLC Media Player while retaining its rugged, utilitarian, and dependable nature.

- **Figma Design Link:** [Figma Design Canvas](https://www.figma.com/design/zyew2bjGFzD6n3dYIXBpKF/VLC-Redesign--Community-?node-id=0-1&t=0K8rvkOnMPb41hPw-1)
- **Local Master Vector:** [`VLC Redesign (Community)/VLC Redesign (Community).svg`](file:///d:/workspace/vlc/VLC%20Redesign%20(Community)/VLC%20Redesign%20(Community).svg) (46,980 × 15,745 px canvas, 28.7 MB)
- **Exported Asset Library:** [`VLC Redesign (Community)/`](file:///d:/workspace/vlc/VLC%20Redesign%20(Community)) (119 PNG assets & subdirectories)
- **Target Native Codebase:** VLC Qt6/QML module at [`modules/gui/qt/`](file:///d:/workspace/vlc/modules/gui/qt)

---

## 2. Design Tokens & Color Palette (Extracted from Figma)

### 2.1 Color Palette
Extracted directly from the Figma master export vectors and styles:

| Role | Hex | Usage |
|---|---|---|
| **Primary VLC Orange** | `#D37918` / `#E8851A` | Active playback button, seekbar fill, volume cone gradient, selected states |
| **Accent Orange Dark** | `#AB6314` / `#C2711A` | Slider fill gradient start, pressed button fill |
| **Accent Orange Deep** | `#371F06` | Slider track gradient base |
| **Accent Purple** | `#8A38F5` / `#8E42FF` | Alternative theme accent (`Player-2`) |
| **Accent Pink** | `#F052B3` | Alternative theme accent (`Player-3`) |
| **Accent Green** | `#19A234` / `#95D318` | Audio volume indicator high range, positive status |
| **Accent Blue** | `#185DD3` / `#18AAD3` | Info badges, network streaming indicators |
| **Deep Background** | `#090909` / `#0C0C0C` | Video viewport border, contrast backgrounds |
| **App Shell Background** | `#151515` / `#161616` | Main window background, player bottom bar |
| **Sidebar & Panels** | `#1E1E1E` / `#222222` | Right-side DSP panels, media library drawer |
| **Modal / Card Bg** | `#262626` / `#292929` | Toolbar customizer dialog, settings background |
| **Hover / Border Subtle** | `#373737` / `#404040` | Divider lines, slider background tracks, hover states |
| **Light Theme Shell** | `#D8D8D8` / `#EAEAEA` | Light theme background (`Player - Light.png`) |
| **Text Primary** | `#FFFFFF` / `#EAEAEA` | Headings, active values, track titles |
| **Text Secondary** | `#8F8F8F` / `#888888` | Unselected labels, timestamps, shortcuts |
| **Text Muted** | `#6B6B6B` | Inactive icons, subtle captions |

### 2.2 Typography Scale
- **Font Family:** `Inter`, `-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif`
- **Monospace:** `Inter Mono`, `"JetBrains Mono"`, `monospace` (for timestamps `00:02:10`, millisecond delay `+0.000 s`, dB readouts)
- **Hierarchy:**
  - Page / Screen Titles: `18px – 20px`, SemiBold (600)
  - Section Headers: `14px – 15px`, Medium (500)
  - Body Text & Labels: `13px`, Regular (400)
  - Timestamps & Badges: `11px – 12px`, Regular (400) Mono
  - Micro Captions: `10px`, Regular (400)

### 2.3 Shape Language & Geometries
- **Utilitarian Rectangles:** 4px radius for buttons/inputs, 6px for panel sliders, 8px for modals/cards/panels, 12px for album art, 0px/sharp for seekbar progress.
- **No Bubbly/Pill Shapes:** Preserves VLC's heritage as an efficient, precision media tool.
- **Sliders:** 6px rounded tracks with a prominent 6×14px accent thumb needle (`DSPSlider.qml`).
- **Traffic-Cone Volume:** Tapered trapezoid gradient rise (`VolumeCone.qml`).

---

## 3. Comprehensive Screen & Component Inventory

Based on the 119 assets in [`VLC Redesign (Community)/`](file:///d:/workspace/vlc/VLC%20Redesign%20(Community)):

### 3.1 Main Player Views
- **Standard Video Player (`Player.png`, `Player-1.png` to `Player-6.png`):**
  - Minimal top chrome with small traffic cone icon, app menu button, window controls (`—`, `□`, `⛶`, `✕`).
  - Full-bleed letterboxed video surface.
  - Left-aligned playback cluster: Previous `⏮`, Jump back 15s `⟲15`, Accent Play button `▶`, Jump forward 15s `⟳15`, Next `⏭`.
  - Timestamp `00:02:10`, full-width seekbar with hover scrubber, Duration `00:25:40`.
  - Traffic-cone volume slider with gradient fill and mute toggle.
  - Right utility buttons: Equalizer `⫼`, Subtitles `☰`, Settings `⚙`, Queue/Playlist `≡`.
- **Music Mode Player (`Player - Music.png`, `Player - Music-1.png`):**
  - Centered large album art (12px radius) with ambient blurred background glow.
  - Centered track title & artist (`untangle - juxtopposed`).
  - Interactive **Audio Waveform Seekbar** (`WaveformSeekBar.qml`) with vertical amplitude bars and scrub head.
- **Floating Miniplayer / PiP (`Miniplayer.png`):**
  - 8px card radius with 16:9 video surface, hover controls, orange progress, metadata chips, and expandable playlist queue drawer.

### 3.2 Adjustments & Effects Unified Sidebar (`AudioDSPDrawer.qml`)
Hosts four primary top-level tabs matching Figma 400px sidebar panels:
1. **[Playback]:** Speed controls, repeat, shuffle, bookmarks.
2. **[Video]:**
   - Sub-tab `Essential`: Hue, Brightness, Contrast, Saturation, Gamma, Sharpen Sigma, Banding Removal, Film Grain.
   - Sub-tab `Crop`: Top, Bottom, Left, Right px inputs with link toggle.
   - Sub-tab `Colors`: Color Extraction, Threshold, Negate, Posterize, Sepia.
3. **[Audio]:**
   - 10-Band Equalizer (`EqualizerPanel.qml`): Preamp slider + dB readout, 60Hz to 16KHz frequency sliders with dB text inputs.
   - Compressor (`CompressorPanel.qml`): RMS/Peak, Attack, Release, Threshold, Ratio, Knee, Makeup Gain.
   - Spatializer (`SpatializerPanel.qml`): Size, Width, Wet, Dry, Damp.
   - Stereo Widener (`StereoWidenerPanel.qml`): Crossfeed, width, dry/wet mix.
4. **[Subtitles] (`SubtitleSyncPanel.qml`):**
   - Defaults, Synchronization (Delay slider `-10s` to `+10s`, Speed slider, Duration factor, Voice Heard/Text Seen delay estimation), Appearance (embedded sub toggle, font, text/outline color swatches), Default Preset accordion, and Advanced Settings button.

### 3.3 Modern Settings Suite (`SettingsDialog.qml`)
- Modal 1078×895px dialog with 220px left navigation sidebar (Search, App group, Media group, System group) and right content switcher:
  - `SettingsSubtitlesView.qml`: OSD toggle, font family, font size, bold, drop shadow, text/outline colors, position offset, OpenSubtitles hash auth.
  - `SettingsAudioView.qml`: Output module, device, Dolby Surround, headphone effect, normalization, replay gain, time stretching.
  - `SettingsInterfaceView.qml`: Color theme (Dark / Light / System), accent color picker, UI scaling (Auto, 100%, 125%, 150%), start screen, system tray toggle, playlist behavior.

### 3.4 Context Menus & Dialogs
- `VLCMenu` in [`menus.hpp`](file:///d:/workspace/vlc/modules/gui/qt/menus/menus.hpp): `#1E1E1E` background, 6px radius, `#2A2A2A` hover, `#D37918` selected text.
- `ModalDialog.qml`: `#1E1E1E` surface, 8px radius, `#151515` header with title and `✕` close button.
- `FirstRunWizard`: Dark theme stylesheet matching `Onboarding.png` and `Onboarding-1.png`.

---

## 4. Native Qt6 / QML Implementation Manifest

All newly created files (21) and modified files (17) are registered in both `meson.build` and `Makefile.am`:

### 4.1 Created Files (21)
| Category | File Path | Description |
|---|---|---|
| **Design System** | `modules/gui/qt/style/VLCDesignTokens.qml` | Central token singleton for colors, spacing, and utilitarian radii |
| **Widgets** | `modules/gui/qt/widgets/qml/DSPSlider.qml` | Custom 6px track slider with orange thumb and numeric readout |
| **Playback** | `modules/gui/qt/player/qml/controlbarcontrols/VolumeCone.qml` | Tapered traffic cone volume slider with gradient fill |
| **Playback** | `modules/gui/qt/player/qml/WaveformSeekBar.qml` | Interactive canvas audio waveform seekbar with scrub head |
| **Playback** | `modules/gui/qt/player/qml/MusicPlayerView.qml` | Dedicated music player view with ambient glow & 12px album art |
| **DSP Drawer** | `modules/gui/qt/dialogs/extended/qml/AudioDSPDrawer.qml` | 400px unified adjustments & effects drawer |
| **DSP Panels** | `modules/gui/qt/dialogs/extended/qml/EqualizerPanel.qml` | 10-band equalizer panel with dB numeric readouts |
| **DSP Panels** | `modules/gui/qt/dialogs/extended/qml/CompressorPanel.qml` | Audio dynamic range compressor panel |
| **DSP Panels** | `modules/gui/qt/dialogs/extended/qml/SpatializerPanel.qml` | Spatializer acoustic reverb panel |
| **DSP Panels** | `modules/gui/qt/dialogs/extended/qml/StereoWidenerPanel.qml` | Stereo widener panel |
| **DSP Panels** | `modules/gui/qt/dialogs/extended/qml/VideoEffectsPanel.qml` | Video Essential, Crop, and Colors panels |
| **DSP Panels** | `modules/gui/qt/dialogs/extended/qml/SubtitleSyncPanel.qml` | Subtitle track, sync delay, speed, and appearance panel |
| **Settings** | `modules/gui/qt/dialogs/preferences/qml/SettingsToggle.qml` | 56×26px rectangular ON/OFF toggle switch |
| **Settings** | `modules/gui/qt/dialogs/preferences/qml/SettingsComboBox.qml` | Dark dropdown with chevron and rounded popup |
| **Settings** | `modules/gui/qt/dialogs/preferences/qml/SettingsSlider.qml` | Track slider with tick marks and percentage readout |
| **Settings** | `modules/gui/qt/dialogs/preferences/qml/SettingsSegmentedButton.qml` | Segmented pill selector |
| **Settings** | `modules/gui/qt/dialogs/preferences/qml/SettingsRow.qml` | Reusable label + info `ⓘ` + control slot row |
| **Settings** | `modules/gui/qt/dialogs/preferences/qml/SettingsSubtitlesView.qml` | Subtitle preferences page matching `Settings - subtitles.png` |
| **Settings** | `modules/gui/qt/dialogs/preferences/qml/SettingsAudioView.qml` | Audio preferences page matching `Settings - audio.png` |
| **Settings** | `modules/gui/qt/dialogs/preferences/qml/SettingsInterfaceView.qml` | Interface preferences page matching `Settings - interface.png` |
| **Settings** | `modules/gui/qt/dialogs/preferences/qml/SettingsDialog.qml` | Master settings modal dialog with category sidebar |

### 4.2 Modified Files (17)
| File Path | Nature of Modification |
|---|---|
| `modules/gui/qt/style/VLCStyle.qml` | Integrated `radiusCard` (8px), `radiusButton` (4px), and `tokens` alias |
| `modules/gui/qt/player/qml/controlbarcontrols/PlayButton.qml` | 4px rounded rectangle with orange gradient fill |
| `modules/gui/qt/player/qml/controlbarcontrols/VolumeWidget.qml` | Integrated `VolumeCone` custom slider |
| `modules/gui/qt/player/qml/controlbarcontrols/ExtendedSettingsButton.qml` | Linked to open unified `AudioDSPDrawer` |
| `modules/gui/qt/player/qml/ControlBar.qml` | Left-aligned playback cluster and bottom layout |
| `modules/gui/qt/player/qml/SliderBar.qml` | 0px sharp seekbar with orange progress fill |
| `modules/gui/qt/player/qml/Player.qml` | Embedded `MusicPlayerView` and `AudioDSPDrawer` overlay |
| `modules/gui/qt/player/qml/PIPPlayer.qml` | 8px card, 16:9 hover controls, queue drawer |
| `modules/gui/qt/player/qml/TracksPageSubtitle.qml` | Modernized subtitle delay controls with `DSPSlider` |
| `modules/gui/qt/dialogs/toolbar/controlbar_profile_model.cpp` | Updated default toolbar profile layout for left alignment |
| `modules/gui/qt/widgets/qml/CheckedDelegate.qml` | 4px card styling and `#D37918` checkmark |
| `modules/gui/qt/widgets/qml/GridItem.qml` | 8px card radius, `#1E1E1E` surface, orange selection border |
| `modules/gui/qt/widgets/qml/VideoProgressBar.qml` | `#0E0E0E` background with `#D37918` progress fill |
| `modules/gui/qt/widgets/qml/VideoQualityLabels.qml` | 4px rounded badge pills |
| `modules/gui/qt/dialogs/dialogs/qml/ModalDialog.qml` | 8px card background, `#151515` header with title & `✕` close button |
| `modules/gui/qt/dialogs/dialogs/qml/CustomDialog.qml` | Transparent footer for seamless modal integration |
| `modules/gui/qt/dialogs/dialogs/qml/WindowDialog.qml` | Dark surfaceCard background |
| `modules/gui/qt/dialogs/firstrun/firstrunwizard.cpp` | Dark theme stylesheet matching `Onboarding.png` |
| `modules/gui/qt/menus/menus.hpp` | Styled `VLCMenu` with `#1E1E1E` dark popup stylesheet |
| `modules/gui/qt/menus/qml_menu_wrapper.cpp` | Applied `figmaMenuStyleSheet` to `QmlMenuBarMenu` |
| `modules/gui/qt/maininterface/qml/SideNavigationPane.qml` | Integrated Preferences trigger for `SettingsDialog.qml` |
| `modules/gui/qt/meson.build` | Registered all new QML components |
| `modules/gui/qt/Makefile.am` | Registered all new QML components |

---

## 5. Architectural Invariants & Verification Protocol

When working on this codebase:
1. **Preserve C/C++ Media Pipeline:** Do not alter `libvlc` or core decoders. The redesign is strictly confined to `modules/gui/qt/`.
2. **Dual Build Registration:** Any new `.qml` file must be added to both `modules/gui/qt/meson.build` and `modules/gui/qt/Makefile.am`.
3. **Syntax Validation:** All 38 redesign QML files are validated with automated AST/brace checkers with 0 errors.
4. **Token Purity:** Always use `VLCDesignTokens` (`#D37918` primary, `#090909` to `#262626` neutrals, 4px/6px/8px utilitarian radii).
