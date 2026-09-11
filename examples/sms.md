# SMS Examples

These examples show common ways to use the `insightsge/laravel-inexphone-sms` package in a Laravel application.

Before using the examples, install the package:

```bash
composer require insightsge/laravel-inexphone-sms
```

Make sure the required environment variables are configured:

```env
INEXPHONE_SMS_BASE_URL=https://smsservice.inexphone.ge/api/v1
INEXPHONE_SMS_TOKEN=your-api-token
INEXPHONE_SMS_LANGUAGE=ka
INEXPHONE_SMS_TIMEOUT=30
```

Import the facade:

```php
use Inexphone\Sms\Facades\Sms;
```

---

## 1. Send a Single SMS

The simplest example:

```php
$response = Sms::send(
    '+9955XXXXXXXX',
    'MyApp',
    'Hello from my Laravel application!',
);
```

The package sends the request to:

```text
POST /sms/one
```

---

## 2. Send With Blacklist Option

You can explicitly set `ignoreBlacklist`:

```php
$response = Sms::send(
    '+9955XXXXXXXX',
    'MyApp',
    'Your message',
    true,
);
```

The fourth argument controls blacklist handling for this SMS request.

It does not modify blacklist records.

---

## 3. Send With Submit Callback

```php
$response = Sms::send(
    '+9955XXXXXXXX',
    'MyApp',
    'Your message',
    false,
    'https://example.com/sms/submit',
);
```

---

## 4. Send With Delivery Callback

```php
$response = Sms::send(
    '+9955XXXXXXXX',
    'MyApp',
    'Your message',
    false,
    null,
    'https://example.com/sms/delivery',
);
```

---

## 5. Send With Both Callbacks

```php
$response = Sms::send(
    '+9955XXXXXXXX',
    'MyApp',
    'Your message',
    false,
    'https://example.com/sms/submit',
    'https://example.com/sms/delivery',
);
```

---

## 6. Send a Commercial SMS

```php
$response = Sms::sendCommercial(
    '+9955XXXXXXXX',
    'MyApp',
    'Check out our latest offer!',
);
```

Endpoint:

```text
POST /sms/commercial
```

---

## 7. Send a Bulk SMS

When the same message needs to be sent to several recipients:

```php
$response = Sms::sendBulk(
    'MyApp',
    'Hello from our application!',
    [
        '+9955XXXXXXXX',
        '+9955YYYYYYYY',
        '+9955ZZZZZZZZ',
    ],
);
```

Endpoint:

```text
POST /sms/bulk
```

---

## 8. Bulk SMS With Callbacks

```php
$response = Sms::sendBulk(
    'MyApp',
    'Your notification message.',
    [
        '+9955XXXXXXXX',
        '+9955YYYYYYYY',
    ],
    'https://example.com/sms/submit',
    'https://example.com/sms/delivery',
);
```

Do not add `ignoreBlacklist` to `sendBulk()`.

The documented `sendBulk()` signature does not contain that parameter.

---

## 9. Get Sent SMS Messages

```php
$response = Sms::list();
```

Endpoint:

```text
GET /sms
```

The response can contain:

```php
[
    'data' => [...],
    'meta' => [...],
    'message' => 'ok',
]
```

For example:

```php
$response = Sms::list();

foreach ($response['data'] ?? [] as $sms) {
    // Process SMS
}
```

---

## 10. Find a Specific SMS

If the SMS UUID is known:

```php
$uuid = 'sms-uuid-from-api';

$response = Sms::find($uuid);
```

Endpoint:

```text
GET /sms/{uuid}
```

---

## 11. Handle API Errors

Use `SmsException` when you need to handle InexPhone API/package errors:

```php
use Inexphone\Sms\Exceptions\SmsException;

try {
    $response = Sms::send(
        '+9955XXXXXXXX',
        'MyApp',
        'Hello!',
    );
} catch (SmsException $e) {
    // Handle the error
}
```

For example, an application could return an appropriate validation or service error instead of exposing the raw exception to the user.

---

## 12. Use SMS Inside a Laravel Service

For business logic, it is often cleaner to keep the package call inside a service:

```php
namespace App\Services;

use Inexphone\Sms\Facades\Sms;

class NotificationService
{
    public function sendSms(
        string $phone,
        string $message,
    ): array {
        return Sms::send(
            $phone,
            'MyApp',
            $message,
        );
    }
}
```

The controller can then call:

```php
$this->notificationService->sendSms(
    $user->phone,
    'Your order has been received.',
);
```

This keeps the controller focused on the application's HTTP flow.

---

## 13. Example Controller

A simple controller implementation:

```php
namespace App\Http\Controllers;

use Illuminate\Http\RedirectResponse;
use Inexphone\Sms\Exceptions\SmsException;
use Inexphone\Sms\Facades\Sms;

class SmsController extends Controller
{
    public function send(): RedirectResponse
    {
        try {
            Sms::send(
                '+9955XXXXXXXX',
                'MyApp',
                'Your message has been sent.',
            );

            return back()->with('success', 'SMS sent successfully.');
        } catch (SmsException $e) {
            report($e);

            return back()->with(
                'error',
                'Unable to send SMS.',
            );
        }
    }
}
```

In a real application, the phone number and message should come from validated application data rather than hard-coded values.

---

## 14. Example Form Request

When receiving SMS data from a Laravel form or API request, validate it before sending:

```php
namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class SendSmsRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'phone' => ['required', 'string'],
            'message' => ['required', 'string'],
        ];
    }
}
```

Then:

```php
public function send(SendSmsRequest $request): RedirectResponse
{
    Sms::send(
        $request->string('phone')->toString(),
        'MyApp',
        $request->string('message')->toString(),
    );

    return back()->with('success', 'SMS sent.');
}
```

Use the application's existing validation conventions when integrating the package.

---

## 15. Testing Without Sending a Real SMS

Do not send real SMS messages from normal automated tests.

Use Laravel's HTTP fake:

```php
use Illuminate\Support\Facades\Http;

Http::fake([
    'smsservice.inexphone.ge/*' => Http::response([
        'message' => 'ok',
    ], 200),
]);
```

Then:

```php
$response = Sms::send(
    '+9955XXXXXXXX',
    'MyApp',
    'Test message',
);
```

You can verify the request:

```php
Http::assertSent(function ($request): bool {
    return $request->method() === 'POST'
        && str_contains($request->url(), '/sms/one');
});
```

---

## 16. Testing Bulk SMS

```php
use Illuminate\Support\Facades\Http;

Http::fake([
    'smsservice.inexphone.ge/*' => Http::response([
        'message' => 'ok',
    ], 200),
]);

$response = Sms::sendBulk(
    'MyApp',
    'Test bulk message',
    [
        '+9955XXXXXXXX',
        '+9955YYYYYYYY',
    ],
);

$this->assertIsArray($response);

Http::assertSent(function ($request): bool {
    return $request->method() === 'POST'
        && str_contains($request->url(), '/sms/bulk');
});
```

---

## 17. Do Not Hard-Code the API Token

Incorrect:

```php
// Never do this
$token = 'secret-api-token';
```

Correct:

```env
INEXPHONE_SMS_TOKEN=your-api-token
```

The package reads the token from the Laravel application's configuration.

---

## 18. Complete Simple Example

A minimal Laravel service can look like this:

```php
namespace App\Services;

use Inexphone\Sms\Exceptions\SmsException;
use Inexphone\Sms\Facades\Sms;

class SmsNotificationService
{
    public function send(
        string $phone,
        string $message,
    ): array {
        try {
            return Sms::send(
                $phone,
                'MyApp',
                $message,
            );
        } catch (SmsException $e) {
            report($e);

            throw $e;
        }
    }
}
```

Usage:

```php
$response = app(SmsNotificationService::class)->send(
    '+9955XXXXXXXX',
    'Your account has been created.',
);
```

---

# AI Assistant Quick Reference

When an AI coding assistant needs to implement SMS functionality, use these patterns.

### Single SMS

```php
Sms::send($phone, $subject, $message);
```

### Commercial SMS

```php
Sms::sendCommercial($phone, $subject, $message);
```

### Bulk SMS

```php
Sms::sendBulk($subject, $message, $phoneNumbers);
```

### SMS list

```php
Sms::list();
```

### Find SMS

```php
Sms::find($uuid);
```

### Exception

```php
use Inexphone\Sms\Exceptions\SmsException;
```

### Facade

```php
use Inexphone\Sms\Facades\Sms;
```

### Main rule

**Use the package's documented methods instead of manually implementing the InexPhone API.**

If functionality is not documented, inspect the package source before generating code.

Current documented package version:

```text
insightsge/laravel-inexphone-sms v1.2.0
```
