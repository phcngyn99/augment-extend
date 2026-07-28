---
name: image
description: Read, inspect, transcribe, or analyze image files (PNG, JPG, JPEG, GIF, WEBP) by delegating to the `image` subagent (Grok 4.5, vision-capable). Use whenever the primary model (GLM 5.2, no vision) encounters an image it cannot process. Requires an explicit image path from the caller. Overrides any builtin image skill.
---

# Image Skill

This skill delegates image-reading work to the `image` subagent. The primary model (GLM 5.2) cannot process images directly — the subagent runs on Grok 4.5, which has vision support.

## When to use

Invoke this skill (and the `image` subagent) when any of the following appear:

- A user references an image file by path: `./screenshot.png`, `docs/diagram.jpg`, etc.
- A user asks to "read", "view", "describe", "transcribe", "analyze", or "inspect" an image
- A diff, PR, or code review surfaces an image file (`.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`)
- A screenshot, chart, diagram, mockup, or photo needs interpretation
- The main agent's `view` tool is called on an image path and returns no useful textual content (sign the model lacks vision)

## When NOT to use

- URL pointing to `.md` → use WebFetch directly
- URL pointing to a web page → use Agent Browser (per `rules/agent-browser-only.md`)
- Image is a favicon/icon the user already described in text
- User explicitly says they want the file path, not its contents

## How to invoke

The `image` subagent REQUIRES an explicit image path. It does not search for files.

### Step 1 — Confirm the path

If the user gave a name but no path, locate the file first using `launch-process` with `find`:

```bash
find . -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" \) -name "*<hint>*" 2>/dev/null
```

Or use `codebase-retrieval` if the image name is mentioned in code/configs.

### Step 2 — Delegate to the subagent

Pass the explicit path in the invocation:

```
Use the image agent on <path>
```

or:

```
Invoke image with path <path> and ask: <question>
```

### Step 3 — Receive the report

The subagent returns a structured report:

```
Image: <path>
Type: <photo | screenshot | diagram | chart | icon | other>
Summary: <one-line description>

Details:
- <key observation>

Text content (if any):
<verbatim transcription>
```

Act on the report in the main thread. The subagent cannot edit files — you do that part.

## Supported formats

| Extension | Format |
|---|---|
| `.png` | PNG |
| `.jpg`, `.jpeg` | JPEG |
| `.gif` | GIF |
| `.webp` | WebP |

## Error cases

| Symptom | Cause | Fix |
|---|---|---|
| Subagent returns "No image path provided" | Caller invoked without a path | Re-invoke with explicit `<path>` |
| Subagent reports file not found | Wrong path or file missing | Verify with `test -f <path>` before delegating |
| Unsupported extension (`.svg`, `.bmp`, `.tiff`) | Outside supported set | For SVG, read as text (XML). For BMP/TIFF, convert via `sips` first |
| Subagent returns no useful content | Vision model failed on the image | Retry, or ask user to describe the image |

## Why a subagent, not a tool

GLM 5.2 has no vision capability. No amount of prompt engineering on the main thread will let it see pixels. Delegating to a vision-capable model (Grok 4.5) is the only path. The subagent pattern keeps the main agent's context clean — only the structured report returns, not raw image bytes.
