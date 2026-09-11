# InexPhone SMS — Claude Code Instructions

## Purpose

These instructions guide Claude Code when working with **InexPhone SMS** integrations in Laravel applications.

The official Laravel package is:

```text
insightsge/laravel-inexphone-sms
```

The main source of integration knowledge is:

```text
../SKILL.md
```

Detailed API documentation is available in:

```text
../docs/
```

Practical examples are available in:

```text
../examples/
```

---

## First Step

Before implementing or modifying InexPhone SMS integration:

1. Read `SKILL.md`.
2. Read the relevant documentation in `docs/`.
3. Check the relevant examples in `examples/`.
4. Inspect the user's existing Laravel project structure and conventions.
5. Then implement the requested functionality.

Do not blindly copy examples if the user's application has a different architecture.

---

## Package

Install the official Laravel package with:

```bash
composer require insightsge/laravel-inexphone-sms
```

Use the Laravel facade:

```php
use Inexphone\Sms\Facades\Sms;
```

The current documented package version is:

```text
v1.2.0
```

---

## Supported Methods

The package currently supports:

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

These are the authoritative package method names.

Do not invent alternative method names.

---

# SMS

## Single SMS

```php
$response = Sms::send(
    phone: '995555111111',
    subject: 'MyApp',
    message: 'Hello from Laravel!',
);
```

Optional arguments:

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

Optional callbacks:

```text
submitCallbackUrl
deliveryCallbackUrl
```

---

# SMS History

List sent messages:

```php
$response = Sms::list();
```

With query parameters:

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

Only use query parameters confirmed by the InexPhone documentation.

---

# OTP

## Send OTP

```php
$response = Sms::sendOtp(
    phone: '995555111111',
    subject: 'MyApp',
);
```

Optional parameters:

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

The API supports defaults for the optional OTP parameters.

Keep the OTP `subject` within the API's allowed length.

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

# Blacklists

## List Blacklists

```php
$response = Sms::blacklists();
```

With pagination:

```php
$response = Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
]);
```

With filters:

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

Supported documented filters:

```text
filters[keywords]
filters[subjects]
filters[number]
filters[dateEnd]
```

`dateEnd` uses:

```text
d/m/Y
```

format.

---

## Find Blacklist

```php
$response = Sms::findBlacklist('blacklist-id');
```

The current documented API exposes blacklist retrieval:

```text
GET /blacklists
GET /blacklists/{id}
```

Do not implement blacklist creation or deletion unless official InexPhone documentation provides corresponding endpoints.

---

# Configuration

Use environment variables:

```env
INEXPHONE_SMS_BASE_URL=https://smsservice.inexphone.ge/api/v1
INEXPHONE_SMS_TOKEN=your-api-token
INEXPHONE_SMS_LANGUAGE=ka
INEXPHONE_SMS_TIMEOUT=30
```

Never hard-code production credentials.

Never place the InexPhone API token in:

* Blade templates
* JavaScript
* frontend environment variables
* public repositories
* API responses

The InexPhone API should be accessed from the Laravel backend.

---

# Error Handling

The package throws:

```php
Inexphone\Sms\Exceptions\SmsException
```

Use it when application logic needs to handle API failures:

```php
use Inexphone\Sms\Exceptions\SmsException;

try {
    $response = Sms::send(
        phone: '995555111111',
        subject: 'MyApp',
        message: 'Hello!',
    );
} catch (SmsException $exception) {
    // Handle the API failure.
}
```

Do not expose internal API errors directly to end users unless the application intentionally requires it.

---

# Laravel Architecture

Claude Code should respect the architecture of the existing Laravel application.

For simple integrations, the facade is appropriate:

```php
Sms::send(...);
```

For reusable application logic, dependency injection may be preferable:

```php
Inexphone\Sms\Contracts\SmsClientInterface
```

Do not introduce unnecessary abstractions.

If the application already has a service layer, integrate InexPhone there rather than duplicating API logic across controllers.

Use Form Requests or other existing validation mechanisms when user input needs validation.

---

# Testing

Do not make real InexPhone API calls from automated tests.

Use Laravel HTTP fakes:

```php
use Illuminate\Support\Facades\Http;

Http::fake([
    'https://smsservice.inexphone.ge/api/v1/*' => Http::response([
        'message' => 'ok',
        'data' => [],
    ], 200),
]);
```

When changing an integration:

1. Add or update tests.
2. Test successful requests.
3. Test API failures.
4. Verify HTTP method and endpoint.
5. Verify request body or query parameters when relevant.
6. Run the project's existing test suite.
7. Run static analysis when the project uses it.

Do not remove existing tests simply to make a change pass.

---

# Do Not Guess

This is a strict rule.

If Claude Code does not know whether InexPhone supports a particular:

* endpoint
* parameter
* response field
* operation
* authentication mechanism
* feature

it must not invent one.

Instead:

1. Check `SKILL.md`.
2. Check the relevant `docs/` file.
3. Check the examples.
4. Inspect the package implementation when available.
5. Clearly state when the behavior is not documented.

---

# Existing Package Behavior

The package uses Laravel's HTTP client internally.

Requests use:

* Bearer authentication
* JSON responses
* `Accept-Language`
* configurable timeout

API failures are converted into `SmsException`.

The package methods return decoded API response arrays.

Do not assume every endpoint returns the same response structure.

---

# Security Rules

Never:

* commit API tokens
* expose API credentials
* put credentials into frontend code
* log sensitive credentials
* invent authentication credentials
* commit real customer phone numbers into examples

Use placeholders such as:

```text
995555111111
your-api-token
sms-uuid
blacklist-id
```

for documentation and examples.

---

# Development Style

When modifying a Laravel application:

* Follow existing project conventions.
* Prefer small, focused changes.
* Avoid unrelated refactoring.
* Reuse existing validation and service patterns.
* Keep controller logic simple.
* Use dependency injection where it improves testability or architecture.
* Add tests for new behavior.
* Preserve backward compatibility unless a breaking change is explicitly requested.

---

# Final Verification

After implementing an InexPhone integration, verify:

* The correct package is being used.
* Configuration is present.
* API credentials are loaded from environment variables.
* The correct package method is used.
* The request parameters match the documented API.
* Errors are handled appropriately.
* Tests pass.
* No secrets were introduced into source control.

The goal is to produce **working Laravel code based on verified InexPhone behavior, not guessed API behavior**.
