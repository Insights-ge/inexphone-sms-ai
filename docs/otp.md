# OTP API

The `insightsge/laravel-inexphone-sms` package provides methods for sending and verifying one-time passwords (OTP) through the InexPhone API.

Import the facade:

```php
use Inexphone\Sms\Facades\Sms;
```

The package supports:

```php
Sms::sendOtp()
Sms::verifyOtp()
```

---

## OTP Endpoints

| Method        | HTTP | Endpoint      | Purpose            |
| ------------- | ---- | ------------- | ------------------ |
| `sendOtp()`   | POST | `/otp/send`   | Send an OTP code   |
| `verifyOtp()` | POST | `/otp/verify` | Verify an OTP code |

---

# Send OTP

Use `Sms::sendOtp()` to request an OTP code for a phone number.

```php
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
);
```

The endpoint is:

```text
POST /otp/send
```

## Method Signature

```php
Sms::sendOtp(
    string $phone,
    string $subject,
    ?string $text = null,
    ?int $expiresIn = null,
    ?int $codeDigits = null,
): array
```

## Parameters

| Parameter     | Type      | Description                    |
| ------------- | --------- | ------------------------------ |
| `$phone`      | `string`  | Phone number receiving the OTP |
| `$subject`    | `string`  | OTP SMS subject/sender         |
| `$text`       | `?string` | Optional OTP message template  |
| `$expiresIn`  | `?int`    | Optional OTP expiration time   |
| `$codeDigits` | `?int`    | Optional OTP code length       |

---

# OTP Defaults

If optional parameters are not provided, the API uses its documented defaults:

### Message

```text
Your verification code is: {{CODE}}
```

`{{CODE}}` is replaced by the generated OTP code.

### Expiration

```text
60 seconds
```

### Code length

```text
4 digits
```

Therefore:

```php
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
);
```

uses the API defaults.

---

# Custom OTP Settings

The optional parameters can be used when the application needs different OTP settings.

Example:

```php
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
    'Your verification code is: {{CODE}}',
    120,
    6,
);
```

This requests:

* Custom message text
* 120-second expiration
* 6-digit OTP

Only use values supported by the InexPhone API.

Do not assume arbitrary expiration times or code lengths are accepted.

---

# OTP Subject

The OTP subject must comply with the API's subject restriction.

The subject must not exceed **11 characters**.

For example:

```php
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
);
```

A subject such as:

```text
Verification
```

should not be used because it exceeds the documented limit.

When an API restriction is known, do not work around it by inventing a different request structure. Use a valid subject.

---

# Verify OTP

After the user receives the OTP, use `Sms::verifyOtp()` to verify the code.

```php
$response = Sms::verifyOtp(
    '+9955XXXXXXXX',
    '1234',
);
```

The endpoint is:

```text
POST /otp/verify
```

## Important

The verification request contains only:

```text
phone
code
```

Do **not** add the OTP subject.

Correct:

```php
$response = Sms::verifyOtp(
    $phone,
    $code,
);
```

Do not do this:

```php
// Incorrect
Sms::verifyOtp(
    $phone,
    $code,
    $subject,
);
```

The package method is intentionally defined around the API's verification request.

---

# Typical OTP Flow

A normal application flow is:

```text
User enters phone number
        ↓
Application calls sendOtp()
        ↓
InexPhone generates and sends OTP
        ↓
User receives OTP
        ↓
User enters OTP
        ↓
Application calls verifyOtp()
        ↓
InexPhone verifies the code
        ↓
Application continues authentication/verification flow
```

Example:

```php
$phone = '+9955XXXXXXXX';

Sms::sendOtp(
    $phone,
    'idrive',
);

// Later, after the user enters the code:

$result = Sms::verifyOtp(
    $phone,
    $code,
);
```

The application should decide what to do after successful verification.

For example, it may mark a phone number as verified or continue an authentication flow.

---

# Service Layer Example

For a larger Laravel application, OTP logic can be placed inside an application service.

```php
namespace App\Services;

use Inexphone\Sms\Facades\Sms;

class OtpService
{
    public function send(string $phone): array
    {
        return Sms::sendOtp(
            $phone,
            'idrive',
        );
    }

    public function verify(string $phone, string $code): array
    {
        return Sms::verifyOtp(
            $phone,
            $code,
        );
    }
}
```

A controller can then use the service instead of directly containing the integration logic.

---

# Error Handling

OTP API errors are handled through the package's `SmsException`.

```php
use Inexphone\Sms\Exceptions\SmsException;

try {
    $response = Sms::sendOtp(
        '+9955XXXXXXXX',
        'idrive',
    );
} catch (SmsException $e) {
    // Handle the API/package error.
}
```

The same applies to OTP verification:

```php
try {
    $response = Sms::verifyOtp(
        '+9955XXXXXXXX',
        '1234',
    );
} catch (SmsException $e) {
    // Handle verification error.
}
```

Follow the application's existing error-handling conventions.

Do not expose API credentials in logs or error responses.

---

# Testing OTP Integration

Automated tests should not normally send real OTP messages.

Use Laravel HTTP fakes:

```php
use Illuminate\Support\Facades\Http;

Http::fake([
    'smsservice.inexphone.ge/*' => Http::response([
        'message' => 'ok',
    ], 200),
]);
```

Then call the package method:

```php
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
);
```

Tests should verify that:

* The correct HTTP method is used.
* `/otp/send` is requested.
* The expected request data is sent.
* The response is handled correctly.

For verification, test that `/otp/verify` receives the expected `phone` and `code`.

---

# Security Considerations

OTP codes are authentication credentials and should be handled carefully.

Application code should:

* Avoid logging OTP codes.
* Avoid exposing OTP codes in frontend responses.
* Use HTTPS.
* Keep the InexPhone API token secret.
* Respect the OTP expiration period.
* Follow the application's authentication and rate-limiting rules.

Do not store OTP values unnecessarily.

---

# AI Assistant Rules

When generating OTP-related code:

### Use the package

```php
use Inexphone\Sms\Facades\Sms;
```

### Send OTP

Use:

```php
Sms::sendOtp(
    $phone,
    $subject,
);
```

Optional arguments are:

```php
Sms::sendOtp(
    $phone,
    $subject,
    $text,
    $expiresIn,
    $codeDigits,
);
```

### Verify OTP

Use:

```php
Sms::verifyOtp(
    $phone,
    $code,
);
```

The verification request must contain only the documented `phone` and `code` values.

### Do not invent methods

Do not create methods such as:

```text
generateOtp()
resendOtp()
deleteOtp()
getOtp()
```

unless they are explicitly added to a future package version.

### Do not invent endpoints

The documented OTP endpoints are:

```text
POST /otp/send
POST /otp/verify
```

### Respect the subject restriction

OTP subjects must not exceed 11 characters.

### Check the installed version

This documentation currently targets:

```text
insightsge/laravel-inexphone-sms v1.2.0
```

If the installed package differs, inspect its source before making assumptions.

---

# Quick Reference

```php
use Inexphone\Sms\Facades\Sms;

// Send OTP
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
);

// Send OTP with custom settings
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
    'Your verification code is: {{CODE}}',
    120,
    6,
);

// Verify OTP
$response = Sms::verifyOtp(
    '+9955XXXXXXXX',
    '1234',
);
```

The key rule is simple:

**`sendOtp()` sends the code; `verifyOtp()` verifies it using only the phone number and code.**
