Prerequisites:
- Auggie CLI (https://www.augmentcode.com)
- Node.js 20+
- npm
- Python 3.10+
- pip
- git
- gh (GitHub CLI)
- claude (Claude CLI)
- codegraph (CodeGraph CLI)
- uipro-cli (UI/UX Pro Max CLI)
- agent-browser (Agent Browser CLI)

Installation (New Machine):
1. Clone repo: `git clone <repo-url> augment-config && cd augment-config`
2. Install to ~/.augment: `./scripts/install-to-augment.sh`
   - Checks Auggie CLI installed
   - Copies repo to ~/.augment (excludes .gitignore files)
   - Sets up submodules and creates symlinks automatically

Installation (Already in ~/.augment):
- Quick setup: `./scripts/setup-symlinks.sh`
- Manual setup:
  - Submodules: `git submodule update --init --recursive`
  - Create symlinks manually (see scripts/setup-symlinks.sh for reference)
- codegraph:
  - Install CLI: `curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh` (or use npm: `npm i -g @colbymchenry/codegraph`)
  - Wire to agent: `codegraph install` (select 'Claude Code' as target agent)
  - Initialize project: `cd your-project && codegraph init`
  - Update: `codegraph upgrade`
  - Uninstall: `codegraph uninstall`
- uipro-cli:
  - Install: `npm install -g uipro-cli && uipro init --ai augment`
  - Update: `uipro update`
  - Uninstall: `uipro uninstall --ai augment`
- agent-browser:
  - Install: `npm install -g agent-browser && agent-browser install  # Download Chrome from Chrome for Testing (first time only)`
  - Update: `agent-browser upgrade`
  - Uninstall: `TBD`