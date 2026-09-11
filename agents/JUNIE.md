# InexPhone SMS Integration — Junie Guidelines

## Purpose

These guidelines provide Junie with the project-specific knowledge needed to work with the `insightsge/laravel-inexphone-sms` Laravel package.

## Before working with InexPhone SMS

Read the following files from the installed skill:

* `SKILL.md`
* `docs/installation.md`
* `docs/sms.md`
* `docs/otp.md`
* `docs/blacklist.md`

Use the documentation as the source of truth.

## Package

Package name:

`insightsge/laravel-inexphone-sms`

Current documented version:

`v1.2.0`

Install with:

```bash
composer require insightsge/laravel-inexphone-sms
```

## Rules

* Use the package's existing API and public methods.
* Do not invent endpoints, methods, parameters, or response fields.
* Prefer the `Sms` facade when working with the package.
* Follow the existing Laravel project architecture and coding conventions.
* Keep changes focused and minimal.
* Do not expose API tokens or other credentials.
* Never hardcode the InexPhone API token in application code.
* Use environment variables for package configuration.
* When adding functionality, check the existing package documentation before implementing it.
* Add or update tests when changing package integration behavior.

## Important

If the required behavior is not documented in the installed skill, inspect the package source or ask for clarification instead of guessing.

The common source of truth is the installed `SKILL.md` and its `docs/` directory.
