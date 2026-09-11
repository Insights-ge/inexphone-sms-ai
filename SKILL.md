# InexPhone SMS Integration Skill

## Purpose

This skill provides AI coding assistants with accurate, project-specific knowledge for integrating and using the Laravel package:

`insightsge/laravel-inexphone-sms`

The package provides a Laravel integration for the InexPhone SMS API.

The goal of this skill is to help AI assistants implement InexPhone SMS functionality correctly without inventing APIs, duplicating existing functionality, or making unsupported assumptions.

---

## Package Information

**Package:** `insightsge/laravel-inexphone-sms`

**Current documented version:** `v1.2.0`

**API Base URL:**

`https://smsservice.inexphone.ge/api/v1`

**Authentication:** Bearer token

**Framework:** Laravel

**HTTP client:** Laravel HTTP Client

---

# Absolute Rules

These rules are mandatory.

## 1. DO NOT INVENT ANYTHING

Do not invent:

* methods
* classes
* endpoints
* parameters
* configuration keys
* environment variables
* request fields
* response fields
* package behavior
* API behavior

If something is not documented or verifiable from the package source, do not claim that it exists.

---

## 2. DO NOT ASSUME

Never assume that an undocumented feature, parameter, endpoint, or behavior exists.

If something is unclear:

1. Check `SKILL.md`.
2. Check the relevant file in `docs/`.
3. Inspect the package source if available.
4. Ask for clarification if it still cannot be verified.

Do not turn assumptions into implementation.

---

## 3. DO NOT CREATE DUPLICATE IMPLEMENTATIONS

If the package already provides functionality, use the package's existing API.

Do not create your own:

* HTTP client
* API wrapper
* service
* helper
* request implementation
* authentication implementation
* endpoint implementation

unless the user explicitly requests it.

---

## 4. DO NOT BYPASS THE PACKAGE

When functionality is already provided by the package, use the package instead of making direct HTTP requests to InexPhone.

For example, prefer:

```php
use Inexphone\Sms\Facades\Sms;

Sms::send(
    $phone,
    $subject,
    $message
);
```

Do not replace this with a manually implemented request such as:

```php
Http::withToken($token)->post(...);
```

when the package already provides the required functionality.

---

## 5. DO NOT CHANGE THE PUBLIC API UNNECESSARILY

Do not:

* rename public methods
* change method signatures
* remove public methods
* change documented behavior
* introduce breaking changes

unless explicitly requested.

---

## 6. DOCUMENTATION IS THE SOURCE OF TRUTH

The following files contain the detailed package documentation:

* `docs/installation.md`
* `docs/sms.md`
* `docs/otp.md`
* `docs/blacklist.md`

Use these documents together with `SKILL.md`.

---

## 7. PACKAGE SOURCE OVERRIDES ASSUMPTIONS

If documentation is unclear, inspect the actual package source before making assumptions.

Never fill missing information with guessed code.

---

## 8. IF YOU CANNOT VERIFY IT, SAY SO

If something cannot be verified, explicitly state that it cannot be verified.

Do not present guesses as facts.

---

## 9. PRESERVE THE EXISTING LARAVEL PROJECT

When integrating the package into an existing Laravel application:

* follow the existing architecture
* follow existing naming conventions
* follow existing validation patterns
* follow existing error handling
* follow existing testing conventions
* avoid unrelated refactoring

Do not restructure the application unnecessarily.

---

## 10. KEEP CHANGES MINIMAL

Only modify what is required for the requested task.

Do not modify unrelated files.

Do not perform unnecessary refactoring.

---

## 11. DO NOT EXPOSE SECRETS

Never:

* hardcode API tokens
* commit API tokens
* print API tokens
* expose credentials
* place secrets directly in source code

Use environment variables for credentials.

---

## 12. TEST CHANGES

When modifying InexPhone integration code:

* add or update appropriate tests
* preserve existing tests
* run relevant tests
* verify the implementation before considering the task complete

---

# Installation

Install the package using Composer:

```bash
composer require insightsge/laravel-inexphone-sms
```

Do not manually copy the package source into the Laravel application.

---

# Configuration

The package uses environment variables for its configuration.

Example:

```env
INEXPHONE_SMS_BASE_URL=https://smsservice.inexphone.ge/api/v1
INEXPHONE_SMS_TOKEN=your-api-token
INEXPHONE_SMS_LANGUAGE=ka
INEXPHONE_SMS_TIMEOUT=30
```

Never hardcode the API token.

After changing environment configuration, use the appropriate Laravel configuration/cache commands when required by the application.

---

# Facade

The package provides the `Sms` facade.

Import it with:

```php
use Inexphone\Sms\Facades\Sms;
```

Use the facade to access the package's SMS, OTP, and blacklist functionality.

---

# Supported API

The package currently supports the following operations:

| Method             | HTTP | Endpoint           | Purpose                      |
| ------------------ | ---- | ------------------ | ---------------------------- |
| `send()`           | POST | `/sms/one`         | Send a single SMS            |
| `sendCommercial()` | POST | `/sms/commercial`  | Send a commercial SMS        |
| `sendBulk()`       | POST | `/sms/bulk`        | Send SMS to multiple numbers |
| `list()`           | GET  | `/sms`             | Get SMS list                 |
| `find()`           | GET  | `/sms/{uuid}`      | Get a single SMS             |
| `sendOtp()`        | POST | `/otp/send`        | Send an OTP                  |
| `verifyOtp()`      | POST | `/otp/verify`      | Verify an OTP                |
| `blacklists()`     | GET  | `/blacklists`      | Get blacklist records        |
| `findBlacklist()`  | GET  | `/blacklists/{id}` | Get one blacklist record     |

Only use documented methods and endpoints.

---

# SMS API

## Send Single SMS

Use `send()` to send a single SMS.

Signature:

```php
Sms::send(
    string $phone,
    string $subject,
    string $message,
    bool $ignoreBlacklist = false,
    ?string $submitCallbackUrl = null,
    ?string $deliveryCallbackUrl = null
);
```

Example:

```php
$response = Sms::send(
    '+9955XXXXXXXX',
    'MyApp',
    'Your verification code is 1234.'
);
```

Optional blacklist handling:

```php
$response = Sms::send(
    '+9955XXXXXXXX',
    'MyApp',
    'Your message',
    true
);
```

Optional callbacks:

```php
$response = Sms::send(
    '+9955XXXXXXXX',
    'MyApp',
    'Your message',
    false,
    'https://example.com/sms/submit-callback',
    'https://example.com/sms/delivery-callback'
);
```

### Important

The subject must comply with the API's subject restrictions.

The InexPhone API restricts the subject to a maximum of **11 characters**.

Do not invent longer subject values.

---

# Commercial SMS

Use:

```php
Sms::sendCommercial(...)
```

for commercial SMS functionality.

Before implementing or modifying commercial SMS behavior, consult:

`docs/sms.md`

Do not invent request parameters or endpoint behavior.

---

# Bulk SMS

Use:

```php
Sms::sendBulk(
    string $subject,
    string $message,
    array $phoneNumbers,
    ?string $submitCallbackUrl = null,
    ?string $deliveryCallbackUrl = null
);
```

Example:

```php
$response = Sms::sendBulk(
    'MyApp',
    'Your promotional message.',
    [
        '+9955XXXXXXXX',
        '+9955YYYYYYYY',
    ]
);
```

With callbacks:

```php
$response = Sms::sendBulk(
    'MyApp',
    'Your message.',
    [
        '+9955XXXXXXXX',
        '+9955YYYYYYYY',
    ],
    'https://example.com/sms/submit-callback',
    'https://example.com/sms/delivery-callback'
);
```

Do not manually loop over `Sms::send()` when the intended operation is supported by `sendBulk()`.

---

# List SMS

Use:

```php
Sms::list()
```

to retrieve SMS records.

Example:

```php
$response = Sms::list();
```

The response may contain:

* `data`
* `meta`
* `message`

Do not assume a response key exists unless it is documented or verified.

---

# Find SMS

Use:

```php
Sms::find($uuid)
```

Example:

```php
$response = Sms::find($uuid);
```

The identifier is the SMS UUID.

Do not invent a different identifier format.

---

# OTP API

The package supports sending and verifying OTP codes.

---

## Send OTP

Use:

```php
Sms::sendOtp(
    string $phone,
    string $subject,
    ?string $text = null,
    ?int $expiresIn = null,
    ?int $codeDigits = null
);
```

Example:

```php
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'MyApp'
);
```

With custom text:

```php
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'MyApp',
    'Your verification code is: {{CODE}}'
);
```

With expiration and code length:

```php
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'MyApp',
    null,
    120,
    6
);
```

### OTP defaults

The API defaults are:

* Text: `Your verification code is: {{CODE}}`
* Expiration: `60` seconds
* Code length: `4` digits

Do not assume different defaults.

### Important

The OTP subject is still subject to the API's subject restrictions.

Maximum subject length:

**11 characters**

---

# Verify OTP

Use:

```php
Sms::verifyOtp(
    string $phone,
    string $code
);
```

Example:

```php
$response = Sms::verifyOtp(
    '+9955XXXXXXXX',
    $code
);
```

### Critical rule

`verifyOtp()` requires only:

* phone
* code

Do **not** add a subject.

Do not invent additional parameters.

---

# Blacklist API

The package currently provides read-only blacklist functionality.

Supported methods:

```php
Sms::blacklists()
```

and:

```php
Sms::findBlacklist($id)
```

There are no documented package methods for creating or deleting blacklist records.

Do not invent:

```php
Sms::addBlacklist(...)
Sms::deleteBlacklist(...)
Sms::removeBlacklist(...)
```

or equivalent methods.

---

# List Blacklists

Use:

```php
Sms::blacklists()
```

The blacklist API supports pagination and filters.

Documented query parameters include:

```text
page
perPage
filters[keywords]
filters[subjects]
filters[number]
filters[dateEnd]
```

The `dateEnd` format is:

```text
d/m/Y
```

Example:

```php
$response = Sms::blacklists();
```

The response can contain:

```php
[
    'data' => [...],
    'meta' => [...],
    'message' => 'ok',
]
```

Do not assume that `data` contains records. An empty blacklist is a valid response.

---

# Find Blacklist

Use:

```php
Sms::findBlacklist($id)
```

Example:

```php
$response = Sms::findBlacklist('2');
```

The blacklist identifier is a string.

If the requested ID does not exist, the API may return an error.

Do not interpret a missing blacklist record as a package implementation failure without checking the actual API response.

---

# Blacklist vs ignoreBlacklist

The `ignoreBlacklist` argument of `Sms::send()` controls blacklist behavior when sending an SMS.

It does **not** create, update, or delete blacklist records.

Do not confuse:

```php
Sms::send(
    $phone,
    $subject,
    $message,
    true
);
```

with a blacklist-management operation.

---

# Authentication

The package communicates with the InexPhone API using a bearer token.

The API token must be configured through environment configuration.

Never put a real token directly into:

* controllers
* models
* services
* routes
* tests committed to source control
* documentation
* README files

Use:

```env
INEXPHONE_SMS_TOKEN=your-api-token
```

---

# Language

The package supports configurable request language through:

```env
INEXPHONE_SMS_LANGUAGE=ka
```

Use the package configuration rather than manually constructing language headers in application code.

Do not invent unsupported language codes.

---

# Timeout

The HTTP timeout can be configured through:

```env
INEXPHONE_SMS_TIMEOUT=30
```

Use the package configuration instead of creating a separate HTTP timeout implementation.

---

# Responses

Package methods return arrays containing API response data.

Depending on the endpoint, responses may contain:

```php
[
    'data' => ...,
    'meta' => ...,
    'message' => ...
]
```

Do not assume every endpoint returns the exact same structure.

Check the relevant documentation or actual API response before accessing nested fields.

---

# Error Handling

The package provides:

```php
SmsException
```

for package/API-related failures.

Do not silently ignore package exceptions.

Example:

```php
use Inexphone\Sms\Exceptions\SmsException;

try {
    $response = Sms::send(
        '+9955XXXXXXXX',
        'MyApp',
        'Your message'
    );
} catch (SmsException $e) {
    // Handle the SMS API/package error.
}
```

Follow the application's existing exception-handling conventions.

Do not expose internal API errors or credentials directly to end users unless the application explicitly requires it.

---

# Laravel Integration Guidelines

When integrating the package into a Laravel application:

* use dependency injection where appropriate
* use the `Sms` facade when appropriate
* keep API logic out of Blade templates
* avoid duplicating package functionality
* follow the application's existing service/controller architecture
* validate user input before sending requests
* handle API failures appropriately
* do not expose API credentials
* keep environment-specific configuration in `.env`

Do not introduce a new service layer solely to wrap one package method unless the application's architecture requires it.

---

# Controllers

Controllers should coordinate application behavior rather than manually implement the InexPhone API.

Good:

```php
public function sendCode(Request $request)
{
    $response = Sms::sendOtp(
        $request->phone,
        'MyApp'
    );

    return response()->json($response);
}
```

Avoid manually implementing the API request in the controller when the package already provides the required functionality.

---

# Validation

Validate user input before passing it to the package.

Example:

```php
$request->validate([
    'phone' => ['required', 'string'],
]);
```

Use the project's existing Form Request conventions when appropriate.

Do not add validation rules that are not required by the application or verified API requirements.

---

# Testing

When testing application code that uses the package:

* test your application's behavior
* mock/fake external HTTP communication where appropriate
* avoid requiring the real InexPhone API for every automated test
* never commit real API credentials
* keep tests deterministic

When modifying the package itself:

* update package tests
* run PHPUnit
* run PHPStan when configured
* verify the public API remains compatible

---

# Common Mistakes

## Mistake 1: Inventing methods

Wrong:

```php
Sms::sendVerificationCode(...)
```

if that method does not exist.

Use the documented API:

```php
Sms::sendOtp(...)
```

---

## Mistake 2: Adding parameters that do not exist

Wrong:

```php
Sms::verifyOtp(
    $phone,
    $code,
    $subject
);
```

Correct:

```php
Sms::verifyOtp(
    $phone,
    $code
);
```

---

## Mistake 3: Direct API calls

Do not manually reproduce package functionality with:

```php
Http::withToken(...)
```

when the package already provides the operation.

---

## Mistake 4: Inventing blacklist mutations

Do not create:

```php
Sms::addBlacklist(...)
```

or:

```php
Sms::deleteBlacklist(...)
```

because the documented package API currently provides blacklist listing and lookup, not those mutation methods.

---

## Mistake 5: Assuming an empty response means failure

For example:

```php
[
    'data' => [],
    'meta' => [
        'pagination' => [
            'total' => 0,
        ],
    ],
    'message' => 'ok',
]
```

can simply mean that there are currently no blacklist records.

---

## Mistake 6: Hardcoding credentials

Never do:

```php
$token = 'real-api-token';
```

Use environment configuration.

---

## Mistake 7: Reimplementing bulk SMS manually

Do not unnecessarily do:

```php
foreach ($phones as $phone) {
    Sms::send($phone, $subject, $message);
}
```

when the intended operation is supported by:

```php
Sms::sendBulk(
    $subject,
    $message,
    $phones
);
```

---

# Source of Truth

When working with this package, use the following priority:

### 1. Actual package source

If available, verify behavior against the package source.

### 2. Package documentation

Use:

```text
docs/installation.md
docs/sms.md
docs/otp.md
docs/blacklist.md
```

### 3. SKILL.md

This file provides the consolidated knowledge and rules for AI assistants.

### 4. User's explicit requirements

If the user explicitly requests behavior that differs from the documented package behavior, explain the difference and implement only what is technically supported.

Never invent missing functionality.

---

# Final Checklist

Before completing an InexPhone SMS integration task, verify:

* [ ] The package `insightsge/laravel-inexphone-sms` is being used.
* [ ] The requested method actually exists.
* [ ] The requested endpoint is documented.
* [ ] All parameters are verified.
* [ ] No undocumented parameters were added.
* [ ] No duplicate HTTP implementation was created.
* [ ] API credentials are stored securely.
* [ ] Existing Laravel architecture was preserved.
* [ ] Appropriate validation exists.
* [ ] Errors are handled appropriately.
* [ ] Tests were added or updated when necessary.
* [ ] No unrelated files were modified.

---

# Final Principle

> **If it isn't documented or verifiable from the package source, don't invent it.**

**Do not invent.**

**Do not assume.**

**Do not bypass the package.**

**Do not duplicate functionality that already exists.**

**Verify first, implement second.**
