# Blacklists API

The `insightsge/laravel-inexphone-sms` package provides read-only access to the InexPhone blacklist API.

Import the facade:

```php id="c7x8w2"
use Inexphone\Sms\Facades\Sms;
```

The package currently supports:

```php id="m8r4k1"
Sms::blacklists()
Sms::findBlacklist()
```

---

## Available Methods

| Method            | HTTP | Endpoint           | Purpose                       |
| ----------------- | ---- | ------------------ | ----------------------------- |
| `blacklists()`    | GET  | `/blacklists`      | Retrieve blacklist records    |
| `findBlacklist()` | GET  | `/blacklists/{id}` | Retrieve one blacklist record |

---

# List Blacklists

Use `Sms::blacklists()` to retrieve blacklist records.

```php id="p3f7q2"
$response = Sms::blacklists();
```

The endpoint is:

```text id="n2w8r4"
GET /blacklists
```

A successful response can contain:

```php id="k5v9s1"
[
    'data' => [...],
    'meta' => [...],
    'message' => 'ok',
]
```

The exact contents of `data` and `meta` depend on the API response.

---

# Pagination

The blacklist API supports pagination parameters.

Supported parameters include:

```text id="x8c4m6"
page
perPage
```

Example:

```php id="z7r2n5"
$response = Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
]);
```

The response may contain pagination metadata similar to:

```php id="q4m9s2"
[
    'meta' => [
        'pagination' => [
            'total' => 0,
            'count' => 0,
            'perPage' => 20,
            'currentPage' => 1,
            'totalPages' => 1,
        ],
    ],
]
```

Do not assume the response always contains exactly these values. They depend on the API data and requested pagination.

---

# Filtering

The API documents the following blacklist filters:

```text id="u6n1k8"
filters[keywords]
filters[subjects]
filters[number]
filters[dateEnd]
```

These can be passed to the package as query parameters.

Example:

```php id="b9t3v7"
$response = Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
    'filters[keywords]' => 'test',
]);
```

---

## Keywords

Filter records by keywords:

```php id="a2p6d4"
$response = Sms::blacklists([
    'filters[keywords]' => 'keyword',
]);
```

Only use filtering behavior documented by the InexPhone API.

---

## Subjects

Filter by subject:

```php id="e5q8h3"
$response = Sms::blacklists([
    'filters[subjects]' => 'MyApp',
]);
```

---

## Phone Number

Filter by phone number:

```php id="r1c6y9"
$response = Sms::blacklists([
    'filters[number]' => '+9955XXXXXXXX',
]);
```

---

## Date End

The API documents `dateEnd` as a supported filter.

The expected date format is:

```text id="w3k7p2"
d/m/Y
```

Example:

```php id="f8s4m1"
$response = Sms::blacklists([
    'filters[dateEnd]' => '31/12/2026',
]);
```

Do not use a different date format unless the API documentation or installed package explicitly supports it.

---

# Combining Filters

Multiple documented filters can be used together.

Example:

```php id="v2n6q8"
$response = Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
    'filters[keywords]' => 'test',
    'filters[number]' => '+9955XXXXXXXX',
    'filters[dateEnd]' => '31/12/2026',
]);
```

Only include filters that are required by the application.

---

# Find a Blacklist Entry

Use `Sms::findBlacklist()` when the ID of a blacklist record is known.

```php id="j7p3d9"
$response = Sms::findBlacklist('123');
```

The endpoint is:

```text id="s5h2k8"
GET /blacklists/{id}
```

The ID should be passed as a string:

```php id="c1m6v4"
$response = Sms::findBlacklist('123');
```

Do not assume that the ID is a UUID unless the API specifically defines it that way.

---

# Empty Blacklist

An account may have no blacklist records.

For example, the API can return:

```php id="n9q4w2"
[
    'data' => [],
    'meta' => [
        'pagination' => [
            'total' => 0,
            'count' => 0,
            'perPage' => 200,
            'currentPage' => 1,
            'totalPages' => 1,
            'links' => [
                'next' => null,
                'previous' => null,
            ],
        ],
    ],
    'message' => 'ok',
]
```

An empty `data` array is a valid response.

If `findBlacklist()` is called with an ID that does not exist, the API may return an error. This does not necessarily indicate that the package method itself is broken.

---

# Important: Read-Only Blacklist Support

The current documented InexPhone API exposes blacklist endpoints for reading data:

```text id="m4q8t1"
GET /blacklists
GET /blacklists/{id}
```

There are no documented package methods for creating or deleting blacklist records.

Therefore, do not invent methods such as:

```php id="z6p2r5"
// Not supported/documented
Sms::addBlacklist();
Sms::deleteBlacklist();
Sms::removeBlacklist();
Sms::updateBlacklist();
```

If InexPhone adds these API operations in the future, the package documentation and implementation should be updated before AI assistants recommend them.

---

# `ignoreBlacklist` Is Different

The `ignoreBlacklist` parameter available on `Sms::send()` controls blacklist behavior for that SMS request.

Example:

```php id="h3k8v1"
$response = Sms::send(
    '+9955XXXXXXXX',
    'MyApp',
    'Your message',
    true,
);
```

This does **not** add the phone number to a blacklist.

It also does **not** remove a phone number from a blacklist.

It is a sending option, not a blacklist-management operation.

---

# Error Handling

Blacklist API failures use the package's `SmsException`.

```php id="s8m2q6"
use Inexphone\Sms\Exceptions\SmsException;

try {
    $response = Sms::blacklists();
} catch (SmsException $e) {
    // Handle API/package error
}
```

The same applies to an individual blacklist lookup:

```php id="t4c9p7"
try {
    $response = Sms::findBlacklist('123');
} catch (SmsException $e) {
    // Handle API/package error
}
```

Follow the Laravel application's existing error-handling conventions.

Do not expose the InexPhone API token in error responses or logs.

---

# Testing

Blacklist functionality should be tested without making real API requests.

Use Laravel HTTP fakes:

```php id="y5n1r8"
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

```php id="q2v7m4"
$response = Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
]);

$this->assertIsArray($response);
```

Tests should verify:

* Correct HTTP method.
* Correct endpoint.
* Query parameters.
* Successful response handling.
* API error handling.

For `findBlacklist()`:

```php id="k8s3w6"
$response = Sms::findBlacklist('123');
```

Verify that the request is made to:

```text id="b6r1n9"
/blacklists/123
```

---

# Laravel Service Example

For reusable application logic, blacklist operations can be wrapped in an application service.

```php id="d4m8q2"
namespace App\Services;

use Inexphone\Sms\Facades\Sms;

class BlacklistService
{
    public function all(array $filters = []): array
    {
        return Sms::blacklists($filters);
    }

    public function find(string $id): array
    {
        return Sms::findBlacklist($id);
    }
}
```

This allows controllers and other application components to work with a dedicated application service instead of containing API-specific logic themselves.

---

# AI Assistant Rules

When generating blacklist-related code:

### Use the package

```php id="e7n2c5"
use Inexphone\Sms\Facades\Sms;
```

### List records

```php id="r3k9m1"
Sms::blacklists();
```

### List with pagination

```php id="w6p2h8"
Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
]);
```

### Use documented filters

```text id="a8q4v6"
filters[keywords]
filters[subjects]
filters[number]
filters[dateEnd]
```

### Date format

```text id="u1m5s7"
d/m/Y
```

### Find one record

```php id="n4c8r2"
Sms::findBlacklist('123');
```

### Do not invent management operations

The currently documented API does not provide:

```text id="g9t3k6"
add blacklist
delete blacklist
remove blacklist
update blacklist
```

### Do not confuse blacklist lookup with SMS sending

`Sms::blacklists()` and `Sms::findBlacklist()` read blacklist data.

`Sms::send()` has an `ignoreBlacklist` option that affects sending behavior.

They are separate concepts.

---

# Quick Reference

```php id="p7v2d5"
use Inexphone\Sms\Facades\Sms;

// List blacklists
$response = Sms::blacklists();

// List with pagination
$response = Sms::blacklists([
    'page' => 1,
    'perPage' => 20,
]);

// List with filters
$response = Sms::blacklists([
    'filters[keywords]' => 'test',
    'filters[number]' => '+9955XXXXXXXX',
    'filters[dateEnd]' => '31/12/2026',
]);

// Find a blacklist record
$response = Sms::findBlacklist('123');
```

The current package version documented here is:

```text id="c2w8n4"
insightsge/laravel-inexphone-sms v1.2.0
```

When the installed package version differs, inspect the actual package source and documentation before assuming that the same blacklist functionality is available.
