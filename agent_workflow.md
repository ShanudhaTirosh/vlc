# Autonomous Agent Implementation Plan

If an autonomous coding agent were tasked with building this redesign on top of the VLC core, these would be its operational directives:

## Agent 1: UI/UX Frontend Developer
*   **Task:** Implement the new visual editor using drag-and-drop libraries (e.g., `dnd-kit` for React or native Qt equivalents).
*   **Goal:** Allow users to drag buttons onto the playback toolbar and save the state to a local configuration file.

## Agent 2: API & Integrations
*   **Task:** Build the subtitle fetching module.
*   **Goal:** Connect the UI to the OpenSubtitles REST API, handle authentication, search by video hash, and download `.srt` files directly into the media's directory.

## Agent 3: QA & Testing
*   **Task:** Visual regression testing.
*   **Goal:** Ensure the thick seek bar and hover thumbnails do not lag or block critical video content across different aspect ratios (16:9, 4:3, 21:9).