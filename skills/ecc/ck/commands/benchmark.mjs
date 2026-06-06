#!/usr/bin/env node
/**
 * ck — Context Keeper v2
 * benchmark.mjs — Compare cold-start resumption quality: baseline vs enriched context.
 *
 * Usage:
 *   node benchmark.mjs [--project <name>]
 *
 * Generates two context payloads (baseline = summary/leftOff/nextSteps only,
 * enriched = all fields including activeFiles/codeContext/errorState/failedApproaches/taskProgress)
 * and outputs a structured comparison for manual or automated evaluation.
 *
 * Scoring dimensions:
 *   - re_orientation: how many codebase-retrieval/view calls needed before productive work
 *   - wrong_assumptions: incorrect assumptions about code state
 *   - clarification_questions: questions agent asks before starting work
 *
 * No external dependencies. Node.js stdlib only.
 */

import { resolve } from 'path';
import { resolveContext, today } from './shared.mjs';

const cwd = process.env.PWD || process.cwd();

// Parse args
const args = process.argv.slice(2);
const projectIdx = args.indexOf('--project');
const projectArg = projectIdx >= 0 ? args[projectIdx + 1] : undefined;

const resolved = resolveContext(projectArg, cwd);
if (!resolved) {
  console.log('ck benchmark: no project found. Register with /ck:init or pass --project <name>.');
  process.exit(1);
}

const { context } = resolved;
const latest = context.sessions?.[context.sessions.length - 1];

if (!latest) {
  console.log('ck benchmark: no sessions found. Run /ck:save first.');
  process.exit(1);
}

// ── Build baseline context (existing fields only) ────────────────────────────

const baseline = {
  project: context.displayName ?? context.name,
  goal: context.goal,
  summary: latest.summary,
  leftOff: latest.leftOff,
  nextSteps: latest.nextSteps,
  blockers: latest.blockers,
  decisions: latest.decisions,
};

// ── Build enriched context (all fields) ──────────────────────────────────────

const enriched = {
  ...baseline,
  activeFiles: latest.activeFiles || [],
  codeContext: latest.codeContext || null,
  errorState: latest.errorState || null,
  failedApproaches: latest.failedApproaches || [],
  taskProgress: latest.taskProgress || null,
};

// ── Compute enrichment delta ─────────────────────────────────────────────────

const enrichedFields = [];
if (latest.activeFiles?.length) enrichedFields.push(`activeFiles (${latest.activeFiles.length})`);
if (latest.codeContext) enrichedFields.push('codeContext');
if (latest.errorState) enrichedFields.push('errorState');
if (latest.failedApproaches?.length) enrichedFields.push(`failedApproaches (${latest.failedApproaches.length})`);
if (latest.taskProgress) enrichedFields.push('taskProgress');

// ── Scoring rubric ───────────────────────────────────────────────────────────

const rubric = {
  re_orientation: {
    description: 'Count of codebase-retrieval/view calls before first productive edit',
    scoring: '0-2 = excellent, 3-5 = acceptable, 6+ = poor',
  },
  wrong_assumptions: {
    description: 'Incorrect assumptions about code state, file locations, or APIs',
    scoring: '0 = excellent, 1-2 = acceptable, 3+ = poor',
  },
  clarification_questions: {
    description: 'Questions agent asks user before starting work',
    scoring: '0-1 = excellent, 2-3 = acceptable, 4+ = poor',
  },
};

// ── Output ───────────────────────────────────────────────────────────────────

const output = {
  timestamp: new Date().toISOString(),
  project: context.displayName ?? context.name,
  sessionId: latest.id,
  enrichedFieldsPresent: enrichedFields,
  enrichmentCoverage: enrichedFields.length > 0
    ? `${enrichedFields.length}/5 fields populated`
    : 'No enriched fields — baseline only',
  baseline: {
    label: 'BASELINE (semantic only)',
    context: baseline,
    tokenEstimate: JSON.stringify(baseline).length / 4, // rough token count
  },
  enriched: {
    label: 'ENRICHED (semantic + code-level)',
    context: enriched,
    tokenEstimate: JSON.stringify(enriched).length / 4,
  },
  tokenOverhead: Math.round((JSON.stringify(enriched).length - JSON.stringify(baseline).length) / 4),
  rubric,
  instructions: [
    '1. Dispatch two sub-agents with identical task prompt',
    '2. Agent A gets baseline context, Agent B gets enriched context',
    '3. Both agents work on the same next step from nextSteps[0]',
    '4. Score each agent on the 3 rubric dimensions',
    '5. Compare scores to measure enrichment value',
  ],
};

console.log(JSON.stringify(output, null, 2));
