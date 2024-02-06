## Table of Contents

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

## Create your own - step by step

> [!IMPORTANT]
> There is no need for you to go through these steps if you only want to make use of the integration. This is only if you want to learn how to create the whole Mule integration step by step. From designing the API specification to implementing the Mule project.

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