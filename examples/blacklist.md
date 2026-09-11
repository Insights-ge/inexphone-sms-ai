# Blacklist Examples

These examples show how to retrieve and inspect blacklist records using the `insightsge/laravel-inexphone-sms` package.

Import the facade:

```php id="h3q9w7"
use Inexphone\Sms\Facades\Sms;
```

The package currently provides read-only blacklist operations:

```php id="v6m2k8"
Sms::blacklists()
Sms::findBlacklist()
```

---

## 1. Get All Blacklists

The simplest request:

```php id="j8r4p2"
$response = Sms::blacklists();
```

The API endpoint is:

```text id="k5n7c3"
GET /blacklists
```

A successful response can contain:

```php id="m2x9q4"
[
    'data' => [...],
    'meta' => [...],
    'message' => 'ok',
]
```

---

## 2. Get Blacklists With Pagination

Use `page` and `perPage`:

```php id="r7w3n5"
$response = Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
]);
```

For example:

```php id="b4k8y1"
$data = $response['data'] ?? [];

foreach ($data as $blacklist) {
    // Process blacklist record
}
```

Pagination information may be available under:

```php id="s6p2v9"
$response['meta']['pagination'] ?? [];
```

---

## 3. Filter by Keywords

```php id="q1m7d4"
$response = Sms::blacklists([
    'filters[keywords]' => 'test',
]);
```

---

## 4. Filter by Subject

```php id="x5c8r2"
$response = Sms::blacklists([
    'filters[subjects]' => 'MyApp',
]);
```

---

## 5. Filter by Phone Number

```php id="n3v6k9"
$response = Sms::blacklists([
    'filters[number]' => '+9955XXXXXXXX',
]);
```

---

## 6. Filter by End Date

The API expects:

```text id="p8s4m1"
d/m/Y
```

Example:

```php id="a7q2w5"
$response = Sms::blacklists([
    'filters[dateEnd]' => '31/12/2026',
]);
```

Do not use formats such as:

```text id="u4h9k2"
2026-12-31
```

unless the API documentation explicitly supports them.

---

## 7. Combine Filters

Multiple filters can be passed together:

```php id="c5r8n1"
$response = Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
    'filters[keywords]' => 'test',
    'filters[subjects]' => 'MyApp',
    'filters[number]' => '+9955XXXXXXXX',
    'filters[dateEnd]' => '31/12/2026',
]);
```

Only include filters required by the application.

---

## 8. Find a Specific Blacklist

When the blacklist ID is known:

```php id="f2m7x4"
$response = Sms::findBlacklist('123');
```

Endpoint:

```text id="w8c3q6"
GET /blacklists/123
```

The package method accepts the ID as a string:

```php id="d6n1v9"
$response = Sms::findBlacklist($id);
```

---

## 9. Handle an Empty Result

An account may not have any blacklist records.

For example:

```php id="g4r8p2"
$response = Sms::blacklists();

if (empty($response['data'])) {
    // No blacklist records found.
}
```

An empty `data` array does not necessarily indicate an error.

---

## 10. Handle API Errors

Use `SmsException`:

```php id="y5k2m8"
use Inexphone\Sms\Exceptions\SmsException;

try {
    $response = Sms::blacklists();
} catch (SmsException $e) {
    report($e);

    // Handle the error according to the application.
}
```

For a specific record:

```php id="p9v3c7"
try {
    $response = Sms::findBlacklist('123');
} catch (SmsException $e) {
    report($e);
}
```

Do not expose the API token or other sensitive configuration when displaying errors.

---

## 11. Laravel Service Example

For reusable blacklist functionality:

```php id="r4n8w1"
namespace App\Services;

use Inexphone\Sms\Facades\Sms;

class BlacklistService
{
    public function getAll(array $filters = []): array
    {
        return Sms::blacklists($filters);
    }

    public function find(string $id): array
    {
        return Sms::findBlacklist($id);
    }
}
```

The controller can then use:

```php id="m7q2x5"
$blacklists = $this->blacklistService->getAll([
    'page' => 1,
    'perPage' => 20,
]);
```

This keeps InexPhone-specific integration code out of the controller.

---

## 12. Example Controller

A simple JSON endpoint:

```php id="v3c9k6"
namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Inexphone\Sms\Facades\Sms;

class BlacklistController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $response = Sms::blacklists([
            'page' => $request->input('page', 1),
            'perPage' => $request->input('perPage', 20),
        ]);

        return response()->json($response);
    }
}
```

For production applications, validate and constrain user-provided pagination and filter values according to the application's requirements.

---

## 13. Testing Blacklist Requests

Use Laravel's HTTP fake instead of calling the real API:

```php id="q6w1m8"
use Illuminate\Support\Facades\Http;

Http::fake([
    'smsservice.inexphone.ge/*' => Http::response([
        'data' => [],
        'meta' => [
            'pagination' => [
                'total' => 0,
                'count' => 0,
                'perPage' => 20,
                'currentPage' => 1,
                'totalPages' => 1,
            ],
        ],
        'message' => 'ok',
    ], 200),
]);
```

Then:

```php id="k4r7n2"
$response = Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
]);

$this->assertIsArray($response);
```

---

## 14. Test Query Parameters

When testing filters, verify that the expected query parameters are sent:

```php id="b8m3v6"
Http::fake([
    'smsservice.inexphone.ge/*' => Http::response([
        'data' => [],
        'message' => 'ok',
    ], 200),
]);

Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
    'filters[keywords]' => 'test',
]);
```

Then inspect the request using Laravel's HTTP testing tools.

The test should verify the actual query structure produced by the installed package.

---

## 15. Test Finding a Blacklist

```php id="x2q8c5"
Http::fake([
    'smsservice.inexphone.ge/*' => Http::response([
        'data' => [
            'id' => '123',
        ],
        'message' => 'ok',
    ], 200),
]);

$response = Sms::findBlacklist('123');

$this->assertIsArray($response);
```

The request should target:

```text id="s1n6w9"
GET /blacklists/123
```

---

# Important Limitation

The current documented API provides:

```text id="e7p4m2"
GET /blacklists
GET /blacklists/{id}
```

It does **not** document endpoints for creating or deleting blacklist entries.

Therefore, these methods should not be assumed to exist:

```php id="z3k8r5"
Sms::addBlacklist();
Sms::removeBlacklist();
Sms::deleteBlacklist();
Sms::updateBlacklist();
```

If blacklist management is requested, first verify whether a newer package/API version supports it.

---

# Blacklist vs `ignoreBlacklist`

These are different features.

Blacklist lookup:

```php id="n5c2v7"
Sms::blacklists();
Sms::findBlacklist($id);
```

reads blacklist information.

The SMS sending option:

```php id="q8m4x1"
Sms::send(
    $phone,
    $subject,
    $message,
    true, // ignoreBlacklist
);
```

controls blacklist behavior for that SMS request.

It does not create or delete blacklist records.

---

# Complete Example

```php id="r6w2p9"
use Inexphone\Sms\Exceptions\SmsException;
use Inexphone\Sms\Facades\Sms;

try {
    $response = Sms::blacklists([
        'page' => 1,
        'perPage' => 20,
        'filters[number]' => '+9955XXXXXXXX',
    ]);

    foreach ($response['data'] ?? [] as $blacklist) {
        // Process record
    }
} catch (SmsException $e) {
    report($e);
}
```

To find a specific record:

```php id="c4n7m2"
try {
    $response = Sms::findBlacklist('123');
} catch (SmsException $e) {
    report($e);
}
```

---

# AI Quick Reference

### List

```php id="h9x3q6"
Sms::blacklists();
```

### List with pagination

```php id="m2v8r4"
Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
]);
```

### Filter

```php id="p6k1w5"
Sms::blacklists([
    'filters[keywords]' => 'test',
    'filters[subjects]' => 'MyApp',
    'filters[number]' => '+9955XXXXXXXX',
    'filters[dateEnd]' => '31/12/2026',
]);
```

### Find

```php id="x7c4n8"
Sms::findBlacklist('123');
```

### Exception

```php id="q3m9v1"
use Inexphone\Sms\Exceptions\SmsException;
```

### Current endpoints

```text id="a5r2k7"
GET /blacklists
GET /blacklists/{id}
```

### Critical rule

**Blacklist functionality is currently read-only. Do not invent add, delete, remove, or update methods.**

Current documented package version:

```text id="w8p3c6"
insightsge/laravel-inexphone-sms v1.2.0
```
