---
name: anki
description: "Use this skill for ANY Anki-related tasks: creating flashcards, managing decks, reviewing cards, searching notes, syncing with AnkiWeb, or any interaction with the Anki spaced repetition application. Triggers on mentions of \"Anki\", \"flashcard\", \"spaced repetition\", \"SRS\", deck management, or study/review requests. Requires Anki Desktop running with the AnkiConnect addon installed."
mcp:
  anki:
    command: ankimcp
    args: ["--stdio", "--read-only"]
    env:
      ANKI_CONNECT_URL: "http://localhost:8765"
---

# Anki MCP

Anki flashcard management via the `anki-mcp` MCP server. Tools, schemas, and docs are auto-discovered on load above.

## Prerequisites

1. **Anki Desktop** must be running
2. **AnkiConnect** addon must be installed (addon code: `2055492159`)

## Notes

- Invoke tools via `skill_mcp(mcp_name="anki-mcp", tool_name="<tool>", arguments={...})`
- `findNotes` supports Anki query syntax: `"deck:Name"`, `"tag:x"`, `"is:due"`, `"is:new"`, `"added:7"`
- Do NOT view a note in Anki's browser while updating it via `updateNoteFields` — the update will silently fail
