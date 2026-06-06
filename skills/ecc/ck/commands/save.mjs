#!/usr/bin/env node
/**
 * ck — Context Keeper v2
 * save.mjs — write session data to context.json, regenerate CONTEXT.md,
 *             and write a native memory entry.
 *
 * Usage (regular save):
 *   echo '<json>' | node save.mjs
 *   JSON schema: { summary, leftOff, nextSteps[], decisions[{what,why}], blockers[], goal? }
 *
 * Usage (init — first registration):
 *   echo '<json>' | node save.mjs --init
 *   JSON schema: { name, path, description, stack[], goal, constraints[], repo? }
 *
 * Usage (handoff — save + portable markdown doc):
 *   echo '<json-with-suggestedSkills>' | node save.mjs --handoff [focus]
 *   Additional field: suggestedSkills[]
 *   Creates: <project-root>/ck-handoff-<timestamp>.md
 *
 * stdout: confirmation message
 * exit 0: success  exit 1: error
 */

import { readFileSync, mkdirSync, writeFileSync } from 'fs';
import { resolve, basename } from 'path';
import { tmpdir } from 'os';
import {
  readProjects, writeProjects, loadContext, saveContext,
  today, shortId, gitSummary, nativeMemoryDir,
  CURRENT_SESSION,
} from './shared.mjs';

const isInit = process.argv.includes('--init');
const isHandoff = process.argv.includes('--handoff');
const handoffFocus = isHandoff ? process.argv[process.argv.indexOf('--handoff') + 1] : null;
const cwd    = process.env.PWD || process.cwd();

// ── Read JSON from stdin ──────────────────────────────────────────────────────
let input;
try {
  const raw = readFileSync(0, 'utf8').trim();
  if (!raw) throw new Error('empty stdin');
  input = JSON.parse(raw);
} catch (e) {
  console.error(`ck save: invalid JSON on stdin — ${e.message}`);
  console.log('Expected schema (save):  {"summary":"...","leftOff":"...","nextSteps":["..."],"decisions":[{"what":"...","why":"..."}],"blockers":["..."]}');
  console.log('Expected schema (--init): {"name":"...","path":"...","description":"...","stack":["..."],"goal":"...","constraints":["..."]}');
  process.exit(1);
}

// ─────────────────────────────────────────────────────────────────────────────
// INIT MODE: first-time project registration
// ─────────────────────────────────────────────────────────────────────────────
if (isInit) {
  const { name, path: projectPath, description, stack, goal, constraints, repo } = input;

  if (!name || !projectPath) {
    console.log('ck init: name and path are required.');
    process.exit(1);
  }

  const projects = readProjects();

  // Derive contextDir (lowercase, spaces→dashes, deduplicate)
  let contextDir = name.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9-]/g, '');
  let suffix = 2;
  const existingDirs = Object.values(projects).map(p => p.contextDir);
  while (existingDirs.includes(contextDir) && projects[projectPath]?.contextDir !== contextDir) {
    contextDir = `${contextDir.replace(/-\d+$/, '')}-${suffix++}`;
  }

  const context = {
    version: 2,
    name: contextDir,
    displayName: name,
    path: projectPath,
    description: description || null,
    stack: Array.isArray(stack) ? stack : (stack ? [stack] : []),
    goal: goal || null,
    constraints: Array.isArray(constraints) ? constraints : [],
    repo: repo || null,
    createdAt: today(),
    sessions: [],
  };

  saveContext(contextDir, context);

  // Update projects.json
  projects[projectPath] = {
    name,
    contextDir,
    lastUpdated: today(),
  };
  writeProjects(projects);

  console.log(`✓ Project '${name}' registered.`);
  console.log(`  Use /ck:save to save session state and /ck:resume to reload it next time.`);
  process.exit(0);
}

// ─────────────────────────────────────────────────────────────────────────────
// SAVE MODE: record a session
// ─────────────────────────────────────────────────────────────────────────────
const projects = readProjects();
const projectEntry = projects[cwd];

if (!projectEntry) {
  console.log("This project isn't registered yet. Run /ck:init first.");
  process.exit(1);
}

const { contextDir } = projectEntry;
let context = loadContext(contextDir);

if (!context) {
  console.log(`ck: context.json not found for '${contextDir}'. The install may be corrupted.`);
  process.exit(1);
}

// Get session ID from current-session.json
let sessionId;
try {
  const sess = JSON.parse(readFileSync(CURRENT_SESSION, 'utf8'));
  sessionId = sess.sessionId || shortId();
} catch {
  sessionId = shortId();
}

// Check for duplicate (re-save of same session)
const existingIdx = context.sessions.findIndex(s => s.id === sessionId);

const { summary, leftOff, nextSteps, decisions, blockers, goal,
        activeFiles, codeContext, errorState, failedApproaches, taskProgress, projectType, suggestedSkills } = input;

// Capture git activity since the last session
const lastSessionDate = context.sessions?.[context.sessions.length - 1]?.date;
const gitActivity = gitSummary(cwd, lastSessionDate);

const session = {
  id: sessionId,
  date: today(),
  summary: summary || 'Session saved',
  leftOff: leftOff || null,
  nextSteps: Array.isArray(nextSteps) ? nextSteps : (nextSteps ? [nextSteps] : []),
  decisions: Array.isArray(decisions) ? decisions : [],
  blockers: Array.isArray(blockers) ? blockers.filter(Boolean) : [],
  ...(gitActivity ? { gitActivity } : {}),
  // Optional enriched fields for cold-start agent optimization
  ...(activeFiles?.length ? { activeFiles } : {}),
  ...(codeContext ? { codeContext } : {}),
  ...(errorState ? { errorState: (typeof errorState === 'object' && errorState !== null) ? { expected: errorState.expected || '', actual: errorState.actual || '', location: errorState.location || '' } : errorState } : {}),
  ...(failedApproaches?.length ? { failedApproaches } : {}),
  ...(taskProgress ? { taskProgress } : {}),
  ...(projectType ? { projectType } : {}),
};

// Quality nudge: warn if high-value enriched fields are missing
if (!session.activeFiles?.length) {
  process.stderr.write('ck: hint — no activeFiles provided. Include activeFiles for better cold-start resumption.\n');
}
if (!session.codeContext) {
  process.stderr.write('ck: hint — no codeContext provided. Include file:line references for faster agent orientation.\n');
}
if (session.errorState && !session.failedApproaches?.length) {
  process.stderr.write('ck: hint — errorState set but no failedApproaches. Document what you tried to prevent repeat dead ends.\n');
}

if (existingIdx >= 0) {
  // Update existing session (re-save)
  context.sessions[existingIdx] = session;
} else {
  context.sessions.push(session);
}

// Update goal if provided
if (goal && goal !== context.goal) {
  context.goal = goal;
}

// Save context.json + regenerate CONTEXT.md
saveContext(contextDir, context);

// Update projects.json timestamp
projects[cwd].lastUpdated = today();
writeProjects(projects);

// ── Write to native memory ────────────────────────────────────────────────────
try {
  const memDir = nativeMemoryDir(cwd);
  mkdirSync(memDir, { recursive: true });

  const memFile = resolve(memDir, `ck_${today()}_${sessionId.slice(0, 8)}.md`);
  const decisionsBlock = session.decisions.length
    ? session.decisions.map(d => `- **${d.what}**: ${d.why || ''}`).join('\n')
    : '- None this session';
  const nextBlock = session.nextSteps.length
    ? session.nextSteps.map((s, i) => `${i + 1}. ${s}`).join('\n')
    : '- None recorded';
  const blockersBlock = session.blockers.length
    ? session.blockers.map(b => `- ${b}`).join('\n')
    : '- None';

  const memContent = [
    `---`,
    `name: Session ${today()} — ${session.summary}`,
    `description: Key decisions and outcomes from ck session ${sessionId.slice(0, 8)}`,
    `type: project`,
    `source: ck`,
    `sessionId: ${sessionId}`,
    `---`,
    ``,
    `# Session: ${session.summary}`,
    ``,
    `## Decisions`,
    decisionsBlock,
    ``,
    `## Left Off`,
    session.leftOff || '—',
    ``,
    `## Next Steps`,
    nextBlock,
    ``,
    `## Blockers`,
    blockersBlock,
    ``,
    ...(gitActivity ? [`## Git Activity`, gitActivity, ``] : []),
    ...(session.activeFiles?.length ? [`## Active Files`, session.activeFiles.map(f => `- ${f}`).join('\n'), ``] : []),
    ...(session.errorState ? [`## Error State`, typeof session.errorState === 'object' ? `- **Expected:** ${session.errorState.expected}\n- **Actual:** ${session.errorState.actual}${session.errorState.location ? `\n- **Location:** ${session.errorState.location}` : ''}` : session.errorState, ``] : []),
  ].join('\n');

  writeFileSync(memFile, memContent, 'utf8');
} catch (e) {
  // Non-fatal — native memory write failure should not block the save
  process.stderr.write(`ck: warning — could not write native memory entry: ${e.message}\n`);
}

console.log(`✓ Saved. Session: ${sessionId.slice(0, 8)}`);
if (gitActivity) console.log(`  Git: ${gitActivity}`);

// ── Handoff mode: create portable markdown doc ────────────────────────────────
if (isHandoff) {
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
  const projectSlug = basename(cwd).toLowerCase().replace(/[^a-z0-9-]/g, '-');
  // Save to project root, not $TMPDIR
  const handoffFile = resolve(cwd, `ck-handoff-${timestamp}.md`);

  // Redact sensitive patterns
  const redact = (str) => {
    if (!str) return str;
    return str
      .replace(/\b[A-Za-z0-9_-]{20,}\b/g, '[REDACTED-TOKEN]')
      .replace(/\b[\w.-]+@[\w.-]+\.\w+\b/g, '[REDACTED-EMAIL]')
      .replace(/\b(?:sk|pk|api|key|token|secret|password)[-_]?[a-zA-Z0-9_-]{8,}\b/gi, '[REDACTED-SECRET]');
  };

  const handoffContent = [
    `# Session Handoff`,
    ``,
    `Generated: ${new Date().toISOString()}`,
    `Project: ${context.displayName || context.name}`,
    `Path: ${cwd}`,
    ``,
    ...(handoffFocus ? [`## Focus for Next Session`, ``, handoffFocus, ``] : []),
    `## Summary`,
    ``,
    redact(session.summary),
    ``,
    `## Current State`,
    ``,
    redact(session.leftOff || 'No active work recorded'),
    ``,
    `## Next Steps`,
    ``,
    session.nextSteps.length
      ? session.nextSteps.map((s, i) => `${i + 1}. ${redact(s)}`).join('\n')
      : '- None recorded',
    ``,
    ...(session.decisions.length ? [
      `## Key Decisions`,
      ``,
      session.decisions.map(d => `- **${redact(d.what)}** — ${redact(d.why || '')}`).join('\n'),
      ``
    ] : []),
    ...(session.activeFiles?.length ? [
      `## Active Files`,
      ``,
      session.activeFiles.map(f => `- \`${f}\``).join('\n'),
      ``
    ] : []),
    ...(session.codeContext ? [
      `## Code Context`,
      ``,
      redact(session.codeContext),
      ``
    ] : []),
    ...(session.blockers.length ? [
      `## Blockers`,
      ``,
      session.blockers.map(b => `- ${redact(b)}`).join('\n'),
      ``
    ] : []),
    ...(suggestedSkills?.length ? [
      `## Suggested Skills`,
      ``,
      suggestedSkills.map(s => `- ${s}`).join('\n'),
      ``
    ] : []),
    ...(gitActivity ? [
      `## Git Activity`,
      ``,
      gitActivity,
      ``
    ] : []),
    ...(session.errorState ? [
      `## Error State`,
      ``,
      typeof session.errorState === 'object'
        ? `- **Expected:** ${redact(session.errorState.expected)}\n- **Actual:** ${redact(session.errorState.actual)}${session.errorState.location ? `\n- **Location:** \`${session.errorState.location}\`` : ''}`
        : redact(session.errorState),
      ``
    ] : []),
    ...(session.failedApproaches?.length ? [
      `## Failed Approaches`,
      ``,
      session.failedApproaches.map(a => `- ${redact(a)}`).join('\n'),
      ``
    ] : []),
    ...(session.taskProgress ? [
      `## Task Progress`,
      ``,
      redact(session.taskProgress),
      ``
    ] : []),
    `---`,
    ``,
    `*Generated by ck (Context Keeper) for agent transfer*`,
  ].join('\n');

  writeFileSync(handoffFile, handoffContent, 'utf8');
  console.log(`\n✓ Handoff doc created:`);
  console.log(`  ${handoffFile}`);
}

console.log(`  See you next time.`);
