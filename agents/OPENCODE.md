---

name: inexphone-sms-integration
description: Guidelines and reference documentation for integrating the InexPhone SMS Laravel package
compatibility: opencode
-----------------------

# InexPhone SMS Integration

Use this skill when working with the Laravel package:

`insightsge/laravel-inexphone-sms`

## Source of truth

Before implementing or modifying InexPhone SMS functionality, read:

* `SKILL.md`
* `docs/installation.md`
* `docs/sms.md`
* `docs/otp.md`
* `docs/blacklist.md`

## Rules

* Use only documented package APIs and endpoints.
* Do not invent methods, parameters, endpoints, or response structures.
* Prefer the package's existing `Sms` facade.
* Follow the existing Laravel architecture and coding conventions.
* Keep changes focused and minimal.
* Never hardcode API credentials.
* Use environment variables for configuration.
* Add or update tests when changing integration behavior.
* If the documentation does not contain the required information, inspect the package source before making assumptions.

## Package

Package:

`insightsge/laravel-inexphone-sms`

Current documented version:

`v1.2.0`

Installation:

```bash
composer require insightsge/laravel-inexphone-sms
```
