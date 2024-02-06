# cURL requests

Copy the scripts to run these in cURL from your Terminal. Make sure you replace the `paste_your_host` string from the `--location` to your actual host URL.

## POST /schema

```shell
curl --location 'paste_your_host/api/schema?openapiversion=3.0.3' \
--header 'Content-Type: application/json' \
--data-raw '{
  "customer": {
    "id": 1,
    "first_name": "Alex",
    "last_name": "Martinez",
    "email": "alex@sf.com",
    "address": {
      "street": "415 Mission Street",
      "city": "San Francisco",
      "state": "CA",
      "postalCode": "94105",
      "geo": {
        "lat": 37.78916,
        "lng": -122.39521
      }
    }
  }
}'
```

## POST /query

```shell
curl --location 'paste_your_host/api/query' \
--header 'Content-Type: text/plain' \
--data 'SELECT *
FROM MuleSoft_Ingestion_API_runner_p_38447E8E__dll'
```

## POST /insert

```shell
curl --location 'paste_your_host/api/insert?sourceApiName=MuleSoft_Ingestion_API&objectName=runner_profiles' \
--header 'Content-Type: application/json' \
--data-raw '[
  {
    "maid": 1,
    "first_name": "FNAME TEST 1",
    "last_name": "LNAME TEST 1",
    "email": "email1@sf.com",
    "gender": "Male",
    "city": "San Francisco",
    "state": "CA",
    "created": "2024-01-31"
  },
  {
    "maid": 2,
    "first_name": "FNAME TEST 2",
    "last_name": "LNAME TEST 2",
    "email": "email2@sf.com",
    "gender": "Female",
    "city": "San Francisco",
    "state": "CA",
    "created": "2024-01-31"
  },
  {
    "maid": 3,
    "first_name": "FNAME TEST 3",
    "last_name": "LNAME TEST 3",
    "email": "email3@sf.com",
    "gender": "Female",
    "city": "San Francisco",
    "state": "CA",
    "created": "2024-01-31"
  },
  {
    "maid": 4,
    "first_name": "FNAME TEST 4",
    "last_name": "LNAME TEST 4",
    "email": "email4@sf.com",
    "gender": "Other",
    "city": "San Francisco",
    "state": "CA",
    "created": "2024-01-31"
  },
  {
    "maid": 5,
    "first_name": "FNAME TEST 5",
    "last_name": "LNAME TEST 5",
    "email": "email5@sf.com",
    "gender": "Male",
    "city": "San Francisco",
    "state": "CA",
    "created": "2024-01-31"
  }
]'
```

## DELETE /delete

```shell
curl --location --request DELETE 'paste_your_host/api/delete?sourceApiName=MuleSoft_Ingestion_API&objectName=runner_profiles' \
--header 'Content-Type: application/json' \
--data '[
  1,
  2,
  3,
  4,
  5
]'
```