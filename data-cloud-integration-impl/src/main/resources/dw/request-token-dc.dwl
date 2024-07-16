%dw 2.0
output application/x-www-form-urlencoded
---
{
    grant_type: "urn:salesforce:grant-type:external:cdp",
    subject_token: vars.SFTokenResponse.access_token,
    subject_token_type: "urn:ietf:params:oauth:token-type:access_token"
}