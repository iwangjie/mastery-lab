#!/usr/bin/env node
import { existsSync, readdirSync, readFileSync, statSync } from "node:fs";
import { dirname, extname, join, normalize, resolve } from "node:path";

const root = resolve(new URL("..", import.meta.url).pathname);
const markdownFiles = [];

function walk(dir) {
  for (const name of readdirSync(dir)) {
    if (name === ".git" || name === "work" || name === "node_modules") continue;
    const path = join(dir, name);
    const stat = statSync(path);
    if (stat.isDirectory()) {
      walk(path);
    } else if (extname(path) === ".md") {
      markdownFiles.push(path);
    }
  }
}

function stripAnchor(target) {
  const hashIndex = target.indexOf("#");
  return hashIndex === -1 ? target : target.slice(0, hashIndex);
}

walk(root);

const problems = [];
const linkPattern = /\[[^\]]+\]\(([^)]+)\)/g;

for (const file of markdownFiles) {
  const content = readFileSync(file, "utf8");
  for (const match of content.matchAll(linkPattern)) {
    const rawTarget = match[1].trim();
    if (
      rawTarget.startsWith("http://") ||
      rawTarget.startsWith("https://") ||
      rawTarget.startsWith("mailto:")
    ) {
      continue;
    }

    const target = stripAnchor(rawTarget);
    if (!target) continue;

    const absoluteTarget = normalize(resolve(dirname(file), target));
    if (!absoluteTarget.startsWith(root) || !existsSync(absoluteTarget)) {
      problems.push(`${file.slice(root.length + 1)} -> ${rawTarget}`);
    }
  }
}

if (problems.length > 0) {
  console.error("Broken local Markdown links:");
  for (const problem of problems) console.error(`- ${problem}`);
  process.exit(1);
}

console.log(`Checked ${markdownFiles.length} Markdown files. Local links are valid.`);

