Prerequisites:
- Node.js 20+
- npm
- Python 3.10+
- pip
- git
- gh (GitHub CLI)
- claude (Claude CLI)
- codegraph (CodeGraph CLI)
- uipro-cli (UI/UX Pro Max CLI)

Installation:
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
