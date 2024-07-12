%dw 2.0
output application/json
var statusCode = error.errorMessage.attributes.statusCode
---
{
    error: {
        description: error.description,
        message: error.errorMessage.payload.message,
        statusCode: statusCode,
        reasonPhrase: error.errorMessage.attributes.reasonPhrase,
        MuleRecommendation: if (statusCode ~= 409)
            "There probably is already a job in queue for this specific object."
            ++ " If you have the job ID, you can try getting the job's details to verify its state."
            ++ " If the state appears as InProgress, you will have to wait until Data Cloud finishes the processing (JobComplete/Failed) to try this operation again."
        else "No recommendation for this error."
    }
}