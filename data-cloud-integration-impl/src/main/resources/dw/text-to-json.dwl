%dw 2.0
output application/json
---
if (payload.^mediaType contains "text") {
	sql: payload
} else payload