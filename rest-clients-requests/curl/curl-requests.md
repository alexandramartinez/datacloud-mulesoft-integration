# cURL requests

Copy the scripts to run these in cURL from your Terminal. 

Make sure you replace the `{{host}}` string to your actual host URL and the `{{id}}` string to the bulk job id (i.e., `fc9b6063-fe23-4c5e-86fc-3c7d4c15eb59`).

## POST /schema

```shell
curl '{{host}}/api/schema?openapiversion=3.0.3' \
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
curl '{{host}}/api/query' \
--header 'Content-Type: text/plain' \
--data 'SELECT * FROM MuleSoft_Ingestion_API_runner_p_38447E8E__dll'
```

## POST /insert (streaming)

```shell
curl '{{host}}/api/insert?sourceApiName=MuleSoft_Customers&objectName=customer' \
--header 'Content-Type: application/json' \
--data-raw '[
    {
        "id": 1,
        "first_name": "Alex",
        "last_name": "Martinez",
        "email": "alex@sf.com",
        "street": "415 Mission Street",
        "city": "San Francisco",
        "state": "CA",
        "postalCode": "94105",
        "lat": 37.78916,
        "lng": -122.39521
    },
    {
        "id": 2,
        "first_name": "Akshata",
        "last_name": "Sawant",
        "email": "akshata@sf.com",
        "street": "415 Mission Street",
        "city": "San Francisco",
        "state": "CA",
        "postalCode": "94105",
        "lat": 37.78916,
        "lng": -122.39521
    },
    {
        "id": 3,
        "first_name": "Danielle",
        "last_name": "Larregui",
        "email": "danielle@sf.com",
        "street": "415 Mission Street",
        "city": "San Francisco",
        "state": "CA",
        "postalCode": "94105",
        "lat": 37.78916,
        "lng": -122.39521
    }
]'
```

## DELETE /delete (streaming)

```shell
curl --request DELETE '{{host}}/api/delete?sourceApiName=MuleSoft_Customers&objectName=customer' \
--header 'Content-Type: application/json' \
--data '[
  1,
  3
]'
```

## GET /bulk

```shell
curl '{{host}}/api/bulk'
```

## POST /bulk/upsert (CSV)

```shell
curl '{{host}}/api/bulk/upsert?sourceApiName=MuleSoft_Customers&objectName=customer' \
--header 'Content-Type: text/plain' \
--data-raw 'id,first_name,last_name,email,street,city,state,postalCode,lat,lng
1,Alex,Martinez,alex@sf.com,415 Mission Street,San Francisco,CA,94105,37.78916,-122.39521
2,Akshata,Sawant,akshata@sf.com,415 Mission Street,San Francisco,CA,94105,37.78916,-122.39521
3,Danielle,Larregui,danielle@sf.com,415 Mission Street,San Francisco,CA,94105,37.78916,-122.39521
'
```

## POST /bulk/upsert (JSON)

```shell
curl '{{host}}/api/bulk/upsert?sourceApiName=MuleSoft_Customers&objectName=customer' \
--header 'Content-Type: application/json' \
--data-raw '[
    {
        "id": 1,
        "first_name": "Alex",
        "last_name": "Martinez",
        "email": "alex@sf.com",
        "street": "415 Mission Street",
        "city": "San Francisco",
        "state": "CA",
        "postalCode": "94105",
        "lat": 37.78916,
        "lng": -122.39521
    },
    {
        "id": 2,
        "first_name": "Akshata",
        "last_name": "Sawant",
        "email": "akshata@sf.com",
        "street": "415 Mission Street",
        "city": "San Francisco",
        "state": "CA",
        "postalCode": "94105",
        "lat": 37.78916,
        "lng": -122.39521
    },
    {
        "id": 3,
        "first_name": "Danielle",
        "last_name": "Larregui",
        "email": "danielle@sf.com",
        "street": "415 Mission Street",
        "city": "San Francisco",
        "state": "CA",
        "postalCode": "94105",
        "lat": 37.78916,
        "lng": -122.39521
    }
]'
```

## GET /bulk/{id}

```shell
curl '{{host}}/api/bulk/{{id}}?sourceApiName=MuleSoft_Customers&objectName=customer'
```

## DELETE /bulk/{id}

```shell
curl --request DELETE '{{host}}/api/bulk/{{id}}'
```