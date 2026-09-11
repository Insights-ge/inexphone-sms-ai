# SMS API

The `insightsge/laravel-inexphone-sms` package provides methods for sending SMS messages and retrieving SMS information through the InexPhone API.

Import the facade:

```php
use Inexphone\Sms\Facades\Sms;
```

---

## Available SMS Methods

| Method             | HTTP | Endpoint          | Purpose                            |
| ------------------ | ---- | ----------------- | ---------------------------------- |
| `send()`           | POST | `/sms/one`        | Send a single SMS                  |
| `sendCommercial()` | POST | `/sms/commercial` | Send a commercial SMS              |
| `sendBulk()`       | POST | `/sms/bulk`       | Send SMS to multiple phone numbers |
| `list()`           | GET  | `/sms`            | Retrieve sent SMS messages         |
| `find()`           | GET  | `/sms/{uuid}`     | Retrieve one SMS by UUID           |

---

# Send a Single SMS

Use `Sms::send()` to send a single SMS message.

```php
$response = Sms::send(
    '+9955XXXXXXXX',
    'MyApp',
    'Hello from my application!',
);
```

### Method Signature

```php
Sms::send(
    string $phone,
    string $subject,
    string $message,
    bool $ignoreBlacklist = false,
    ?string $submitCallbackUrl = null,
    ?string $deliveryCallbackUrl = null,
): array
```

### Parameters

| Parameter              | Type      | Description                                      |
| ---------------------- | --------- | ------------------------------------------------ |
| `$phone`               | `string`  | Recipient phone number                           |
| `$subject`             | `string`  | SMS sender/subject value expected by the API     |
| `$message`             | `string`  | SMS message text                                 |
| `$ignoreBlacklist`     | `bool`    | Controls whether the blacklist should be ignored |
| `$submitCallbackUrl`   | `?string` | Optional submit callback URL                     |
| `$deliveryCallbackUrl` | `?string` | Optional delivery callback URL                   |

### Ignore Blacklist

The fourth argument can be used to control blacklist handling:

```php
$response = Sms::send(
    '+9955XXXXXXXX',
    'MyApp',
    'Your message',
    true,
);
```

`ignoreBlacklist` is a sending option.

It does **not** create, update, or delete blacklist records.

---

## Submit Callback

A submit callback URL can be provided as the fifth argument:

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

## Delivery Callback

A delivery callback URL can be provided as the sixth argument:

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

Both callback URLs can also be supplied:

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

Only use callback URLs supported by the API and appropriate for the application.

---

# Send Commercial SMS

Use `Sms::sendCommercial()` for commercial SMS messages.

```php
$response = Sms::sendCommercial(
    '+9955XXXXXXXX',
    'MyApp',
    'Check out our latest offer!',
);
```

The endpoint is:

```text
POST /sms/commercial
```

Use the method signature provided by the installed package rather than manually constructing the HTTP request.

Commercial SMS should only be used where the application and recipient relationship comply with the applicable API and messaging requirements.

---

# Send Bulk SMS

Use `Sms::sendBulk()` when the same message needs to be sent to multiple phone numbers.

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

The endpoint is:

```text
POST /sms/bulk
```

### Method Signature

```php
Sms::sendBulk(
    string $subject,
    string $message,
    array $phoneNumbers,
    ?string $submitCallbackUrl = null,
    ?string $deliveryCallbackUrl = null,
): array
```

### Parameters

| Parameter              | Type      | Description                    |
| ---------------------- | --------- | ------------------------------ |
| `$subject`             | `string`  | SMS sender/subject value       |
| `$message`             | `string`  | Message text                   |
| `$phoneNumbers`        | `array`   | Recipient phone numbers        |
| `$submitCallbackUrl`   | `?string` | Optional submit callback URL   |
| `$deliveryCallbackUrl` | `?string` | Optional delivery callback URL |

### Bulk With Callbacks

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

Do not assume that bulk SMS has the same parameters as `send()`.

For example, do not add `ignoreBlacklist` to `sendBulk()` unless the installed package/API explicitly supports it.

---

# Retrieve SMS List

Use:

```php
$response = Sms::list();
```

The endpoint is:

```text
GET /sms
```

The method is useful for retrieving previously sent SMS messages and their delivery information.

Example:

```php
use Inexphone\Sms\Facades\Sms;

$response = Sms::list();

foreach ($response['data'] ?? [] as $sms) {
    // Process SMS record
}
```

The API response may contain structures such as:

```php
[
    'data' => [...],
    'meta' => [...],
    'message' => 'ok',
]
```

Do not assume every response contains exactly the same fields. Use the API response and package behavior as the source of truth.

---

# Find an SMS

Use `Sms::find()` when the UUID of a specific SMS is known.

```php
$response = Sms::find($uuid);
```

The endpoint is:

```text
GET /sms/{uuid}
```

Example:

```php
$uuid = 'sms-uuid-from-api';

$response = Sms::find($uuid);
```

The UUID should come from the InexPhone API response or another trusted source.

Do not invent UUID values or assume that another identifier can be used in its place.

---

# Error Handling

SMS API failures are represented by the package's `SmsException`.

```php
use Inexphone\Sms\Exceptions\SmsException;

try {
    $response = Sms::send(
        '+9955XXXXXXXX',
        'MyApp',
        'Hello!',
    );
} catch (SmsException $e) {
    // Handle InexPhone API error
}
```

The application can log or transform the exception according to its existing error-handling architecture.

Do not expose API credentials while logging exceptions.

---

# Using SMS From a Laravel Service

For larger applications, keep SMS-related business logic outside controllers.

Example:

```php
namespace App\Services;

use Inexphone\Sms\Facades\Sms;

class NotificationService
{
    public function sendNotification(
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

A controller can then call the application service:

```php
public function store(): RedirectResponse
{
    $this->notificationService->sendNotification(
        $user->phone,
        'Your order has been received.',
    );

    // ...
}
```

This keeps the controller focused on HTTP/application flow while the service handles notification behavior.

---

# Testing

Do not send real SMS messages from normal automated tests.

Use Laravel's HTTP fake functionality where appropriate:

```php
use Illuminate\Support\Facades\Http;

Http::fake([
    'smsservice.inexphone.ge/*' => Http::response([
        'message' => 'ok',
    ], 200),
]);
```

Then execute the application code that calls the package.

Tests should verify that the expected endpoint and request data are generated.

Example test structure:

```php
public function test_it_sends_an_sms(): void
{
    Http::fake([
        'smsservice.inexphone.ge/*' => Http::response([
            'message' => 'ok',
        ], 200),
    ]);

    $response = Sms::send(
        '+9955XXXXXXXX',
        'MyApp',
        'Test message',
    );

    Http::assertSent(function ($request): bool {
        return $request->method() === 'POST'
            && str_contains($request->url(), '/sms/one');
    });

    $this->assertIsArray($response);
}
```

Adjust the test to match the actual package implementation and response structure.

---

# Important Rules for AI Assistants

When generating SMS-related code:

### Use the package

```php
use Inexphone\Sms\Facades\Sms;
```

Do not manually recreate the API client when the package already provides the required method.

### Use documented methods

```text
send
sendCommercial
sendBulk
list
find
```

### Do not invent endpoints

Valid documented endpoints include:

```text
POST /sms/one
POST /sms/commercial
POST /sms/bulk
GET  /sms
GET  /sms/{uuid}
```

### Do not invent parameters

Use the method signatures documented by the package.

### Do not expose credentials

Never put the InexPhone token into application source code or frontend code.

### Check the installed version

This documentation currently targets:

```text
insightsge/laravel-inexphone-sms v1.2.0
```

If the project uses another version, inspect the installed package before assuming that the same API is available.

### When uncertain

Inspect:

1. The installed package source
2. `SKILL.md`
3. The relevant file in `docs/`
4. The relevant example

**Never guess undocumented API behavior.**
