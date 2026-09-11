# InexPhone SMS — Gemini CLI Instructions

## Purpose

These instructions provide Gemini CLI with reliable guidance for integrating **InexPhone SMS** into Laravel applications.

The official Laravel package is:

```text
insightsge/laravel-inexphone-sms
```

The main reference is:

```text
../SKILL.md
```

Detailed documentation:

```text
../docs/
```

Examples:

```text
../examples/
```

---

## Before Making Changes

When working on an InexPhone integration:

1. Read `SKILL.md`.
2. Read the relevant documentation in `docs/`.
3. Check relevant examples in `examples/`.
4. Inspect the existing Laravel application's architecture.
5. Implement only documented functionality.
6. Run relevant tests after making changes.

Do not guess undocumented InexPhone behavior.

---

## Package Installation

Install the official package:

```bash
composer require insightsge/laravel-inexphone-sms
```

Use:

```php
use Inexphone\Sms\Facades\Sms;
```

Current documented version:

```text
v1.2.0
```

---

## Supported Methods

The package provides these methods:

```text
Sms::send()
Sms::sendCommercial()
Sms::sendBulk()
Sms::list()
Sms::find()
Sms::sendOtp()
Sms::verifyOtp()
Sms::blacklists()
Sms::findBlacklist()
```

These are the supported package methods.

Do not invent additional methods.

---

# SMS API

## Single SMS

```php
$response = Sms::send(
    phone: '995555111111',
    subject: 'MyApp',
    message: 'Hello from Laravel!',
);
```

Optional parameters:

```text
ignoreBlacklist
submitCallbackUrl
deliveryCallbackUrl
```

---

## Commercial SMS

```php
$response = Sms::sendCommercial(
    phone: '995555111111',
    subject: 'MyApp',
    message: 'Your commercial message.',
);
```

---

## Bulk SMS

```php
$response = Sms::sendBulk(
    subject: 'MyApp',
    message: 'Your message.',
    phoneNumbers: [
        '995555111111',
        '995599999999',
    ],
);
```

Optional callback parameters:

```text
submitCallbackUrl
deliveryCallbackUrl
```

---

# SMS History

List sent SMS messages:

```php
$response = Sms::list();
```

Example pagination parameters:

```php
$response = Sms::list([
    'page' => 1,
    'perPage' => 20,
]);
```

Find a specific SMS:

```php
$response = Sms::find('sms-uuid');
```

Only use query parameters that are documented for the relevant endpoint.

---

# OTP API

## Send OTP

```php
$response = Sms::sendOtp(
    phone: '995555111111',
    subject: 'MyApp',
);
```

Optional arguments:

```text
text
expiresIn
codeDigits
```

Example:

```php
$response = Sms::sendOtp(
    phone: '995555111111',
    subject: 'MyApp',
    text: 'Your verification code is: {{CODE}}',
    expiresIn: 60,
    codeDigits: 4,
);
```

The InexPhone API supplies defaults for optional OTP settings.

Keep the subject within the API's allowed length.

---

## Verify OTP

```php
$response = Sms::verifyOtp(
    phone: '995555111111',
    code: '1552',
);
```

The verification request contains:

```text
phone
code
```

Do not add `subject` to the verification request.

---

# Blacklist API

## List Blacklists

```php
$response = Sms::blacklists();
```

Pagination:

```php
$response = Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
]);
```

Filtering:

```php
$response = Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
    'filters' => [
        'keywords' => '555',
        'subjects' => 'MyApp',
        'number' => '995555555555',
        'dateEnd' => '11/09/2026',
    ],
]);
```

Documented filters:

```text
filters[keywords]
filters[subjects]
filters[number]
filters[dateEnd]
```

The `dateEnd` value uses:

```text
d/m/Y
```

format.

---

## Find a Blacklist Record

```php
$response = Sms::findBlacklist('blacklist-id');
```

The documented blacklist endpoints are:

```text
GET /blacklists
GET /blacklists/{id}
```

The current package does not provide blacklist creation or deletion methods.

Do not invent them.

---

# Configuration

Use environment variables:

```env
INEXPHONE_SMS_BASE_URL=https://smsservice.inexphone.ge/api/v1
INEXPHONE_SMS_TOKEN=your-api-token
INEXPHONE_SMS_LANGUAGE=ka
INEXPHONE_SMS_TIMEOUT=30
```

The API token must remain server-side.

Never put the token in:

* frontend JavaScript
* Blade templates
* public repositories
* client-side environment variables
* documentation containing real credentials

---

# Authentication

The InexPhone API uses bearer-token authentication.

The Laravel package handles authentication internally.

Application code should provide the token through configuration rather than manually adding authorization headers to every call.

---

# Error Handling

API failures are represented by:

```php
use Inexphone\Sms\Exceptions\SmsException;
```

Example:

```php
try {
    $response = Sms::send(
        phone: '995555111111',
        subject: 'MyApp',
        message: 'Hello!',
    );
} catch (SmsException $exception) {
    // Handle the API error.
}
```

The exception may contain:

* API error message
* HTTP status code
* validation errors

Do not expose sensitive internal error details to application users.

---

# Laravel Architecture

Gemini CLI should follow the architecture already used by the Laravel project.

For simple integrations:

```php
Sms::send(...);
```

is appropriate.

For reusable application logic, dependency injection can use:

```php
Inexphone\Sms\Contracts\SmsClientInterface
```

Avoid adding unnecessary abstraction.

If the project already uses service classes for external integrations, place reusable InexPhone logic there rather than duplicating API calls across controllers.

Use Laravel validation before sending user-provided data to the external API.

---

# Testing

Do not make real InexPhone API calls in automated tests.

Use Laravel's HTTP fake:

```php
use Illuminate\Support\Facades\Http;

Http::fake([
    'https://smsservice.inexphone.ge/api/v1/*' => Http::response([
        'message' => 'ok',
        'data' => [],
    ], 200),
]);
```

Tests should verify:

* HTTP method
* endpoint
* request body
* query parameters
* successful responses
* API failures
* exception behavior

Run the existing test suite after making changes.

If the project uses PHPStan, run static analysis as well.

---

# Response Structures

Package methods return decoded API response arrays.

Responses can contain:

```text
data
meta
message
```

but the exact structure depends on the endpoint.

Do not assume all endpoints return identical data.

Use the endpoint-specific documentation when accessing response fields.

---

# Security

Never:

* hard-code API tokens
* expose API credentials
* commit secrets
* log credentials
* put credentials in frontend code
* use real customer data in examples

Use placeholders:

```text
your-api-token
995555111111
sms-uuid
blacklist-id
```

---

# Unsupported Functionality

If a developer asks for functionality that is not documented:

Do not invent an endpoint.

Do not invent a package method.

Do not fabricate a response.

Instead, explain that the functionality is not currently confirmed by the available InexPhone documentation.

For example, the current blacklist API provides retrieval only:

```text
GET /blacklists
GET /blacklists/{id}
```

Therefore do not generate:

```php
Sms::addBlacklist();
Sms::removeBlacklist();
Sms::deleteBlacklist();
```

---

# Version

Current documented package version:

```text
v1.2.0
```

This version includes:

* Core SMS APIs
* OTP APIs
* Blacklist read APIs

If a newer verified version is available, use its documentation instead.

---

# Final Verification

Before completing an InexPhone integration, verify:

* The official package is being used.
* Configuration is correct.
* Credentials come from environment variables.
* The package method name is correct.
* Parameters match the documented API.
* Errors are handled appropriately.
* Tests pass.
* No secrets were added to the project.

When uncertain, verify the available documentation instead of guessing.
