%dw 2.0
output application/x-www-form-urlencoded
---
{
    client_id: Mule::p('cdp.consumer.key'),
    client_secret: Mule::p('cdp.consumer.secret'),
    username: Mule::p('salesforce.username'),
    password: Mule::p('salesforce.password'),
    grant_type: "password"
}