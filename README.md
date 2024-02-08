# Data Cloud integration built in MuleSoft

This is a Mule 4 app created to communicate with your Data Cloud. You can query, insert, or delete records using this integration; as well as flatten a YAML schema for your Salesforce settings.

![](/images/cover-ms-sf-dc.png)

What's in this repo:
1. [Data Cloud Integration API/](/Data%20Cloud%20Integration%20API/) ~ Contains the files I used to publish the **API Specification** that is publicly available in my Exchange Portal [here](https://anypoint.mulesoft.com/exchange/portals/mulesoft-36559/b903eebf-16e9-46c5-8992-bffd66c2306c/data-cloud-integration-api/).
2. [data-cloud-integration-impl/](/data-cloud-integration-impl/) ~ Contains the Mule project I created for you to call Data Cloud. This is the code used to generate the JAR file that you will use to deploy the Mule app in Anypoint Platform. You can download the latest JAR from the `releases` section of this repo or by clicking [here](https://github.com/alexandramartinez/datacloud-mulesoft-integration/releases/download/1.0.0/data-cloud-integration-impl-1.0.0-mule-application.jar).
3. [rest-clients-requests](/rest-clients-requests/) ~ Contains the Postman/Thunder Client collections to run the requests to call your integration. There is also a .md file in the curl folder for you to copy/paste cURL commands if that's easier for you.
4. [example-schema.yaml](/example-schema.yaml) ~ Example YAML file that you can use if you don't have a YAML schema to create the Ingestion API/Data Stream objects in Data Cloud.

---

## Table of Contents

- [Data Cloud integration built in MuleSoft](#data-cloud-integration-built-in-mulesoft)
  - [Table of Contents](#table-of-contents)
  - [Data Cloud configuration](#data-cloud-configuration)
    - [Connected App settings](#connected-app-settings)
    - [OAuth settings](#oauth-settings)
    - [Ingestion API settings](#ingestion-api-settings)
    - [Data Stream settings](#data-stream-settings)
  - [Deploy your own Mule app](#deploy-your-own-mule-app)
  - [Call your integration](#call-your-integration)
    - [POST /schema](#post-schema)
    - [POST /query](#post-query)
    - [POST /insert](#post-insert)
    - [DELETE /delete](#delete-delete)
  - [Create your own - step by step](#create-your-own---step-by-step)

---

</br>
<p align="center"><img height="100" src="/images/salesforce.png"></p>
</br>

## Data Cloud configuration

- Log in to [Salesforce](login.salesforce.com)

> [!IMPORTANT]
> These credentials will be used as `salesforce.username` and `salesforce.password` in your Mule application's settings in Anypoint Platform (the properties in Runtime Manager).

### Connected App settings

- Enter **Setup**
- Search for **App Manager**
- Click **New Connected App**
- Fill the following fields

  | field | value
  | - | - 
  | Connected App Name | `MuleSoft Integration Connected App`
  | API Name | `MuleSoft_Integration_Connected_App`
  | Contact Email | your email
  | Enable OAuth Settings | ✅
  | Callback URL | `https://login.salesforce.com/services/oauth2/callback`
  | Selected OAuth Scopes | - Access Interaction API resources (cdp_api)<br/>- Access all Data Cloud API resources (cdp_api)<br/>- Manage Data Cloud Calculated Insight data (cdp_calculated_insight_api)<br/>- Manage Data Cloud Identity Resolution (cdp_identityresolution_api)<br/>- Manage Data Cloud Ingestion API data (cdp_ingest_api)<br/>- Manage Data Cloud profile data (cdp_profile_api)<br/>- Manage user data via Web browsers (web)<br/>- Perform ANSI SQL queries on Data Cloud data (cdp_query_api)<br/>- Perform segmentation on Data Cloud data (cdp_segment_api)
  | Enable Client Credentials Flow | ✅

- Click **Save** and **Continue**
- In the created Connected App detail page, click on **Manage Consumer Details**
- Enter the code sent to your email
- Click on **Generate**
- Copy the newly generated **Staged Consumer Key** and **Staged Consumer Secret** - you will use these credentials for your Mule integration
- Click on **Apply** and **Apply** again - note how your staged consumer details are now the main consumer details

> [!IMPORTANT]
> These credentials will be used as `cdp.consumer.key` and `cdp.consumer.secret` in your Mule application's settings in Anypoint Platform (the properties in Runtime Manager).

### OAuth settings

- Enter **Setup** (top-right corner)
- Search for **OAuth and OpenID Connect Settings**
- Make sure the **Allow OAuth Username-Password Flows** option is **On**

### Ingestion API settings

If you already have an Ingestion API **with a YAML schema**, just take note of the name of the Ingestion API you created. Otherwise, follow the next steps to create one.

- Enter **Setup** (top-right corner)
- Search for **Ingestion API**
- Click on **New**
- Add a Connector Name like **MuleSoft Ingestion API**

> [!IMPORTANT]
> This name will be used as the `sourceApiName` query parameter to call the Mule application. In this case, the correct value would be `MuleSoft_Ingestion_API`.

- Click on **Save**
- If you already have a YAML schema, upload it here and take note of the name of the object(s). If not, upload [this example schema](/example-schema.yaml) (the name of the objects are `runner_profiles` and `exercises`)
- Click on **Save**

> [!IMPORTANT]
> Whichever object you wish to insert/delete records to, will be used as the `objectName` query parameter to call the Mule application. In this case, the correct value(s) would be `runner_profiles` or `exercises`.

### Data Stream settings

- Exit **Setup** / go back to the main page
- Search for **Data Cloud**
- Select the **Data Streams** tab from the top
- Click **New**
- Select **Ingestion API** and click **Next**
- Select your **MuleSoft Ingestion API** from the dropdown
- Select all the objects and click on **Next**
- In the `exercises` configuration, select Category **Profile** and Primary Key **maid**
- In the `runner_profiles` configuration, select Category **Profile** and Primary Key **maid**
- Click **Next**
- Select the **default** Data Space and click **Deploy**

> [!NOTE]
> In this Data Stream, we selected `maid` as the Primary Key. This is the field we're going to need per record to delete them using the Mule app.

---

</br>
<p align="center"><img height="100" src="/images/mulesoft.png"></p>
</br>

## Deploy your own Mule app

Before starting, make sure you have all the Data Cloud settings ready.

> [!NOTE]
> You will need to have an [Anypoint Platform](https://anypoint.mulesoft.com) account. It will expire in 30 days but you can create a new one using the same details to register, just making sure to change the username to a different one.

- Download the Mule app's JAR file [here](https://github.com/alexandramartinez/datacloud-mulesoft-integration/releases/download/1.0.0/data-cloud-integration-impl-1.0.0-mule-application.jar).
- Take note of the following credentials. You will need them for the Mule app.
  - `salesforce.username` - The username you use to log in to Salesforce at login.salesforce.com
  - `salesforce.password` - The password you use to log in to Salesforce at login.salesforce.com
  - `cdp.consumer.key` - The Consumer Key for the Connected App you created in Salesforce (see [Connected App settings](#connected-app-settings))
  - `cdp.consumer.secret` - The Consumer Secret for the Connected App you created in Salesforce (see [Connected App settings](#connected-app-settings)
- Sign in to your [Anypoint Platform](https://anypoint.mulesoft.com) account.
- In Anypoint Platform, navigate to [Runtime Manager](https://anypoint.mulesoft.com/cloudhub).
- Click on **Deploy Application**.
- Add any **application name**. For example, `data-cloud-integration`
  - We will be deploying to CloudHub 2.0, but if you're deploying to CloudHub 1.0, the application name has to be unique across all applications worldwide. If the application name is not available, you can add your username at the end to make it unique. For example, `data-cloud-integration-amartinez`.
- Make sure the **deployment target** is set to CloudHub 2.0. It should be selected by default.
- Select **Choose file > Upload File** under **Application File**
- Select the JAR file you downloaded at the beginning, or get it from this repo's [releases](https://github.com/alexandramartinez/datacloud-mulesoft-integration/releases).
- Check the following values are correctly set under **Runtime**

  | field | value |
  | - | - |
  | Release Channel | None
  | Runtime Version | 4.4.0 
  | Java Version | Java 8
  | Replica Count | 1
  | Replica size | 0.1 vCores
  | Deployment model | Rolling update
  | Run in Runtime Cluster Mode | ◻️ (unchecked)
  | Use Object Store V2 | ◻️ (unchecked)

- Leave everything unchecked under the **Ingress** tab.
- Add your credentials under **Properties**. 
  - You can add them one by one using the **Table view**
  - Or upload the following text using the **Text view** and replace your values

  ```properties
  salesforce.username=your_username
  salesforce.password=your_password
  cdp.consumer.key=your_key
  cdp.consumer.secret=your_secret
  ```

- Click on **Protect** next to each value from the **Table view** to hide your properties (only available in CloudHub 2.0).
- Click on **Deploy Application**. Wait for a few minutes until your application has been deployed 🟢 (green circle).
  - If you see a 🔴 red circle right after clicking **Deploy**, wait more time. It doesn't mean the app has failed, it means it's still deploying.
- Once the app has been deployed, click on **Dashboard** tab at the left side of the screen.
- Copy the URL. This is your host URL. It should be something like `https://data-cloud-integration-abcdef123.a1b2c3-1.usa-e2.cloudhub.io/`

> [!CAUTION]
> **DO NOT** share this URL publicly. Anyone with this URL will be able to access your Data Cloud API. 
> 
> If you wish to create a new URL, you will have to  delete this app from the **Settings** tab (where it says **Stop**) and create a new one following the same steps.
>
> You can also **Stop** and **Start** your app only when you are using it to avoid unwanted requests.

---

</br>
<p align="center"><img height="100" src="/images/postman.svg"></p>
</br>

## Call your integration

Use the REST Client you are more familiar with to call the integration. For example, [cURL](https://curl.se/), [Postman](https://www.postman.com/), [Thunder Client for VS Code](https://marketplace.visualstudio.com/items?itemName=rangav.vscode-thunder-client), and so on.

You can find [here](/rest-clients-requests/) the requests/collections for cURL, Postman, and Thunder Client. If you're already familiar with this process, you only have to add your `host` variable to Postman/Thunder Client or add it to the cURL requests.

If you are unfamiliar or unsure of what are the steps, let's go through the steps using **Postman**. You can download it or create a free account and do the steps online [here](https://www.postman.com/).

- Once you're in Postman, whether it's online or in the app, go to your workspace
- Make sure you're inside the **Collections** tab and click the **Import** button
- Download the Postman collection file (JSON format) from [this folder](/rest-clients-requests/postman/) and add it to the Postman window to import it
- Once you see the Data Cloud Integration collection in Postman, go to the **Environments** tab
- You can either create a global variable by clicking on **Globals** or create a new environment by clicking on **New**
  - If you create a new environment, make sure you select it from the dropdown in the top-right of the screen
- Add the variable `host` and paste your CloudHub URL in the **Current value** field (should be something like `https://data-cloud-integration-abcdef123.a1b2c3-1.usa-e2.cloudhub.io`)
- Save the variable by clicking on the **Save** button
- Go back to the **Collections** tab and now you can run all the requests!

If you're unfamiliar with Postman, you can find the query parameters in the **Params** tab of each request and the request body in the **Body** tab. Once you've verified everything is correctly set up for each request, click on the **Send** button.

### POST /schema

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

> [!NOTE]
> Make sure you set the `openapiversion` query parameter to set the version. Otherwise, the default of `3.0.3` will be outputted.

### POST /query

Send your SOQL query in the body of the request on a `text/plain` format.

For example:

```sql
SELECT * 
FROM MuleSoft_Ingestion_API_runner_p_38447E8E__dll 
LIMIT 100
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

### POST /insert

Make sure you add the following query parameters to let Data Cloud know more information about where you want to insert new records:

- `sourceApiName` i.e., `MuleSoft_Ingestion_API`
- `objectName` i.e., `runner_profiles`

Next, in the body of the request, make sure to use a JSON Array. Each Object inside this Array is a new record. For example:

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

> [!IMPORTANT]
> Streaming in Data Cloud in limited to max 200 records per insertion.

If everything runs smoothly, you will receive a `200 - OK` successful response.

> [!NOTE]
> It may take a few minutes for your data to be updated in Data Cloud. You can manually check the records in Data Cloud or wait to attempt the `/query` from your MuleSoft API.

### DELETE /delete

Make sure you add the following query parameters to let Data Cloud know more information of where you want to insert new records:

- `sourceApiName` i.e., `MuleSoft_Ingestion_API`
- `objectName` i.e., `runner_profiles`

Next, in the body of the request, make sure to use a JSON Array. Each Object inside this Array is the ID of the record to delete. For example:

```json
[
  1
]
```

> [!IMPORTANT]
> Streaming in Data Cloud in limited to max 200 records per deletion.

If everything runs smoothly, you will receive a `200 - OK` successful response.

> [!NOTE]
> It may take a few minutes for your data to be updated in Data Cloud. You can manually check the records in Data Cloud or wait to attempt the `/query` from your MuleSoft API.

---

</br>
<p align="center"><img height="250" src="/images/max-terminal.gif"></p>
</br>

## Create your own - step by step

Follow [this guide](/step-by-step.md) if you want to create your own Mule integration from scratch!