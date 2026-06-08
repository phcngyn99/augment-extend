# CodeGraph Usage Reference

## Install

**No Node required:**
```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh

# Windows (PowerShell)
irm https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.ps1 | iex

# Or via npm (any Node version)
npm i -g @colbymchenry/codegraph
```

**Upgrade:**
```bash
codegraph upgrade              # detect install method, update in place
codegraph upgrade --check      # check if update available
codegraph upgrade <version>    # pin specific version
```

**Uninstall:**
```bash
codegraph uninstall            # remove from agents
# Then remove CLI via npm/manual
```

## Setup

**1. Wire up agents:**
```bash
codegraph install              # interactive, auto-detects agents
codegraph install --yes        # non-interactive, auto-detect
codegraph install --target=cursor,claude --yes  # explicit targets
codegraph install --location=local              # project-local
codegraph install --print-config codex          # print snippet only
```

Detects: Claude Code, Cursor, Codex, opencode, Hermes Agent, Gemini, Antigravity, Kiro

**2. Restart agent** — MCP server loads on restart

**3. Initialize projects:**
```bash
cd your-project
codegraph init -i              # init + index
codegraph init                 # init only (no index)
codegraph uninit               # remove from project
codegraph uninit --force       # skip prompt
```

## CLI Commands

### Index/Sync
```bash
codegraph index [path]         # full index
codegraph index --force        # re-index
codegraph index --quiet        # less output
codegraph sync [path]          # incremental update
codegraph status [path]        # stats + health
```

### Search/Query
```bash
codegraph query <search>       # search symbols
codegraph query --kind <type>  # filter by kind (function, class, etc.)
codegraph query --limit <n>    # limit results
codegraph query --json         # JSON output

codegraph files [path]         # file structure
codegraph files --format tree  # format: tree|list|json
codegraph files --filter "*.ts"  # filter pattern
codegraph files --max-depth 3  # depth limit
codegraph files --json         # JSON output
```

### Call Graph
```bash
codegraph callers <symbol>     # find what calls this
codegraph callees <symbol>     # find what this calls
codegraph impact <symbol>      # blast radius
codegraph impact --depth <n>   # traversal depth
codegraph impact --json        # JSON output
```

### Affected Tests
```bash
codegraph affected src/utils.ts src/api.ts  # files as args
git diff --name-only | codegraph affected --stdin  # pipe from git
codegraph affected --filter "e2e/*"  # custom test glob
codegraph affected --depth 5    # max traversal depth
codegraph affected --json       # JSON output
codegraph affected --quiet      # paths only
```

**CI hook example:**
```bash
#!/usr/bin/env bash
AFFECTED=$(git diff --name-only HEAD | codegraph affected --stdin --quiet)
if [ -n "$AFFECTED" ]; then
  npx vitest run $AFFECTED
fi
```

## MCP Server

**Start:**
```bash
codegraph serve --mcp          # MCP stdio server
```

**MCP tools (agent-facing):**

- `codegraph_explore` — primary: "how does X work", flows, area survey → returns source + relationship map + blast radius in one call
- `codegraph_search` — find symbols by name
- `codegraph_callers` — what calls this function
- `codegraph_callees` — what this function calls
- `codegraph_impact` — analyze change blast radius
- `codegraph_node` — get symbol details + full source (all overloads)
- `codegraph_files` — indexed file structure (faster than fs scan)
- `codegraph_status` — index health + stats

**Auto-sync:**
- Native file watcher (FSEvents/inotify/ReadDirectoryChangesW)
- 2s debounce (tune: `CODEGRAPH_WATCH_DEBOUNCE_MS`, clamp: 100ms-60s)
- Staleness banner if query hits pending file
- Connect-time catch-up sync on MCP server (re)start
- Manual sync rarely needed unless `CODEGRAPH_NO_DAEMON=1`

**Agent guidance delivered via MCP:**
- Answer structural questions directly with CodeGraph — treat returned source as already read
- `codegraph_explore` for almost anything
- `codegraph_search` to locate symbols
- `codegraph_callers`/`callees` for call flow
- `codegraph_impact` before edits
- `codegraph_node` for one symbol's full source
- Trust results — don't re-verify with grep
- Check staleness banner after edits

## Library Usage

```typescript
import CodeGraph from '@colbymchenry/codegraph';
// Or: const { CodeGraph } = require('@colbymchenry/codegraph');

const cg = await CodeGraph.init('/path/to/project');
// Or: const cg = await CodeGraph.open('/path/to/project');

await cg.indexAll({
  onProgress: (p) => console.log(`${p.phase}: ${p.current}/${p.total}`)
});

const results = cg.searchNodes('UserService');
const callers = cg.getCallers(results[0].node.id);
const context = await cg.buildContext('fix login bug', {
  maxNodes: 20,
  includeCode: true,
  format: 'markdown'
});
const impact = cg.getImpactRadius(results[0].node.id, 2);

cg.watch();   // auto-sync on file changes
cg.unwatch(); // stop watching
cg.close();
```

**Requirements:**
- Install from npm: `npm i @colbymchenry/codegraph`
- Node 22.5+ for `node:sqlite` (Electron qualifies if bundled Node ≥22.5)
- TypeScript types ship with package

## Supported Languages

TypeScript, JavaScript, Python, Go, Rust, Java, C#, PHP, Ruby, C, C++, Objective-C (partial), Swift, Kotlin, Scala, Dart, Svelte, Vue, Liquid, Pascal/Delphi, Lua, Luau

**Framework routes:** Django, Flask, FastAPI, Express, NestJS, Laravel, Drupal, Rails, Spring, Gin/chi/gorilla/mux, Axum/actix/Rocket, ASP.NET, Vapor, React Router, SvelteKit

**Cross-language bridges:**
- Swift ↔ ObjC (@objc auto-bridging)
- React Native legacy bridge (RCT_EXPORT_METHOD / @ReactMethod)
- RN TurboModules (Codegen spec)
- RN native → JS events (sendEventWithName)
- Expo Modules (Module DSL)
- Fabric/Paper view components (spec → native impl)

## Configuration

**Zero-config** — no config file. Language support auto from extension.

**Default excludes:**
- Deps/build/cache dirs: `node_modules`, `vendor`, `dist`, `build`, `target`, `.venv`, `Pods`, `.next`, etc.
- `.gitignore` entries (git repos via git, non-git by reading file)
- Files >1MB

**To exclude:** add to `.gitignore`  
**To include default-excluded:** `.gitignore` negation (`!vendor/`)

## Troubleshooting

- **"Not initialized"** → `codegraph init` in project
- **Slow indexing** → check excludes, use `--quiet`
- **Database locked** (old builds) → reinstall to get bundled runtime with WAL mode
- **MCP not connecting** → verify project indexed, check config path, test `codegraph serve --mcp` CLI
- **Missing symbols** → wait 2s for auto-sync or run `codegraph sync`, check language support + not in excluded dir

**Docs:** https://colbymchenry.github.io/codegraph/
