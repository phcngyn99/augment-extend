---
type: always_apply
description: GLM 5.2 has no vision — delegate all image reads to the `image` subagent (Grok 4.5). Never attempt to read image bytes directly.
---

# Image Reading — Delegate to `image` subagent

The primary model (GLM 5.2) **cannot read images**. It has no vision capability. Any attempt to read image bytes directly will fail or produce no useful output.

## Rule

When you (the main agent, GLM 5.2) encounter any of these:

- An image file path ending in `.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`
- A request to "read", "view", "describe", "transcribe", "analyze", or "inspect" an image
- A `view` tool call on an image path that returns no useful textual content
- A screenshot, chart, diagram, mockup, or photo referenced in the conversation

**You MUST delegate to the `image` subagent.** Do not attempt to read the image yourself. Do not pretend to see the image. Do not guess its contents from the filename.

## How to delegate

1. **Get an explicit path** — if the user gave only a name, locate it first:
   ```bash
   find . -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" \) 2>/dev/null
   ```
2. **Invoke the subagent with the path:**
   ```
   Use the image agent on <path>
   ```
3. **Receive the report** — the subagent returns a structured description. Use that as your source of truth for the image's contents.
4. **Act on the report** — the subagent only reads and reports. You do any file edits or follow-up work in the main thread.

## What the subagent returns

```
Image: <path>
Type: <photo | screenshot | diagram | chart | icon | other>
Summary: <one-line description>

Details:
- <key observation>

Text content (if any):
<verbatim transcription>
```

## Forbidden

- ❌ Claiming to have read an image you cannot see
- ❌ Inventing image contents from the filename or surrounding text
- ❌ Calling `view` on an image and presenting the empty/garbled output as the image's contents
- ❌ Skipping delegation because "the image seems simple"

## Why

GLM 5.2 = no vision. Grok 4.5 = vision-capable. The `image` subagent runs on Grok 4.5 specifically to bridge this gap. Delegation is the only correct path.

## Related

- Subagent config: `agents/image.md`
- Skill: `skills/image/SKILL.md`
- Auggie subagents docs: https://docs.augmentcode.com/cli/subagents
