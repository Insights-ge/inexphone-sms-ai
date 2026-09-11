# Installation

## Requirements

The `insightsge/laravel-inexphone-sms` package is designed for Laravel applications and requires:

* PHP
* Laravel
* Composer
* An InexPhone SMS API token

The exact PHP and Laravel compatibility should be verified against the package's current `composer.json` when working with a specific project.

---

## Install the Package

From the root of your Laravel application, run:

```bash
composer require insightsge/laravel-inexphone-sms
```

Composer will install the package and its dependencies.

After installation, configure the InexPhone API credentials.

---

## Environment Configuration

Add the following variables to the Laravel application's `.env` file:

```env
INEXPHONE_SMS_BASE_URL=https://smsservice.inexphone.ge/api/v1
INEXPHONE_SMS_TOKEN=your-api-token
INEXPHONE_SMS_LANGUAGE=ka
INEXPHONE_SMS_TIMEOUT=30
```

### Configuration values

| Variable                 | Description                        | Example                                  |
| ------------------------ | ---------------------------------- | ---------------------------------------- |
| `INEXPHONE_SMS_BASE_URL` | InexPhone API base URL             | `https://smsservice.inexphone.ge/api/v1` |
| `INEXPHONE_SMS_TOKEN`    | InexPhone API authentication token | `your-api-token`                         |
| `INEXPHONE_SMS_LANGUAGE` | API request language               | `ka`                                     |
| `INEXPHONE_SMS_TIMEOUT`  | HTTP request timeout in seconds    | `30`                                     |

The API token is secret and must not be committed to Git.

---

## API Base URL

The package communicates with:

```text
https://smsservice.inexphone.ge/api/v1
```

Available API resources include:

```text
/sms
/otp
/blacklists
```

The package builds the complete endpoint URLs from the configured base URL.

Do not add `/api/v1` again when configuring `INEXPHONE_SMS_BASE_URL`.

Correct:

```env
INEXPHONE_SMS_BASE_URL=https://smsservice.inexphone.ge/api/v1
```

Avoid:

```env
INEXPHONE_SMS_BASE_URL=https://smsservice.inexphone.ge/api/v1/api/v1
```

---

## API Authentication

The package authenticates requests using a Bearer token.

The token comes from:

```env
INEXPHONE_SMS_TOKEN=your-api-token
```

Applications should never hard-code this token inside controllers, services, JavaScript, Blade templates, or committed source files.

---

## Language

The package sends the configured language using the API's `Accept-Language` request header.

For Georgian:

```env
INEXPHONE_SMS_LANGUAGE=ka
```

If another language is required, configure the value according to the API's supported language values.

---

## Timeout

The HTTP timeout can be configured using:

```env
INEXPHONE_SMS_TIMEOUT=30
```

The value represents the request timeout in seconds.

For example:

```env
INEXPHONE_SMS_TIMEOUT=60
```

can be used when the application requires a longer timeout.

Do not increase the timeout unnecessarily.

---

## Using the Facade

The main package facade is:

```php
use Inexphone\Sms\Facades\Sms;
```

Example:

```php
use Inexphone\Sms\Facades\Sms;

$response = Sms::send(
    '+9955XXXXXXXX',
    'MyApp',
    'Hello from my application!',
);
```

The facade provides access to the package's supported SMS, OTP, and blacklist operations.

---

## Configuration Cache

When Laravel configuration is cached, changes to `.env` values may not be immediately reflected.

After changing the InexPhone configuration in a deployed application, clear/rebuild the Laravel configuration cache using the application's normal deployment process.

For example:

```bash
php artisan config:clear
```

If the application uses cached configuration in production, rebuild it according to the deployment setup.

---

## Verify Installation

A simple test can confirm that the package is available:

```php
use Inexphone\Sms\Facades\Sms;

$response = Sms::list();
```

If the credentials and configuration are correct, the request should reach the InexPhone API.

For local development, avoid sending real SMS messages simply to test whether the package is installed. Prefer automated tests with HTTP fakes when testing application code.

---

## Testing With HTTP Fake

Laravel applications can mock the HTTP request when testing code that uses the package.

Example:

```php
use Illuminate\Support\Facades\Http;

Http::fake([
    'smsservice.inexphone.ge/*' => Http::response([
        'message' => 'ok',
    ], 200),
]);
```

Then execute the application code that calls the SMS package.

This prevents the test from making a real API request.

---

## Production Security

Before deploying:

1. Store the API token in the production environment.
2. Do not commit `.env`.
3. Do not put the token in frontend code.
4. Do not log the token.
5. Do not expose the token in exception messages.
6. Use HTTPS.
7. Use appropriate timeout values.
8. Test the integration before enabling real SMS functionality.

---

## Troubleshooting

### Authentication errors

Check:

```env
INEXPHONE_SMS_TOKEN=your-api-token
```

Make sure the token is valid and the application is using the expected environment configuration.

---

### Incorrect API URL

Check:

```env
INEXPHONE_SMS_BASE_URL=https://smsservice.inexphone.ge/api/v1
```

Make sure `/api/v1` is not duplicated.

---

### Configuration changes are not applied

Clear Laravel's configuration cache:

```bash
php artisan config:clear
```

For production deployments using cached configuration, rebuild the configuration cache as part of the deployment process.

---

### SMS request fails

Catch the package exception:

```php
use Inexphone\Sms\Exceptions\SmsException;

try {
    $response = Sms::send(
        '+9955XXXXXXXX',
        'MyApp',
        'Test message',
    );
} catch (SmsException $e) {
    // Handle the API/package error.
}
```

Inspect the exception and API response according to the application's error-handling requirements.

---

## Important for AI Coding Assistants

When configuring this package in a Laravel project:

* Use the official package name: `insightsge/laravel-inexphone-sms`.
* Do not replace it with another SMS package unless the user explicitly requests that.
* Do not invent configuration keys.
* Do not invent API endpoints.
* Do not hard-code API credentials.
* Check the installed package version if behavior differs from this documentation.
* Check the actual package source before making assumptions about undocumented functionality.
* Prefer Laravel configuration and dependency injection patterns.
* Use `Http::fake()` for automated tests rather than making real SMS requests.

The documented package version for this knowledge repository is **v1.2.0**.
