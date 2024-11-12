# Data Cloud integration built in MuleSoft

This is a Mule 4 app created to communicate with your Data Cloud. You can query, insert, or delete records using this integration; as well as flatten a YAML schema for your Salesforce settings.

![](/images/cover-ms-sf-dc.png)

What's in this repo:
1. [Data Cloud Integration API/](/Data%20Cloud%20Integration%20API/) ~ Contains the files I used to publish the **API Specification** that is publicly available in my Exchange Portal [here](https://anypoint.mulesoft.com/exchange/portals/mulesoft-36559/b903eebf-16e9-46c5-8992-bffd66c2306c/data-cloud-integration-api/).
2. [data-cloud-integration-impl/](/data-cloud-integration-impl/) ~ Contains the Mule project I created for you to call Data Cloud. This is the code used to generate the JAR file that you will use to deploy the Mule app in Anypoint Platform. You can download the latest JAR from the `releases` section of this repo or by clicking [here](https://github.com/alexandramartinez/datacloud-mulesoft-integration/releases/download/1.0.0/data-cloud-integration-impl-1.0.0-mule-application.jar).
3. [rest-clients-requests](/rest-clients-requests/) ~ Contains the Postman/Thunder Client collections to run the requests to call your integration. There is also a .md file in the curl folder for you to copy/paste cURL commands if that's easier for you.
4. [example-schema.yaml](/example-schema.yaml) ~ Example YAML file that you can use if you don't have a YAML schema to create the Ingestion API/Data Stream objects in Data Cloud.

## Similar repos

[![](https://github-readme-stats.vercel.app/api/pin/?username=alexandramartinez&repo=data-cloud-auth&theme=default_repocard)](https://github.com/alexandramartinez/data-cloud-auth)
[![](https://github-readme-stats.vercel.app/api/pin/?username=alexandramartinez&repo=mule-dynamodb-to-datacloud&theme=default_repocard)](https://github.com/alexandramartinez/mule-dynamodb-to-datacloud)

---

## Set up the integration

I have created detailed resources for you to follow all the necessary steps to get this integration working.

---

</br>
<p align="center"><img height="100" src="/images/salesforce.png"></p>
</br>

### Part 1: Connected App, Ingestion API & Data Stream settings in Salesforce

In this first part, we'll go through the Salesforce/Data Cloud settings that we need to set up before even calling Data Cloud through the Mule app.

- [Read the article](https://www.prostdev.com/post/part-1-data-cloud-mulesoft-integration)
- [Watch the video](https://youtu.be/WVkf2ni-S6s)

![](/images/part1.webp)

---

</br>
<p align="center"><img height="100" src="/images/mulesoft.png"></p>
</br>

### Part 2: Deploy your own Mule app on Anypoint Platform (CloudHub)

In this second part, we'll go through the MuleSoft side of the integration and you'll deploy your own Mule app to CloudHub. You do not have to know MuleSoft beforehand. I will guide you through every step.

- [Read the article](https://www.prostdev.com/post/part-2-data-cloud-mulesoft-integration)
- [Watch the video](https://youtu.be/A48011haXRw)

![](/images/part2.webp)

---

</br>
<p align="center"><img height="100" src="/images/postman.svg"></p>
</br>

### Part 3: Call your integration with Postman

In this third part, we'll learn how to use our integration. We'll use Postman for this article, but you can use any other REST client like Thunder Client, cURL, or Advanced REST Client.

- [Read the article](https://www.prostdev.com/post/part-3-data-cloud-mulesoft-integration)
- [Watch the video](https://youtu.be/CNAnWwUxycg)

![](/images/part3.webp)

---

</br>
<p align="center"><img height="100" src="/images/mulesoft.png"></p>
</br>

### Part 4: Secure your API with basic authentication in API Manager

In Part 2 of this series, we learned that we should not share the CloudHub URL because everyone had access to our Data Cloud credentials with just the link.


There is a simple solution to this problem. In this post, we'll learn how to connect our Mule app (deployed in CloudHub) to API Manager to add basic authentication. This way, even if you share your URL by mistake, people would still need your username/password to access it.

- [Read the article](https://www.prostdev.com/post/part-4-data-cloud-mulesoft-integration)
- [Watch the video](https://youtu.be/r_AM3P8Y-_Q)

![](/images/part4.jpg)

---

## Create your own - step by step

Follow [this guide](/step-by-step.md) if you want to create your own Mule integration from scratch!

</br>
<p align="center"><img height="200" src="/images/max-terminal.gif"></p>
</br>
