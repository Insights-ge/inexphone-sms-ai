# InexPhone SMS AI Knowledge

AI coding knowledge and instructions for integrating the **InexPhone SMS Laravel package** into Laravel applications.

Package:

```text
insightsge/laravel-inexphone-sms
```

Current documented version:

```text
v1.2.0
```

This repository is designed to provide a shared source of knowledge for:

* OpenAI Codex
* GitHub Copilot
* Claude Code
* Gemini CLI
* Cursor

The goal is simple:

> Give AI coding assistants reliable, structured knowledge about the InexPhone Laravel SMS package so they can generate correct integration code without guessing API behavior.

---

# Repository Structure

```text
inexphone-sms-ai/
│
├── README.md
├── SKILL.md
│
├── docs/
│   ├── installation.md
│   ├── sms.md
│   ├── otp.md
│   └── blacklists.md
│
├── examples/
│   ├── sms.md
│   ├── otp.md
│   └── blacklists.md
│
└── agents/
    ├── AGENTS.md
    ├── copilot-instructions.md
    ├── CLAUDE.md
    ├── GEMINI.md
    └── cursor-rules.md
```

---

# How the Repository Works

The repository separates common knowledge from tool-specific instructions.

```text
                    ┌─────────────┐
                    │  SKILL.md   │
                    │ Common Core │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
              ▼            ▼            ▼
           docs/       examples/     agents/
              │            │            │
              └────────────┴────────────┘
                           │
          ┌────────────────┼────────────────┐
          │        │       │       │       │
          ▼        ▼       ▼       ▼       ▼
        Codex   Copilot Claude Gemini  Cursor
```

### `SKILL.md`

Contains the core knowledge that an AI assistant needs to understand the package.

### `docs/`

Contains detailed technical documentation.

### `examples/`

Contains practical Laravel implementation examples.

### `agents/`

Contains instructions adapted for each AI coding assistant.

This prevents the same large documentation from being duplicated across every AI tool.

---

# Package Overview

The package provides a Laravel client for the InexPhone SMS API.

API base URL:

```text
https://smsservice.inexphone.ge/api/v1
```

The package handles:

* Bearer authentication
* API requests
* `Accept-Language`
* Configurable HTTP timeout
* SMS operations
* OTP operations
* Blacklist lookup
* API/package exceptions

---

# Installation

Install the Laravel package with Composer:

```bash
composer require insightsge/laravel-inexphone-sms
```

Configure the environment:

```env
INEXPHONE_SMS_BASE_URL=https://smsservice.inexphone.ge/api/v1
INEXPHONE_SMS_TOKEN=your-api-token
INEXPHONE_SMS_LANGUAGE=ka
INEXPHONE_SMS_TIMEOUT=30
```

The API token must remain secret.

For the complete setup guide, see:

```text
docs/installation.md
```

---

# Supported API

## SMS

```php
Sms::send();
Sms::sendCommercial();
Sms::sendBulk();

Sms::list();
Sms::find();
```

Endpoints:

```text
POST /sms/one
POST /sms/commercial
POST /sms/bulk
GET  /sms
GET  /sms/{uuid}
```

Detailed documentation:

```text
docs/sms.md
```

Examples:

```text
examples/sms.md
```

---

## OTP

```php
Sms::sendOtp();
Sms::verifyOtp();
```

Endpoints:

```text
POST /otp/send
POST /otp/verify
```

Important:

```php
Sms::verifyOtp(
    $phone,
    $code,
);
```

The verification request uses only the phone number and code.

Detailed documentation:

```text
docs/otp.md
```

Examples:

```text
examples/otp.md
```

---

## Blacklists

```php
Sms::blacklists();
Sms::findBlacklist();
```

Endpoints:

```text
GET /blacklists
GET /blacklists/{id}
```

The current documented blacklist API is read-only.

There are no documented package methods for:

```text
add blacklist
delete blacklist
remove blacklist
update blacklist
```

Detailed documentation:

```text
docs/blacklists.md
```

Examples:

```text
examples/blacklists.md
```

---

# Basic Usage

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

---

# Error Handling

The package provides:

```php
use Inexphone\Sms\Exceptions\SmsException;
```

Example:

```php
try {
    $response = Sms::send(
        '+9955XXXXXXXX',
        'MyApp',
        'Hello!',
    );
} catch (SmsException $e) {
    report($e);
}
```

AI assistants should follow the application's existing Laravel error-handling architecture rather than introducing unnecessary patterns.

---

# AI Assistant Rules

All AI assistants using this repository should follow these rules.

## 1. Do not guess

Never invent:

* API endpoints
* Package methods
* Request parameters
* Response fields
* Authentication behavior
* Blacklist operations
* OTP operations

If something is not documented, inspect the actual package source before making a claim.

---

## 2. Use the official package

Use:

```text
insightsge/laravel-inexphone-sms
```

Do not replace it with another SMS package unless the user explicitly requests an alternative.

---

## 3. Inspect the user's project

Before modifying an existing Laravel application:

1. Inspect the Laravel version.
2. Inspect the installed package version.
3. Inspect the existing application architecture.
4. Check existing services/controllers/forms.
5. Reuse existing conventions.
6. Make the smallest appropriate change.

Do not blindly copy examples into an existing project.

---

## 4. Protect credentials

Never place the InexPhone API token in:

* Git
* JavaScript
* Blade templates
* Controllers
* Public configuration
* Logs
* Error responses

Use environment variables.

---

## 5. Test safely

Normal automated tests should not send real SMS messages.

Prefer Laravel HTTP fakes:

```php
Http::fake([
    'smsservice.inexphone.ge/*' => Http::response([
        'message' => 'ok',
    ], 200),
]);
```

---

# Using With Codex

The Codex-specific instructions are located at:

```text
agents/AGENTS.md
```

When using this repository as a knowledge source, Codex should read:

```text
SKILL.md
docs/
examples/
agents/AGENTS.md
```

The `AGENTS.md` file can be adapted/copied into the target Laravel project's appropriate Codex/agent instruction location.

---

# Using With GitHub Copilot

The Copilot-specific instructions are located at:

```text
agents/copilot-instructions.md
```

When integrating this knowledge into a Laravel project, adapt the file to the project's Copilot instruction location.

The source file in this repository is intentionally kept separate so the repository can support multiple AI tools without duplicating the entire knowledge base.

---

# Using With Claude Code

Claude Code instructions are located at:

```text
agents/CLAUDE.md
```

Claude should use:

```text
SKILL.md
docs/
examples/
agents/CLAUDE.md
```

The instruction file can be adapted into the target project's Claude configuration.

---

# Using With Gemini CLI

Gemini-specific instructions are located at:

```text
agents/GEMINI.md
```

Gemini should use the common knowledge from:

```text
SKILL.md
docs/
examples/
```

together with:

```text
agents/GEMINI.md
```

---

# Using With Cursor

Cursor-specific rules are located at:

```text
agents/cursor-rules.md
```

This file acts as the source/template for Cursor rules.

When installing the knowledge into another Laravel project, adapt the file to that project's Cursor rules structure rather than copying the entire repository into the application.

---

# Recommended AI Workflow

When an AI assistant receives a request involving InexPhone SMS:

### Step 1 — Identify the operation

Determine whether the request involves:

```text
Installation
SMS
OTP
Blacklist
Error handling
Testing
Architecture
```

### Step 2 — Read the relevant documentation

For example:

```text
OTP request
    ↓
SKILL.md
    ↓
docs/otp.md
    ↓
examples/otp.md
```

### Step 3 — Inspect the actual Laravel project

Check:

* Existing package version
* Controllers
* Services
* Requests
* Routes
* Tests
* Configuration

### Step 4 — Implement

Use the documented package API and existing project architecture.

### Step 5 — Verify

Run relevant:

```bash
php artisan test
```

and, when configured:

```bash
vendor/bin/phpstan analyse
```

---

# Source of Truth

There are three levels of authority.

## 1. Installed Package Source

When working inside a Laravel application, the installed package source is the highest authority for the exact installed version.

For example:

```text
vendor/insightsge/laravel-inexphone-sms/
```

---

## 2. This Knowledge Repository

The following files describe the documented behavior:

```text
SKILL.md
docs/
examples/
```

---

## 3. AI-Generated Code

Generated code is never a source of truth.

If generated code conflicts with the package source or documentation, inspect the actual implementation and correct the generated code.

---

# Updating This Repository

When the Laravel package receives a new version:

1. Review the package changes.
2. Update `SKILL.md`.
3. Update affected files in `docs/`.
4. Update affected examples.
5. Update the AI-specific instruction files if necessary.
6. Update the documented package version.
7. Test the examples.
8. Review for undocumented assumptions.
9. Commit the changes.
10. Create a new Git tag/release when appropriate.

Do not update the documentation merely because a version number changed. Review the actual API changes.

---

# Current Version

This repository currently documents:

```text
insightsge/laravel-inexphone-sms
v1.2.0
```

Version history:

```text
v1.0.0  Initial Release
v1.0.1  Maintenance & Fixes
v1.1.0  OTP API Support
v1.2.0  Blacklist API Support
```

Release notes should describe only changes that are actually confirmed.

---

# Repository Goal

This repository is not another implementation of the InexPhone API.

It is an **AI knowledge and instruction repository**.

Its purpose is to make AI coding assistants better at working with:

```text
Laravel
    +
insightsge/laravel-inexphone-sms
    +
InexPhone SMS API
```

The central principle is:

> **Use documented behavior, inspect the source when necessary, and never guess API functionality.**
