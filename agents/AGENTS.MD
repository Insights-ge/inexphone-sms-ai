# InexPhone SMS — Codex Instructions

## Purpose

These instructions help Codex integrate **InexPhone SMS** into Laravel applications using the official package:

```text
insightsge/laravel-inexphone-sms
```

The main InexPhone knowledge and API reference is located in:

```text
../SKILL.md
```

Detailed documentation is located in:

```text
../docs/
```

Examples are located in:

```text
../examples/
```

---

## Before Writing Code

When a task involves InexPhone SMS:

1. Read `SKILL.md`.
2. Check the relevant documentation in `docs/`.
3. Check the relevant examples in `examples/`.
4. Use the actual package API documented there.
5. Do not invent unsupported endpoints, methods, parameters, or response structures.

---

## Official Laravel Package

Use:

```bash
composer require insightsge/laravel-inexphone-sms
```

The package provides:

```php
use Inexphone\Sms\Facades\Sms;
```

---

## Supported Methods

Use only the documented methods:

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

Do not replace these with invented method names.

---

## Configuration

InexPhone credentials belong in Laravel environment configuration.

Use placeholders when credentials are not available:

```env
INEXPHONE_SMS_BASE_URL=https://smsservice.inexphone.ge/api/v1
INEXPHONE_SMS_TOKEN=your-api-token
INEXPHONE_SMS_LANGUAGE=ka
INEXPHONE_SMS_TIMEOUT=30
```

Never hard-code a real API token.

Never expose the API token to frontend JavaScript.

---

## Sending SMS

For a single SMS:

```php
use Inexphone\Sms\Facades\Sms;

$response = Sms::send(
    phone: '995551563555',
    subject: 'MyApp',
    message: 'Hello from Laravel!',
);
```

For commercial SMS:

```php
$response = Sms::sendCommercial(
    phone: '995551563555',
    subject: 'MyApp',
    message: 'Your commercial message.',
);
```

For bulk SMS:

```php
$response = Sms::sendBulk(
    subject: 'MyApp',
    message: 'Your message.',
    phoneNumbers: [
        '995551563555',
        '995599999999',
    ],
);
```

---

## OTP

To send an OTP:

```php
$response = Sms::sendOtp(
    phone: '995551563555',
    subject: 'MyApp',
);
```

Optional parameters include:

```text
text
expiresIn
codeDigits
```

To verify an OTP:

```php
$response = Sms::verifyOtp(
    phone: '995551563555',
    code: '1552',
);
```

Do not send `subject` to `verifyOtp()`.

---

## Blacklists

To retrieve blacklist records:

```php
$response = Sms::blacklists();
```

Filters may be supplied according to the documented API:

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

To retrieve a specific record:

```php
$response = Sms::findBlacklist('blacklist-id');
```

The current documented API supports reading blacklist records only.

Do not invent blacklist creation or deletion methods.

---

## SMS History

To retrieve sent SMS records:

```php
$response = Sms::list();
```

To retrieve one SMS:

```php
$response = Sms::find('sms-uuid');
```

Only use documented query parameters.

---

## Error Handling

API failures are represented by:

```php
use Inexphone\Sms\Exceptions\SmsException;
```

Example:

```php
try {
    $response = Sms::send(
        phone: '995551563555',
        subject: 'MyApp',
        message: 'Hello!',
    );
} catch (SmsException $exception) {
    // Handle the InexPhone API error.
}
```

Do not silently swallow API exceptions when the application needs to react to failures.

---

## Application Architecture

When integrating InexPhone into an existing Laravel application:

* Follow the application's existing architecture.
* Use the facade for simple integrations.
* Use dependency injection for reusable application services when appropriate.
* Keep InexPhone credentials in `.env`.
* Validate application input before sending requests.
* Keep external API calls on the backend.
* Do not expose credentials in frontend code.

If an application already has a service layer for external APIs, integrate InexPhone there instead of unnecessarily placing API logic directly inside controllers.

---

## Testing

When writing tests for code that uses InexPhone:

* Mock/fake external HTTP requests.
* Do not make real API calls from automated tests.
* Use Laravel's `Http::fake()`.
* Test both successful responses and API failures.
* Verify request URLs, HTTP methods, query parameters, and request bodies where appropriate.

Example:

```php
Http::fake([
    'https://smsservice.inexphone.ge/api/v1/*' => Http::response([
        'message' => 'ok',
        'data' => [],
    ], 200),
]);
```

---

## Important Rules

### Never invent API behavior

If the requested feature is not documented, say that it is not currently supported.

### Never invent package methods

Use the real package methods:

```text
send
sendCommercial
sendBulk
list
find
sendOtp
verifyOtp
blacklists
findBlacklist
```

### Never invent credentials

Use:

```text
your-api-token
```

instead of fake-looking production credentials.

### Never expose secrets

Do not place tokens in:

* committed source code
* frontend code
* public examples
* logs
* error messages

### Prefer copy-pasteable Laravel code

When answering implementation questions, provide a practical Laravel example that can be adapted directly.

---

## Version Awareness

The current documented package release is:

```text
v1.2.0
```

This version includes:

* Core SMS APIs
* OTP APIs
* Blacklist read APIs

When newer package documentation is available, prefer the newer verified documentation over this version reference.
