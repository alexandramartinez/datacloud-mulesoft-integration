# Data Cloud integration built in MuleSoft

Temporary (or not?) place for the Data Cloud integration built using MuleSoft.

There are two main folders/projects inside this repo:
1. [Data Cloud Integration API/](/Data%20Cloud%20Integration%20API/) ~ Contains the files I used to publish the **API Specification** that is publicly available in my Exchange Portal [here](https://anypoint.mulesoft.com/exchange/portals/mulesoft-36559/b903eebf-16e9-46c5-8992-bffd66c2306c/data-cloud-integration-api/).
2. [data-cloud-integration-impl/](/data-cloud-integration-impl/) ~ Contains the Mule project I created for you to call Data Cloud. This is the code used to generate the JAR file that you will use to deploy the Mule app in Anypoint Platform. You can download the latest JAR from the `releases` section of this repo or by clicking [here](https://github.com/alexandramartinez/datacloud-mulesoft-integration/releases/download/1.0.0/data-cloud-integration-impl-1.0.0-mule-application.jar).

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
  - [Create your own - step by step](#create-your-own---step-by-step)
    - [1. Create the API Specification and publish it to Exchange](#1-create-the-api-specification-and-publish-it-to-exchange)
    - [2. Implement the API in Anypoint Code Builder Desktop](#2-implement-the-api-in-anypoint-code-builder-desktop)
      - [global.xml](#globalxml)
      - [implementation.xml](#implementationxml)
        - [schema](#schema)
        - [query](#query)
        - [insert](#insert)
        - [delete](#delete)
      - [data-cloud-integration-impl.xml](#data-cloud-integration-implxml)
      - [Properties file](#properties-file)
      - [mule-artifact.json](#mule-artifactjson)

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

## Deploy your own Mule app

Before starting, make sure you have all the Data Cloud settings ready.

- Download the Mule app's JAR file [here](https://github.com/alexandramartinez/datacloud-mulesoft-integration/releases/download/1.0.0/data-cloud-integration-impl-1.0.0-mule-application.jar).
- Take note of the following credentials. You will need them for the Mule app.
  - `salesforce.username` - The username you use to log in to Salesforce at login.salesforce.com
  - `salesforce.password` - The password you use to log in to Salesforce at login.salesforce.com
  - `cdp.consumer.key` - The Consumer Key for the Connected App you created in Salesforce
  - `cdp.consumer.secret` - The Consumer Secret for the Connected App you created in Salesforce
- Create a free trial account in [Anypoint Platform](https://anypoint.mulesoft.com). It will expire in 30 days but you can create a new one using the same details to register, just making sure to change the username to a different one.
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
  | Use Edge Release Channel | ◻️ (unchecked)
  | Runtime Version | 4.4.0 
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

## Call your integration

tbd

## Create your own - step by step

There is no need for you to go through these steps if you only want to make use of the integration. This is only if you want to learn how to create this whole integration step by step. From designing the API specification to implementing the Mule project.

### 1. Create the API Specification and publish it to Exchange

> [!NOTE]
> You will need to have an [Anypoint Platform](https://anypoint.mulesoft.com) account to publish the API Specification to Exchange. It will expire in 30 days but you can create a new one using the same details to register, just making sure to change the username to a different one.

<details>
<summary>a) From Anypoint Code Builder Desktop</summary>
<br/>

- In ACB Desktop, click on **Design an API**
- Under the **API Specification** tab, add a Project Name, like **Data Cloud Integration API**
- Leave the defaults (make sure to use RAML 1.0) and click **Create Project**
- Paste the contents of [this file](/Data%20Cloud%20Integration%20API/data-cloud-integration-api.raml) into the generated RAML file and save it
- Open the Command Palette (cmd+shift+P) and search for **MuleSoft: API Console**
- Make sure the design looks correct before continuing
- Open the **Source Control** tab from the left and **commit & push** the changes. To do this:
  - Add a message in the input
  - Stage your changes by clicking on the **+** button next to the changes
  - Click **Commit**
  - Click **Sync Changes** to push them to Design Center
- Your new API Specification should now appear in Design Center (in [Anypoint Platform](https://anypoint.mulesoft.com/))
- Open the Command Palette once more and search for **MuleSoft: Publish API Specification to Exchange**
- Leave the default project name and press **Enter**
- Leave the default artifact ID and press **Enter**
- Leave the default asset version and press **Enter**
- Leave the default API version and press **Enter**

</details>

<br/>

<details>
<summary>b) From Design Center</summary>

<br/>

- Sign in to your [Anypoint Platform](https://anypoint.mulesoft.com) account
- Head to [Design Center](https://anypoint.mulesoft.com/designcenter)
- Click **Create** > **New API Specification**
- Add a Project Name, like **Data Cloud Integration API**
- Leave the defaults (make sure to use RAML 1.0) and click **Create Project**
- Paste the contents of [this file](/Data%20Cloud%20Integration%20API/data-cloud-integration-api.raml) into the generated RAML file and save it
- Click on the **Documentation** button at the right of the screen if the API Console is not already visible
- Make sure the design looks correct before continuing
- Click on the **Publish** button at the top-right
- Leave the defaults and click on **Publish to Exchange**

</details>

### 2. Implement the API in Anypoint Code Builder Desktop

- Implement the published API Specification:
  - a) If you published the API Specification from ACB, you’ll see a new prompt asking to implement the API. Select **Yes**
  - b) If you missed this prompt or you published the API Specification from Design Center directly, open the Command Palette and select **MuleSoft: Implement this local API**
  - c) Alternatively, you can go back to ACB’s home page, select **Implement an API** and look for the API you just published to Exchange.
- Choose a project name, like **Data Cloud Integration Impl** and press **Enter**
- Select your target folder and continue
- Under `src/main/mule`, create two new files:
  - `global.xml`
  - `implementation.xml`

> [!NOTE]
> You can base on the [data-cloud-integration-impl/](/data-cloud-integration-impl/) folder to compare your code.

#### global.xml

After doing the following steps, your `global.xml` file should look like [this one](/data-cloud-integration-impl/src/main/mule/global.xml)

- Inside the `global.xml` file, select **build a sub flow** to be able to see all the `<mule>` namespaces and schemas
- Click on the **+** button in the middle of the canvas (inside the sub-flow)
- Click the **Search in Exchange** button
- Search for **Salesforce Data Cloud Connector - Mule 4** and select it
- Select the **Query** connector
- A new dependency should have been added to your `pom.xml`:

  ```xml
  <dependency>
      <groupId>com.mulesoft.connectors</groupId>
      <artifactId>mule4-sdc-connector</artifactId>
      <version>1.0.3</version>
      <classifier>mule-plugin</classifier>
  </dependency>
  ```

- Remove the `sub-flow` and the `sdc:query` configs from the XML, leaving only the `<mule>` tags, including the schemas
- Add the following `sdc-config` inside the `<mule></mule>` tags

  ```xml
  <sdc:sdc-config name="Salesforce_CDP_Sdc_config">
      <sdc:oauth-user-pass-connection clientId="${cdp.consumer.key}" clientSecret="${cdp.consumer.secret}" username="${salesforce.username}" password="${salesforce.password}" audienceUrl="${salesforce.url}" />
  </sdc:sdc-config>
  ```

- Add the following `configuration-properties` after that

  ```xml
  <configuration-properties file="props.yaml" doc:name="Configuration properties" />
  ```

- Open the XML that was initially created with the project. It should be something like `data-cloud-integration-impl`, depending on how you named your project
- Cut the `http:listener-config` and `apikit:config` to your `global.xml` file
- Replace the `http:listener-connection`'s **host** and **port** with the following

  ```xml
  <http:listener-connection host="${http.listener.host}" port="${http.listener.port}" />
  ```

- Your final `global.xml` file should look like [this one](/data-cloud-integration-impl/src/main/mule/global.xml)
- Save the file

#### implementation.xml

After doing the following steps, your `implementation.xml` file should look like [this one](/data-cloud-integration-impl/src/main/mule/implementation.xml)

##### schema

- Inside the `implementation.xml` file, select **build a sub flow**
- Rename the sub-flow to **implementation-schema**
- Add the following Transform Message component inside the sub-flow

  ```xml
  <ee:transform doc:name="flatten and transform to yaml schema">
      <ee:message>
          <ee:set-payload resource="dw/schema.dwl" />
      </ee:message>
  </ee:transform>
  ```

- Create a new folder under `src/main/resources` called `dw`
- Inside this folder, create a new file called `schema.dwl`
- Paste the contents of [this file](/data-cloud-integration-impl/src/main/resources/dw/schema.dwl)
- Save the file

##### query

- Inside the `implementation.xml` file, click the **Add** button located at the top left of the canvas
- Select **Sub flow**
- Rename this sub-flow to `implementation-query`
- Paste the following Transform Message

  ```xml
  <ee:transform doc:name="text to json">
      <ee:message>
          <ee:set-payload resource="dw/text-to-json.dwl" />
      </ee:message>
  </ee:transform>
  ```

- Create a new `text-to-json.dwl` file under `src/main/resources/dw`
- Paste the contents of [this file](/data-cloud-integration-impl/src/main/resources/dw/text-to-json.dwl)
- Save the file
- Click on the **+** button under the Transform Message component in the canvas
- Select **Connectors** > **Salesforce CDP** > **Query**
- Add the following inside the quotes in `config-ref`: `Salesforce_CDP_Sdc_config`
- After this, but still inside the sub-flow, add the following Transform Message

  ```xml
  <ee:transform doc:name="extract data">
      <ee:message>
          <ee:set-payload>
              <![CDATA[%dw 2.0
  output application/json
  ---
  payload.data]]>
          </ee:set-payload>
      </ee:message>
  </ee:transform>
  ```

- Save the file

##### insert

- Inside the `implementation.xml` file, click the **Add** button located at the top left of the canvas
- Select **Sub flow**
- Rename this sub-flow to `implementation-insert`
- Paste the following Transform Message

  ```xml
  <ee:transform doc:name="add data">
      <ee:message>
          <ee:set-payload>
              <![CDATA[%dw 2.0
  output application/json
  ---
  {
      data: payload
  }]]>
          </ee:set-payload>
      </ee:message>
  </ee:transform>
  ```

- Click on the **+** button under the Transform Message component in the canvas
- Select **Connectors** > **Salesforce CDP** > **Streaming - Insert Objects**
- Replace the added data with the following (inside the quotes)

  | field | value |
  | - | - |
  | `config-ref` | `Salesforce_CDP_Sdc_config` |
  | `sourceNameUriParam` | `#[attributes.queryParams.sourceApiName]` |
  | `objectNameUriParam` | `#[attributes.queryParams.objectName]` |
  | `doc:name` | `Insert` |

- Save the file

##### delete

- Inside the `implementation.xml` file, click the **Add** button located at the top left of the canvas
- Select **Sub flow**
- Rename this sub-flow to `implementation-delete`
- Click on the **+** button from the canvas
- Select **Connectors** > **Salesforce CDP** > **Streaming - Delete Objects**
- Replace the added data with the following (inside the quotes)

  | field | value |
  | - | - |
  | `config-ref` | `Salesforce_CDP_Sdc_config` |
  | `sourceNameUriParam` | `#[attributes.queryParams.sourceApiName]` |
  | `objectNameUriParam` | `#[attributes.queryParams.objectName]` |
  | `doc:name` | `Delete` |
  | `idsQueryParams` | `#[output application/java --- payload]` |

- Remove the following line if it was added to the configuration

  ```xml
  <sdc:ids-query-params />
  ```

- Save the file
- Your final `implementation.xml` file should look like [this one](/data-cloud-integration-impl/src/main/mule/implementation.xml)

#### data-cloud-integration-impl.xml

After doing the following steps, your `data-cloud-integration-impl.xml` file should look like [this one](/data-cloud-integration-impl/src/main/mule/data-cloud-integration-impl.xml)

- Open your `data-cloud-integration-impl.xml` (the name of this file might be different if you selected a different project name)
- Click on the **Flow List** at the top left of the canvas
- Select the flow that says `\schema`
- Remove the Transform Message component and add a flow reference to `implementation-schema`
- Repeat this process for `\query`, `\insert`, and `\delete` to end up with something like the following

  ```xml
  <flow name="delete:\delete:application\json:data-cloud-integration-api-config">
      <flow-ref name="implementation-delete" />
  </flow>
  <flow name="post:\insert:application\json:data-cloud-integration-api-config">
      <flow-ref name="implementation-insert" />
  </flow>
  <flow name="post:\query:text\plain:data-cloud-integration-api-config">
      <flow-ref name="implementation-query" />
  </flow>
  <flow name="post:\schema:application\json:data-cloud-integration-api-config">
      <flow-ref name="implementation-schema" />
  </flow>
  ```

- From the XML view, you can remove the API Console flow to save space
- Save the file
- Your final `data-cloud-integration-impl.xml` file should look like [this one](/data-cloud-integration-impl/src/main/mule/data-cloud-integration-impl.xml)

#### Properties file

- Create a new file under `src/main/resources` called `props.yaml` - note that the name of this file has to match the one in `global.xml`
- Paste the contents of [this file](/data-cloud-integration-impl/src/main/resources/props.yaml)

> [!NOTE]
> We are not setting up secured/encrypted properties in this project automatically because it is intended for people to use the project in CloudHub and not in local. To set up secured properties, do the following:

<details>
<summary>Optional step: setting up secured properties</summary>

<br/>

- Create a new file under `src/main/resources` called `props.secure.yaml`
- Paste the contents of [this file](/data-cloud-integration-impl/src/main/resources/props.secure.yaml)
- Remove these same properties from the `props.yaml` file so they are not repeated. You should end up with this:

  ```yaml
  salesforce:
    url: "https://login.salesforce.com/"
  
  http:
    listener:
      host: "0.0.0.0"
      port: "8081"
  ```

- Encrypt the credentials using the secure properties tool. See [Encrypt Properties Using the Secure Properties Tool](https://docs.mulesoft.com/mule-runtime/latest/secure-configuration-properties#secure_props_tool) for more info. Make sure you use the **Blowfish** algorithm and take note of the secure key you use to encrypt them because you'll use it in the next step
- If you want to run the application locally with your encrypted credentials in the `props.secure.yaml` file, make sure to add your `secure.key` to the Command-line arguments in ACB. See [How to add JVM/Command-line arguments to the Mule 4 Runtime in Anypoint Code Builder](https://www.prostdev.com/post/how-to-add-jvm-command-line-arguments-to-the-mule-4-runtime-in-anypoint-code-builder-acb) for a detailed tutorial
- Set up the `secure-properties:config` in your `global.xml` file and make sure you pass the `secure::` prefix to the encrypted properties in the `Salesforce_CDP_Sdc_config` configuration. For more clarification, see the comments in [this file](/data-cloud-integration-impl/src/main/mule/global.xml)

</details>

#### mule-artifact.json

- Open your `mule-artifact.json` file located in the project's root folder
- Paste the contents of [this file](/data-cloud-integration-impl/mule-artifact.json) - make sure to not override the `minMuleVersion`, only add the `secureProperties`
- Now those properties will appear hidden in CloudHub!

That's all! You should be able to run or deploy your application after these steps. Remember these steps are only meant for the step-by-step process in case you want to create your own Mule app from scratch.