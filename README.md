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
1. Clone repo: `git clone git@github.com:phcngyn99/augment-extend.git && cd augment-extend`
2. Install to ~/.augment: `./scripts/install-to-augment.sh`
   - Checks Auggie CLI installed
   - Copies repo to ~/.augment (excludes .gitignore files)
   - Sets up submodules and creates symlinks automatically
3. **IMPORTANT**: Run `auggie` from any project directory. Auggie uses config from `~/.augment`, not the cloned repo.
   - The cloned repo is for development/updates only
   - After installation, you can delete the clone or keep it for future updates

Updating Config (When Already in ~/.augment):
1. Pull latest changes: `cd ~/.augment && git pull`
2. Update submodules: `~/.augment/startup/update-submodules.sh`
3. Refresh symlinks: `~/.augment/scripts/setup-symlinks.sh`

Manual Setup (If Installing Directly to ~/.augment):
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