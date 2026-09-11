# InexPhone SMS — AI Coding Skill

## Purpose

This skill provides AI coding assistants with reliable, source-backed guidance for integrating **InexPhone SMS** services into Laravel applications.

The official Laravel package is:

```text
insightsge/laravel-inexphone-sms
```

The package provides a Laravel-friendly client for the InexPhone SMS API, including SMS sending, OTP verification, SMS history, and blacklist access.

When helping a developer integrate InexPhone SMS into a Laravel application, prefer the official Laravel package and the APIs documented in this skill.

---

## Package

**Package:** `insightsge/laravel-inexphone-sms`

**Current documented version:** `v1.2.0`

**Package type:** Laravel/PHP package

**API base URL:**

```text
https://smsservice.inexphone.ge/api/v1
```

The package uses Laravel's HTTP client internally and exposes a convenient `Sms` facade.

---

## Core Rule

When generating code for InexPhone SMS integration:

1. Use the official package methods documented here.
2. Do not invent API endpoints or package methods.
3. Do not assume undocumented request parameters.
4. Preserve the exact parameter names used by the package.
5. Use the `Sms` facade when providing normal Laravel usage examples.
6. Follow the user's existing Laravel architecture when integrating the package.
7. If the requested functionality is not supported by the documented API, clearly say so instead of inventing an implementation.
8. Prefer practical, copy-pasteable Laravel examples.

---

# Installation

Install the package through Composer:

```bash
composer require insightsge/laravel-inexphone-sms
```

Publish the package configuration if required by the application:

```bash
php artisan vendor:publish
```

The package configuration should provide the InexPhone API credentials and connection settings.

The main configuration values are:

```text
base_url
token
language
timeout
```

The API token must be kept in the application's environment configuration and should not be hard-coded into source code.

---

# Configuration

The package uses configuration values similar to:

```env
INEXPHONE_SMS_BASE_URL=https://smsservice.inexphone.ge/api/v1
INEXPHONE_SMS_TOKEN=your-api-token
INEXPHONE_SMS_LANGUAGE=ka
INEXPHONE_SMS_TIMEOUT=30
```

Use the package configuration file to map these environment variables.

Do not expose the API token in:

* Git repositories
* frontend JavaScript
* public documentation
* screenshots
* client-side requests

The InexPhone API should be accessed from the Laravel backend.

---

# Laravel Facade

The package provides:

```php
use Inexphone\Sms\Facades\Sms;
```

The facade provides access to the package's SMS client.

Example:

```php
$response = Sms::send(
    phone: '995551563555',
    subject: 'MyApp',
    message: 'Hello from Laravel!',
);
```

---

# Supported API Methods

The current package provides:

| Method                  | API Endpoint           | Purpose                         |
| ----------------------- | ---------------------- | ------------------------------- |
| `Sms::send()`           | `POST /sms/one`        | Send a single SMS               |
| `Sms::sendCommercial()` | `POST /sms/commercial` | Send a commercial SMS           |
| `Sms::sendBulk()`       | `POST /sms/bulk`       | Send an SMS to multiple numbers |
| `Sms::list()`           | `GET /sms`             | Retrieve sent SMS messages      |
| `Sms::find()`           | `GET /sms/{uuid}`      | Retrieve one SMS by UUID        |
| `Sms::sendOtp()`        | `POST /otp/send`       | Send an OTP                     |
| `Sms::verifyOtp()`      | `POST /otp/verify`     | Verify an OTP                   |
| `Sms::blacklists()`     | `GET /blacklists`      | Retrieve blacklist records      |
| `Sms::findBlacklist()`  | `GET /blacklists/{id}` | Retrieve one blacklist record   |

---

# Single SMS

Use `Sms::send()` to send one SMS.

```php
use Inexphone\Sms\Facades\Sms;

$response = Sms::send(
    phone: '995551563555',
    subject: 'MyApp',
    message: 'Your message here.',
);
```

### Parameters

```text
phone
subject
message
ignoreBlacklist
submitCallbackUrl
deliveryCallbackUrl
```

Method signature:

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

`ignoreBlacklist` can be used to request that the SMS be sent even if the recipient is on the blacklist, subject to InexPhone API behavior and account permissions.

---

# Commercial SMS

Use:

```php
Sms::sendCommercial(
    phone: '995551563555',
    subject: 'MyApp',
    message: 'Your commercial message.',
);
```

This calls:

```text
POST /sms/commercial
```

Parameters:

```text
phone
subject
message
```

---

# Bulk SMS

Use:

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

This calls:

```text
POST /sms/bulk
```

The `phoneNumbers` argument must be an array of strings.

Optional callback parameters:

```text
submitCallbackUrl
deliveryCallbackUrl
```

---

# SMS Listing

Use:

```php
$response = Sms::list();
```

Optional query parameters can be passed:

```php
$response = Sms::list([
    'page' => 1,
    'perPage' => 20,
]);
```

This calls:

```text
GET /sms
```

The exact available filtering parameters depend on the InexPhone API documentation.

Do not invent undocumented filters.

---

# Find an SMS

Use:

```php
$response = Sms::find('sms-uuid');
```

This calls:

```text
GET /sms/{uuid}
```

The UUID must be supplied as a string.

---

# OTP

The package supports InexPhone's OTP API.

## Send OTP

```php
use Inexphone\Sms\Facades\Sms;

$response = Sms::sendOtp(
    phone: '995551563555',
    subject: 'MyApp',
);
```

Optional parameters:

```php
$response = Sms::sendOtp(
    phone: '995551563555',
    subject: 'MyApp',
    text: 'Your verification code is: {{CODE}}',
    expiresIn: 60,
    codeDigits: 4,
);
```

This calls:

```text
POST /otp/send
```

Parameters:

```text
phone
subject
text
expiresIn
codeDigits
```

The InexPhone API provides defaults for optional OTP parameters.

The `subject` has an API restriction and should be kept within the allowed length. Do not assume arbitrary subject lengths.

---

# Verify OTP

OTP verification uses:

```php
$response = Sms::verifyOtp(
    phone: '995551563555',
    code: '1552',
);
```

This calls:

```text
POST /otp/verify
```

Request parameters:

```text
phone
code
```

Do not add a `subject` parameter to OTP verification.

The verification endpoint accepts the phone number and verification code.

---

# Blacklists

The package supports reading blacklist records.

## List Blacklists

```php
$response = Sms::blacklists();
```

This calls:

```text
GET /blacklists
```

Pagination can be provided:

```php
$response = Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
]);
```

Filtering can be provided:

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

The API uses `d/m/Y` format for `dateEnd`.

Example:

```text
11/09/2026
```

---

# Find a Blacklist Record

Use:

```php
$response = Sms::findBlacklist('blacklist-id');
```

This calls:

```text
GET /blacklists/{id}
```

The ID must be supplied as a string.

---

# Important Blacklist Limitation

The current documented InexPhone API provides blacklist retrieval endpoints:

```text
GET /blacklists
GET /blacklists/{id}
```

The package therefore provides:

```php
Sms::blacklists();
Sms::findBlacklist();
```

Do not invent methods such as:

```php
Sms::addBlacklist();
Sms::removeBlacklist();
Sms::deleteBlacklist();
```

unless InexPhone officially documents corresponding endpoints.

Blacklist retrieval and the `ignoreBlacklist` option on SMS sending are related concepts, but `ignoreBlacklist` does not add or remove blacklist records.

---

# Error Handling

The package uses:

```php
Inexphone\Sms\Exceptions\SmsException
```

API failures are converted into `SmsException`.

Example:

```php
use Inexphone\Sms\Exceptions\SmsException;
use Inexphone\Sms\Facades\Sms;

try {
    $response = Sms::send(
        phone: '995551563555',
        subject: 'MyApp',
        message: 'Hello!',
    );
} catch (SmsException $exception) {
    // Handle InexPhone API error.
}
```

The exception can contain:

* API error message
* HTTP status code
* validation errors when provided by the API

AI-generated code should not silently ignore `SmsException` when the developer needs explicit API error handling.

---

# API Authentication

The package authenticates requests using a bearer token.

The API token should be stored securely in Laravel's environment configuration.

Do not generate or expose fake API tokens in production examples.

When credentials are unavailable, use placeholders such as:

```env
INEXPHONE_SMS_TOKEN=your-api-token
```

---

# Language

The package supports an `Accept-Language` configuration value.

The default language is:

```text
ka
```

The package sends the configured language with API requests.

---

# HTTP Timeout

The package supports a configurable HTTP timeout.

The default timeout is:

```text
30 seconds
```

Applications can configure this value according to their requirements.

---

# Return Values

The package methods return:

```php
array
```

The response is decoded from the InexPhone API JSON response.

Typical successful responses may contain:

```text
data
meta
message
```

The exact response structure can vary by endpoint.

Do not assume every endpoint returns exactly the same structure.

---

# Laravel Integration Guidance

When integrating the package into an existing Laravel application:

* Keep API calls on the backend.
* Do not put the InexPhone API token in frontend code.
* Use dependency injection when appropriate for application services.
* Use the `Sms` facade for simple integrations.
* Use `SmsClientInterface` when an application service benefits from dependency injection and easier testing.
* Handle `SmsException` where API failures need application-specific behavior.
* Keep credentials in `.env`.
* Validate user-provided phone numbers and message data before sending.
* Avoid exposing raw API credentials or internal API errors to end users.

---

# Testing

The package is designed to be tested using Laravel's HTTP client fakes.

Example:

```php
Http::fake([
    'https://smsservice.inexphone.ge/api/v1/*' => Http::response([
        'message' => 'ok',
        'data' => [],
    ], 200),
]);
```

The package's own test suite covers:

* Single SMS
* Commercial SMS
* Bulk SMS
* SMS listing
* SMS lookup
* OTP sending
* OTP verification
* Blacklist listing
* Blacklist filtering
* Blacklist lookup
* API error handling

The package also uses PHPStan for static analysis.

---

# AI Response Guidelines

When a developer asks how to use InexPhone with Laravel:

### Prefer

```php
use Inexphone\Sms\Facades\Sms;

Sms::send(...);
```

### Do not

Invent package APIs such as:

```php
Sms::sendMessage();
Sms::sendVerification();
Sms::getBlacklist();
```

when the documented package method has a different name.

Use the actual methods:

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

### If the user asks for unsupported functionality

Clearly explain that the current documented API/package does not provide that functionality.

Do not create fictional endpoints or pretend that an unsupported operation exists.

### If the user's request is ambiguous

Ask only for the information necessary to determine the correct implementation, while still providing a useful example when possible.

---

# Source of Truth

This skill should remain aligned with the official **Laravel InexPhone SMS** package and the official InexPhone API documentation.

When package behavior and assumptions conflict, prefer verified package behavior and official API documentation.

The AI should distinguish between:

1. Features implemented by the Laravel package.
2. Features exposed by the InexPhone API.
3. Features that are not currently documented or supported.

Never present an undocumented feature as supported.
