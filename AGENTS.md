# Agent Architecture Constraints

## Codebase Context & Retrieval

### CodeGraph is Primary
- **Standard `codebase-retrieval` tool is DISABLED** for this project
- **Use CodeGraph tools exclusively** for all codebase context and retrieval:
  - `codegraph_search` - Symbol search by name
  - `codegraph_explore` - Primary tool for understanding code, flows, architecture (call FIRST for almost any question)
  - `codegraph_node` - Single symbol details or file reading (replaces `view` for source files with dependency info)
  - `codegraph_callers` - Find callers of a function/method

### Initialization Required
If CodeGraph has not been initialized in the current project directory, run:
```bash
codegraph init
```

This sets up the necessary index and configuration before using CodeGraph tools.
