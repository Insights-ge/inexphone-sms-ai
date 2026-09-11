# InexPhone SMS Integration Skill

Official local AI assistant skill for integrating the **InexPhone SMS Laravel package** using OpenAI Codex, Claude Code, Gemini CLI, Cursor, Junie, OpenCode, and other AI coding tools.

This repository packages local source-backed InexPhone SMS package documentation, compact indexes, prompts, examples, and tool-specific instruction files so AI coding tools can help with Laravel SMS integrations without guessing API behavior or crawling external documentation.

Package:

```text
insightsge/laravel-inexphone-sms
```

Current documented version:

```text
v1.2.0
```

---

# Install

Clone the repository:

```bash
git clone https://github.com/Insights-ge/inexphone-sms-package.git
```

Enter the AI knowledge repository:

```bash
cd inexphone-sms-ai
```

Make the installer executable:

```bash
chmod +x install.sh
```

Run the installer:

```bash
./install.sh
```

When run from inside the cloned `inexphone-sms-ai` repository, the installer installs the AI knowledge into the current target project.

Install into a specific project:

```bash
./install.sh --target /path/to/your/project
```

Install for specific tools:

```bash
./install.sh --target /path/to/your/project --tools codex
./install.sh --target /path/to/your/project --tools claude
./install.sh --target /path/to/your/project --tools gemini
./install.sh --target /path/to/your/project --tools cursor
./install.sh --target /path/to/your/project --tools junie
./install.sh --target /path/to/your/project --tools opencode
./install.sh --target /path/to/your/project --tools all
```

Dry run:

```bash
./install.sh --target /path/to/your/project --tools all --dry-run
```

The installer installs AI instruction files and the shared InexPhone knowledge into the target project.

It:

* Creates tool-specific instruction files where required
* Installs the shared skill into supported skill directories
* Creates backups before overwriting existing files or directories
* Tracks backups for safe restoration during uninstall
* Keeps package documentation and examples available locally
* Does not modify application source code
* Supports dry-run mode

To uninstall generated files safely:

```bash
./uninstall.sh --target /path/to/your/project --tools all --dry-run
./uninstall.sh --target /path/to/your/project --tools all
```

---

# What Gets Installed

The installer uses the common knowledge base:

```text
SKILL.md
docs/
examples/
```

Tool-specific instructions are provided separately:

```text
agents/
├── AGENTS.md
├── CLAUDE.md
├── GEMINI.md
├── JUNIE.md
├── OPENCODE.md
└── cursor-rules.md
```

For Codex and Gemini, the shared skill is installed at:

```text
.agents/skills/inexphone-sms-integration-skill/
```

For Claude Code:

```text
.claude/skills/inexphone-sms-integration-skill/
```

For Cursor:

```text
.cursor/rules/inexphone-sms-integration-skill.mdc
```

and:

```text
.cursor/inexphone-sms/
```

For Junie:

```text
.junie/AGENTS.md
```

For OpenCode:

```text
.opencode/skills/inexphone-sms-integration-skill/
```

The installer also creates the appropriate root instruction files for tools that use them, such as:

```text
CLAUDE.md
GEMINI.md
```

---

# Usage Examples

Invocation differs by AI tool.

Use slash commands only in tools that expose installed skills as slash commands.

## OpenAI Codex

Codex uses the repository skill package from:

```text
.agents/skills/inexphone-sms-integration-skill/
```

Invoke it using natural language or by explicitly mentioning the skill.

```text
Use inexphone-sms-integration-skill to implement OTP verification in my Laravel application.
```

```text
Use inexphone-sms-integration-skill to review my InexPhone SMS integration.
```

```text
Use inexphone-sms-integration-skill to debug this failed SMS request.
```

```text
Use inexphone-sms-integration-skill to implement bulk SMS sending.
```

---

## Claude Code

Claude Code uses:

```text
.claude/skills/inexphone-sms-integration-skill/
```

The installed skill can be invoked as:

```text
/inexphone-sms-integration-skill
```

Examples:

```text
/inexphone-sms-integration-skill implement OTP verification
```

```text
Use the inexphone-sms-integration-skill to review this SMS integration.
```

```text
Use the InexPhone source documentation to debug this API response.
```

---

## Gemini CLI

Gemini uses the project context and:

```text
GEMINI.md
```

together with the shared skill:

```text
.agents/skills/inexphone-sms-integration-skill/
```

Invoke it using natural language:

```text
Using inexphone-sms-integration-skill, implement OTP verification in this Laravel project.
```

```text
Review this Laravel InexPhone integration for incorrect API usage.
```

```text
Use the InexPhone documentation to implement bulk SMS sending.
```

---

## Cursor

Cursor uses:

```text
.cursor/rules/inexphone-sms-integration-skill.mdc
```

and the local knowledge in:

```text
.cursor/inexphone-sms/
```

Invoke the skill through natural language:

```text
Use the InexPhone SMS Integration Skill rules to implement OTP verification.
```

```text
Review this SMS integration against the local InexPhone documentation.
```

```text
Use the local InexPhone source documentation to implement bulk SMS.
```

---

## Junie

Junie uses:

```text
.junie/AGENTS.md
```

Invoke the skill through natural language:

```text
Use the InexPhone SMS integration guidelines to implement OTP verification.
```

```text
Review this Laravel SMS integration against the local InexPhone documentation.
```

```text
Implement SMS sending using the existing InexPhone package.
```

---

## OpenCode

OpenCode uses:

```text
.opencode/skills/inexphone-sms-integration-skill/
```

Invoke the skill by asking for it in natural language:

```text
Use inexphone-sms-integration-skill to implement OTP verification.
```

```text
Use inexphone-sms-integration-skill to review this Laravel SMS integration.
```

```text
Use the InexPhone source documentation to debug this SMS request.
```

---

## Generic AI Coding Tools

Use the local repository as the source of knowledge:

```text
./inexphone-sms-ai/
```

Read:

```text
SKILL.md
docs/
examples/
```

Then ask the AI assistant to use the local InexPhone documentation.

Example:

```text
Use the local InexPhone SMS integration skill to implement OTP verification in this Laravel project.
```

---

# What The Skill Helps With

Use this skill for:

* Installing the InexPhone Laravel package
* Configuring the package
* Sending SMS
* Sending commercial SMS
* Sending bulk SMS
* Listing SMS messages
* Finding SMS messages
* Sending OTP codes
* Verifying OTP codes
* Listing blacklists
* Finding blacklist records
* Laravel controllers
* Laravel services
* Form Requests and validation
* Error handling
* API integration
* HTTP testing
* Laravel HTTP fakes
* Integration debugging
* Code review
* Package API questions
* Understanding documented request parameters
* Understanding documented response structures

The skill is specifically designed to prevent AI assistants from inventing unsupported InexPhone functionality.

---

# Package API

The package currently documents these operations.

## SMS

```text
POST /sms/one
POST /sms/commercial
POST /sms/bulk
GET  /sms
GET  /sms/{uuid}
```

## OTP

```text
POST /otp/send
POST /otp/verify
```

## Blacklists

```text
GET /blacklists
GET /blacklists/{id}
```

The currently documented blacklist API is read-only.

Do not invent blacklist creation, deletion, update, or removal methods.

---

# Basic Laravel Example

Import the facade:

```php
use Inexphone\Sms\Facades\Sms;
```

Send an SMS:

```php
$response = Sms::send(
    '+9955XXXXXXXX',
    'MyApp',
    'Hello from Laravel!',
);
```

Send an OTP:

```php
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
);
```

Verify an OTP:

```php
$response = Sms::verifyOtp(
    '+9955XXXXXXXX',
    '1234',
);
```

List blacklists:

```php
$response = Sms::blacklists();
```

These are simplified examples. AI assistants should read the relevant documentation before implementing production functionality.

---

# AI Safety Rules

The skill follows several strict rules.

### Do not invent

Never invent:

```text
API endpoints
Package methods
Request parameters
Response fields
Authentication behavior
OTP behavior
Blacklist operations
```

If required information is not documented, inspect the installed package source.

### Inspect before modifying

Before changing an existing Laravel application:

```text
Inspect Laravel version
Inspect package version
Inspect existing architecture
Search for existing functionality
Reuse existing conventions
Make minimal changes
```

### Protect credentials

Never hardcode or expose:

```text
INEXPHONE_SMS_TOKEN
```

Use environment variables.

### Do not duplicate functionality

If the project already has a suitable service, controller, validation rule, or integration pattern, reuse it instead of creating unnecessary duplicates.

### Do not bypass the package

Use the package's existing public API whenever it supports the required operation.

### Test safely

Do not send real SMS messages from normal automated tests.

Use Laravel HTTP fakes where appropriate.

---

# Source of Truth

The skill follows this priority:

```text
1. Installed package source
          ↓
2. Local skill documentation
          ↓
3. AI-generated code
```

The installed package source has the highest authority for the exact version being used.

The local documentation is based on the documented package behavior.

AI-generated code is never a source of truth.

If the AI output conflicts with the package source, inspect the actual implementation and correct the generated code.

---

# Local Documentation

The repository contains:

```text
SKILL.md
```

Common AI knowledge and integration rules.

```text
docs/installation.md
```

Package installation and configuration.

```text
docs/sms.md
```

SMS API documentation.

```text
docs/otp.md
```

OTP API documentation.

```text
docs/blacklist.md
```

Blacklist API documentation.

Examples:

```text
examples/sms.md
examples/otp.md
examples/blacklist.md
```

---

# Updating The Skill

When a new version of:

```text
insightsge/laravel-inexphone-sms
```

is released:

1. Review the actual package changes.
2. Update `SKILL.md`.
3. Update affected documentation.
4. Update affected examples.
5. Update tool-specific instructions if necessary.
6. Update the documented version.
7. Test the documented behavior.
8. Test the installer when installation behavior changes.
9. Test the uninstaller when uninstall behavior changes.
10. Review for undocumented assumptions.
11. Commit the changes.
12. Create a new release when appropriate.

Do not update documentation simply because the package version changed.

Verify the actual API changes first.

---

# Current Version

```text
Package:
insightsge/laravel-inexphone-sms

Documented version:
v1.2.0
```

Version history:

```text
v1.0.0  Initial Release
v1.0.1  Maintenance & Fixes
v1.1.0  OTP API Support
v1.2.0  Blacklist API Support
```

Release notes should only contain changes that have been verified.

---

# License

Copyright (c) Insights-ge.

---

# Repository Goal

This repository is not another implementation of the InexPhone API.

It is a local AI knowledge and integration skill.

Its purpose is to give AI coding assistants reliable access to:

```text
Laravel
    +
insightsge/laravel-inexphone-sms
    +
InexPhone SMS API
```

without requiring them to crawl external documentation.

The core principle is:

> **Use local, documented, source-backed behavior. Inspect the package when necessary. Preserve the existing Laravel architecture. Never guess API functionality.**

Copyright (c) Insights Consulting