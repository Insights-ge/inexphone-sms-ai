# OTP Examples

These examples show common ways to implement OTP functionality with the `insightsge/laravel-inexphone-sms` package.

Import the facade:

```php
use Inexphone\Sms\Facades\Sms;
```

---

## 1. Send a Basic OTP

The simplest OTP request:

```php
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
);
```

This uses the API defaults:

* Default message: `Your verification code is: {{CODE}}`
* Expiration: 60 seconds
* Code length: 4 digits

---

## 2. Send OTP With Custom Settings

You can provide custom text, expiration, and code length:

```php
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
    'Your verification code is: {{CODE}}',
    120,
    6,
);
```

The arguments are:

```php
Sms::sendOtp(
    $phone,
    $subject,
    $text,
    $expiresIn,
    $codeDigits,
);
```

Only use values supported by the InexPhone API.

---

## 3. Send OTP With Custom Message

If you only want to change the message:

```php
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
    'Your code is: {{CODE}}',
);
```

The `{{CODE}}` placeholder is used for the generated OTP code.

---

## 4. Send OTP With Custom Expiration

```php
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
    null,
    120,
);
```

This requests a 120-second expiration period.

---

## 5. Send a Six-Digit OTP

```php
$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
    null,
    null,
    6,
);
```

The final argument controls the OTP code length.

Do not assume that every possible code length is accepted by the API.

---

## 6. Verify OTP

After the user enters the received code:

```php
$response = Sms::verifyOtp(
    '+9955XXXXXXXX',
    '1234',
);
```

The verification endpoint is:

```text
POST /otp/verify
```

The request contains:

```text
phone
code
```

### Important

Do **not** pass the subject to `verifyOtp()`.

Correct:

```php
Sms::verifyOtp(
    $phone,
    $code,
);
```

Incorrect:

```php
// Do not do this
Sms::verifyOtp(
    $phone,
    $code,
    $subject,
);
```

---

# 7. Basic OTP Controller

A simple controller can send an OTP:

```php
namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Inexphone\Sms\Facades\Sms;

class OtpController extends Controller
{
    public function send(): JsonResponse
    {
        $response = Sms::sendOtp(
            '+9955XXXXXXXX',
            'idrive',
        );

        return response()->json($response);
    }
}
```

In a real application, the phone number should come from validated request data.

---

# 8. OTP Controller With Validation

Use a Form Request or appropriate validation before sending an OTP.

Example:

```php
namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Inexphone\Sms\Facades\Sms;

class OtpController extends Controller
{
    public function send(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'phone' => ['required', 'string'],
        ]);

        $response = Sms::sendOtp(
            $validated['phone'],
            'idrive',
        );

        return response()->json($response);
    }
}
```

For larger applications, prefer a dedicated Form Request instead of keeping complex validation inside the controller.

---

# 9. Verify OTP From a Request

Example:

```php
public function verify(Request $request): JsonResponse
{
    $validated = $request->validate([
        'phone' => ['required', 'string'],
        'code' => ['required', 'string'],
    ]);

    $response = Sms::verifyOtp(
        $validated['phone'],
        $validated['code'],
    );

    return response()->json($response);
}
```

The application can decide what should happen after successful verification.

For example, the application might mark a phone number as verified.

---

# 10. Recommended Service Layer

For a reusable OTP flow, keep the InexPhone integration inside an application service:

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

    public function verify(
        string $phone,
        string $code,
    ): array {
        return Sms::verifyOtp(
            $phone,
            $code,
        );
    }
}
```

Then a controller can use the service:

```php
$response = $this->otpService->send($phone);
```

and:

```php
$response = $this->otpService->verify(
    $phone,
    $code,
);
```

This keeps API-specific logic out of the controller.

---

# 11. Handle OTP Errors

Use the package exception when you need to handle InexPhone failures:

```php
use Inexphone\Sms\Exceptions\SmsException;

try {
    $response = Sms::sendOtp(
        '+9955XXXXXXXX',
        'idrive',
    );
} catch (SmsException $e) {
    report($e);

    // Return an appropriate application response.
}
```

The same applies to verification:

```php
try {
    $response = Sms::verifyOtp(
        '+9955XXXXXXXX',
        '1234',
    );
} catch (SmsException $e) {
    report($e);
}
```

Do not expose the raw exception or API credentials to end users.

---

# 12. Testing Send OTP

Normal automated tests should not send real OTP messages.

Use Laravel's HTTP fake:

```php
use Illuminate\Support\Facades\Http;

Http::fake([
    'smsservice.inexphone.ge/*' => Http::response([
        'message' => 'ok',
    ], 200),
]);

$response = Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
);
```

Then verify that the correct endpoint was requested:

```php
Http::assertSent(function ($request): bool {
    return $request->method() === 'POST'
        && str_contains($request->url(), '/otp/send');
});
```

---

# 13. Testing OTP Verification

Fake the verification endpoint:

```php
use Illuminate\Support\Facades\Http;

Http::fake([
    'smsservice.inexphone.ge/*' => Http::response([
        'message' => 'ok',
    ], 200),
]);

$response = Sms::verifyOtp(
    '+9955XXXXXXXX',
    '1234',
);
```

Verify the request:

```php
Http::assertSent(function ($request): bool {
    return $request->method() === 'POST'
        && str_contains($request->url(), '/otp/verify')
        && $request['phone'] === '+9955XXXXXXXX'
        && $request['code'] === '1234';
});
```

This is particularly useful because it ensures the verification request contains the expected fields.

---

# 14. Complete OTP Flow

A simple application flow:

```php
use Inexphone\Sms\Facades\Sms;

// Step 1: User provides phone number.
$phone = '+9955XXXXXXXX';

// Step 2: Send OTP.
Sms::sendOtp(
    $phone,
    'idrive',
);

// Step 3: User enters the received code.
$code = '1234';

// Step 4: Verify OTP.
$result = Sms::verifyOtp(
    $phone,
    $code,
);
```

The application should perform its own business logic after successful verification.

---

# 15. OTP Subject Restriction

The subject must not exceed **11 characters**.

For example:

```php
Sms::sendOtp(
    '+9955XXXXXXXX',
    'idrive',
);
```

is valid with respect to the documented length restriction.

Avoid:

```php
Sms::sendOtp(
    '+9955XXXXXXXX',
    'Verification',
);
```

because `Verification` exceeds the documented 11-character limit.

AI assistants should check this restriction when generating OTP code.

---

# 16. Security Rules

OTP codes are authentication credentials.

Applications should:

* Never log OTP codes unnecessarily.
* Never expose OTP codes in application logs.
* Never put the API token in frontend JavaScript.
* Use HTTPS.
* Respect OTP expiration.
* Apply appropriate rate limiting.
* Avoid storing OTP codes unnecessarily.
* Handle failed verification safely.

Do not implement custom OTP behavior that contradicts the API unless explicitly required and documented.

---

# 17. Do Not Invent OTP Methods

The package currently documents:

```php
Sms::sendOtp();
Sms::verifyOtp();
```

Do not assume methods such as:

```php
Sms::resendOtp();
Sms::getOtp();
Sms::deleteOtp();
Sms::generateOtp();
```

exist.

If a future package version introduces additional OTP functionality, update the documentation and inspect the actual implementation first.

---

# AI Quick Reference

### Send

```php
Sms::sendOtp(
    $phone,
    $subject,
);
```

### Send with options

```php
Sms::sendOtp(
    $phone,
    $subject,
    $text,
    $expiresIn,
    $codeDigits,
);
```

### Verify

```php
Sms::verifyOtp(
    $phone,
    $code,
);
```

### Endpoints

```text
POST /otp/send
POST /otp/verify
```

### Critical rule

`verifyOtp()` uses **only the phone number and code**.

Current documented package version:

```text
insightsge/laravel-inexphone-sms v1.2.0
```
