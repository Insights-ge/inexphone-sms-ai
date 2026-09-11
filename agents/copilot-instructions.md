# InexPhone SMS — GitHub Copilot Instructions

## Purpose

Use these instructions when generating or modifying Laravel code that integrates with **InexPhone SMS**.

The official Laravel package is:

```text
insightsge/laravel-inexphone-sms
```

The main reference for InexPhone integration is:

```text
../SKILL.md
```

Additional documentation is available in:

```text
../docs/
```

Examples are available in:

```text
../examples/
```

---

## Core Instructions

When helping with InexPhone SMS integration:

* Use the official Laravel package.
* Use documented package methods only.
* Do not invent API endpoints.
* Do not invent package methods.
* Do not invent request parameters.
* Do not assume undocumented response structures.
* Keep API credentials in environment variables.
* Prefer Laravel-native implementation patterns.
* Follow the existing project's architecture and coding style.

If the requested functionality is not documented or supported, clearly state that instead of generating fictional code.

---

## Package Installation

The package can be installed with:

```bash
composer require insightsge/laravel-inexphone-sms
```

Use the facade:

```php
use Inexphone\Sms\Facades\Sms;
```

---

## Supported Methods

The package currently provides:

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

Use these exact method names.

---

## Single SMS

```php
$response = Sms::send(
    phone: '995551563555',
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
    phone: '995551563555',
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
        '995551563555',
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

## SMS History

List sent SMS messages:

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

Find one SMS:

```php
$response = Sms::find('sms-uuid');
```

Only use documented query parameters.

---

## OTP

Send an OTP:

```php
$response = Sms::sendOtp(
    phone: '995551563555',
    subject: 'MyApp',
);
```

Optional parameters:

```text
text
expiresIn
codeDigits
```

Verify an OTP:

```php
$response = Sms::verifyOtp(
    phone: '995551563555',
    code: '1552',
);
```

The OTP verification request requires only:

```text
phone
code
```

Do not add `subject` to `verifyOtp()`.

---

## Blacklists

List blacklist records:

```php
$response = Sms::blacklists();
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

Documented filters:

```text
filters[keywords]
filters[subjects]
filters[number]
filters[dateEnd]
```

Find one blacklist record:

```php
$response = Sms::findBlacklist('blacklist-id');
```

The current documented API provides blacklist retrieval only.

Do not generate methods for adding or deleting blacklist records unless official documentation provides those endpoints.

---

## Error Handling

The package throws:

```php
Inexphone\Sms\Exceptions\SmsException
```

Use it when application-specific handling of API failures is required:

```php
use Inexphone\Sms\Exceptions\SmsException;

try {
    $response = Sms::send(
        phone: '995551563555',
        subject: 'MyApp',
        message: 'Hello!',
    );
} catch (SmsException $exception) {
    // Handle the API failure.
}
```

Do not hide API failures without a reason.

---

## Configuration

Use environment variables for credentials:

```env
INEXPHONE_SMS_BASE_URL=https://smsservice.inexphone.ge/api/v1
INEXPHONE_SMS_TOKEN=your-api-token
INEXPHONE_SMS_LANGUAGE=ka
INEXPHONE_SMS_TIMEOUT=30
```

Never hard-code a real API token.

Never expose the token in frontend JavaScript or client-side requests.

---

## Laravel Architecture

When generating application code:

### Controllers

Controllers should generally coordinate application actions rather than contain large amounts of external API logic.

For reusable integrations, consider an application service that uses the InexPhone client.

### Dependency Injection

The package provides:

```php
Inexphone\Sms\Contracts\SmsClientInterface
```

Use the interface when dependency injection is appropriate.

### Validation

Validate phone numbers, message content, and other user input before calling the external API.

### Security

Never expose:

* API tokens
* internal API credentials
* sensitive API responses
* unnecessary exception details

to users or frontend applications.

---

## Testing

Do not make real InexPhone API requests from automated tests.

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

Tests should verify appropriate:

* HTTP methods
* endpoints
* request bodies
* query parameters
* successful responses
* API error handling

---

## Response Handling

Package methods return arrays decoded from the InexPhone API response.

Do not assume every endpoint has the same response structure.

Responses may contain fields such as:

```text
data
meta
message
```

Use the actual endpoint documentation when accessing nested response data.

---

## Current Version

The current documented package release is:

```text
v1.2.0
```

It includes:

* SMS API support
* OTP API support
* Blacklist read API support

When working with a newer verified package version, prefer its documentation over this version reference.

---

## Final Rule

When Copilot is uncertain about an InexPhone API behavior, it should **not guess**.

It should:

1. Check `SKILL.md`.
2. Check the relevant file in `docs/`.
3. Check the relevant example.
4. If the functionality is still undocumented, tell the developer that it is not confirmed.
