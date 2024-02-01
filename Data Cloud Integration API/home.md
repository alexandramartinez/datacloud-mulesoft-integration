You can use this API Specification to implement your own Data Cloud Integration with MuleSoft.

There are four resources in this API spec:

1. `/query`
2. `/schema`
3. `/insert`
4. `/delete`

Let's go through each of them in more detail.

# POST /schema

With this endpoint, you can send a JSON object to be transformed into the OpenAPI YAML schema. This is needed to create your Ingestion API and Data Stream in Data Cloud.

Because the Ingestion API doesn't accept nested objects on the schema, this endpoint will transform your multi-level object into the single-level needed for Data Cloud.

For example, the following input payload:

```json
{
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
}
```

would be flattened and transformed into the following output:

```json
{
  "customer": {
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
  }
}
```

then, based on this new input, you will receive the YAML schema like the following:

> ⚠️ Important
> Take note of the object(s) name(s) from this YAML schema because you will use them for the insertion and deletion. For example, in the following YAML schema, the object name is customer.

```yaml
openapi: 3.0.3
components:
  schemas:
    customer:
      type: object
      properties:
        id:
          type: number
        first_name:
          type: string
        last_name:
          type: string
        email:
          type: string
        street:
          type: string
        city:
          type: string
        state:
          type: string
        postalCode:
          type: string
        lat:
          type: number
        lng:
          type: number
```

> ℹ️ Note
> Make sure you set the `openapiversion` query parameter to set the version. Otherwise, the default of `3.0.3` will be outputted.

# POST /query

Send your SOQL query in the body of the request on a `text/plain` format.

For example:

```sql
SELECT * FROM MuleSoft_Ingestion_API_runner_p_38447E8E__dll LIMIT 100
```

You will receive a JSON response with the result from Data Cloud.

For example, from the previous query, you'd receive a JSON Array with the results of the `SELECT`:

```json
[
  {
    "DataSourceObject__c": "MuleSoft_Ingestion_API_runner_profiles_38447E8E",
    "DataSource__c": "MuleSoft_Ingestion_API_996db928_2078_4e3a_9c67_1c80b32790aa",
    "city__c": "Toronto",
    "created__c": "2017-07-21",
    "email__c": "alex@sf.com",
    "first_name__c": "Alex",
    "gender__c": "NB",
    "last_name__c": "Martinez",
    "maid__c": 1.000000000000000000,
    "state__c": "ON"
  }
]
```

# POST /insert

Make sure you add the following query parameters to let Data Cloud know more information of where you want to insert new records:

- `sourceApiName` i.e., `MuleSoft_Ingestion_API`
- `objectName` i.e., `runner_profiles`

Next, in the body of the request, make sure to use a JSON Array. Each Object inside this Array is a new record.

For example:

```json
[
  {
    "maid": 1,
    "first_name": "Alex",
    "last_name": "Martinez",
    "email": "alex@sf.com",
    "gender": "NB",
    "city": "Toronto",
    "state": "ON",
    "created": "2017-07-21"
  }
]
```

If everything ran smoothly, you will receive a `200 - OK` successful response.

> ℹ️ Note
> It may take a few minutes for your data to be updated in Data Cloud. You can manually check the records in Data Cloud or wait to attempt the `/query` from your MuleSoft API.

# DELETE /delete

Make sure you add the following query parameters to let Data Cloud know more information of where you want to insert new records:

- `sourceApiName` i.e., `MuleSoft_Ingestion_API`
- `objectName` i.e., `runner_profiles`

Next, in the body of the request, make sure to use a JSON Array. Each Object inside this Array is the ID of the record to delete.

For example:

```json
[
  1
]
```

If everything ran smoothly, you will receive a `200 - OK` successful response.

> ℹ️ Note
> It may take a few minutes for your data to be updated in Data Cloud. You can manually check the records in Data Cloud or wait to attempt the `/query` from your MuleSoft API.
