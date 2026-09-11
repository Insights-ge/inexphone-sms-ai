# Cursor Rules — InexPhone SMS Laravel Package

## Purpose

These rules help Cursor work correctly with the `insightsge/laravel-inexphone-sms` Laravel package.

Before making changes or generating code related to InexPhone SMS, read:

1. `../SKILL.md`
2. Relevant files inside `../docs/`
3. Relevant examples inside `../examples/`

The package version documented by this repository is **v1.2.0**.

---

## Package

Package name:

```text
insightsge/laravel-inexphone-sms
```

Install with:

```bash
composer require insightsge/laravel-inexphone-sms
```

The package provides a Laravel-friendly client for the InexPhone SMS API.

API base URL:

```text
https://smsservice.inexphone.ge/api/v1
```

---

## Core Rule

**Do not invent API functionality.**

Only use endpoints, parameters, methods, request structures, and behaviors documented in this knowledge repository.

If the requested functionality is not documented:

* Do not create a fake package method.
* Do not invent an API endpoint.
* Do not assume undocumented request parameters.
* Clearly tell the user that the functionality is not currently documented/supported.

---

## Supported Methods

The package currently supports:

```php
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

Do not suggest additional methods unless they are confirmed in the package source or documentation.

---

## Configuration

The package uses environment-based configuration.

Expected configuration:

```env
INEXPHONE_SMS_BASE_URL=https://smsservice.inexphone.ge/api/v1
INEXPHONE_SMS_TOKEN=your-api-token
INEXPHONE_SMS_LANGUAGE=ka
INEXPHONE_SMS_TIMEOUT=30
```

Never hard-code the API token.

Use Laravel configuration and environment variables instead.

Do not expose API credentials in:

* Controllers
* Blade templates
* JavaScript
* Git repositories
* Logs
* Exceptions
* Public configuration examples

---

## SMS

### Single SMS

Use:

```php
use Inexphone\Sms\Facades\Sms;

$response = Sms::send(
    '+9955XXXXXXXX',
    'MyApp',
    'Your message',
);
```

Supported arguments:

```php
Sms::send(
    string $phone,
    string $subject,
    string $message,
    bool $ignoreBlacklist = false,
    ?string $submitCallbackUrl = null,
    ?string $deliveryCallbackUrl = null,
);
```

Do not change the argument order without checking the actual package source.

---

### Commercial SMS

Use:

```php
$response = Sms::sendCommercial(
    '+9955XXXXXXXX',
    'MyApp',
    'Commercial message',
);
```

Use the package's documented method signature and request structure.

---

### Bulk SMS

Use:

```php
$response = Sms::sendBulk(
    'MyApp',
    'Bulk message',
    [
        '+9955XXXXXXXX',
        '+9955YYYYYYYY',
    ],
);
```

Do not confuse bulk SMS with multiple individual `send()` calls.

---

### SMS List

Use:

```php
$response = Sms::list();
```

For pagination/filtering, use only parameters documented in the SMS API documentation.

---

### Find SMS

Use:

```php
$response = Sms::find($uuid);
```

The identifier must be the SMS UUID expected by the API.

---

## OTP

### Send OTP

Use:

```php
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
);
```

The method supports:

```php
Sms::sendOtp(
    string $phone,
    string $subject,
    ?string $text = null,
    ?int $expiresIn = null,
    ?int $codeDigits = null,
);
```

Documented defaults:

* Text: `Your verification code is: {{CODE}}`
* Expiration: `60` seconds
* Code length: `4` digits

The subject must respect the API's subject-length restriction.

---

### Verify OTP

Use:

```php
$response = Sms::verifyOtp(
    '+9955XXXXXXXX',
    '1234',
);
```

The verification request contains:

```text
phone
code
```

**Do not add `subject` to OTP verification.**

---

## Blacklists

The package currently supports reading blacklist information.

### List Blacklists

```php
$response = Sms::blacklists();
```

Supported documented query parameters include:

```text
page
perPage
filters[keywords]
filters[subjects]
filters[number]
filters[dateEnd]
```

Example:

```php
$response = Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
]);
```

For `dateEnd`, use:

```text
d/m/Y
```

Example:

```text
31/12/2026
```

---

### Find a Blacklist Entry

Use:

```php
$response = Sms::findBlacklist('123');
```

The blacklist ID should be treated as a string.

---

### Important Blacklist Limitation

The documented API currently exposes blacklist `GET` operations only.

Therefore, do not invent methods such as:

```php
Sms::addBlacklist()
Sms::removeBlacklist()
Sms::deleteBlacklist()
```

unless they are added and documented in a future package version.

`ignoreBlacklist` in SMS sending is not a blacklist-management operation.

---

## Error Handling

The package provides:

```php
Inexphone\Sms\Exceptions\SmsException
```

Use it when handling package/API failures:

```php
use Inexphone\Sms\Exceptions\SmsException;

try {
    $response = Sms::send(
        '+9955XXXXXXXX',
        'MyApp',
        'Hello',
    );
} catch (SmsException $e) {
    // Handle InexPhone API/package error
}
```

Do not silently swallow API errors.

When modifying existing Laravel applications, follow the application's existing error-handling conventions.

---

## Laravel Architecture

Prefer clean Laravel architecture.

Do not put unnecessary InexPhone API logic directly into large controllers.

For reusable application functionality, prefer:

```text
Controller
    ↓
Application Service
    ↓
InexPhone Sms Package
```

For example:

```php
class NotificationService
{
    public function sendVerificationCode(string $phone): array
    {
        return Sms::sendOtp(
            $phone,
            'MyApp',
        );
    }
}
```

Controllers should remain responsible primarily for HTTP concerns.

---

## Dependency Injection

If a service or class depends on the SMS client, prefer dependency injection where appropriate instead of creating unnecessary dependencies manually.

Follow the existing architecture of the Laravel project.

Do not introduce a new abstraction simply for the sake of abstraction.

---

## Testing

When adding or modifying application code that uses the package, write tests where appropriate.

For HTTP-level package tests, Laravel's HTTP fake system can be used:

```php
Http::fake([
    'smsservice.inexphone.ge/*' => Http::response([
        'message' => 'ok',
    ], 200),
]);
```

Tests should verify:

* HTTP method
* endpoint
* request data
* authentication behavior where appropriate
* successful responses
* API failures
* application error handling

Do not make real SMS requests from automated tests unless explicitly intended as an integration test.

---

## Code Modification Rules

Before modifying existing code:

1. Inspect the relevant files.
2. Understand the existing architecture.
3. Check the package documentation.
4. Reuse existing services/helpers where appropriate.
5. Make the smallest reasonable change.
6. Avoid unrelated refactoring.

Do not rewrite working code merely to use a different style.

---

## Version Awareness

This knowledge repository currently documents:

```text
insightsge/laravel-inexphone-sms v1.2.0
```

If the installed package version differs, inspect the actual installed package/source before making assumptions.

The installed code takes precedence over outdated assumptions.

---

## Final Verification

After making changes related to InexPhone SMS:

* Check the method name.
* Check the method arguments.
* Check the endpoint.
* Check the request payload.
* Check environment/configuration usage.
* Check error handling.
* Check that credentials are not exposed.
* Run relevant tests.
* Run static analysis when configured.
* Do not claim an API feature exists unless it is confirmed.

When uncertain, inspect the source and documentation instead of guessing.
