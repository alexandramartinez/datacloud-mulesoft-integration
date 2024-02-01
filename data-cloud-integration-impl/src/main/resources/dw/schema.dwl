%dw 2.0
output application/yaml skipNullOn="objects"
import try from dw::Runtime
fun isDate(value: Any): Boolean = try(() -> value as Date).success
fun isDateTime(value: Any): Boolean = try(() -> value as DateTime).success
fun flattenObject(data:Any, result={}) = (
    data match {
        case is Object -> data mapObject ((value, key) ->
            value match {
                case is Object -> flattenObject(value, result)
                else -> flattenObject(value, result ++ {(key):value})
            }
        )
        case is Array -> flattenObject(data[0]) // only first item from array will be taken
        else -> result
    }
)
//payload must be an object
var flattenedObject = payload mapObject ((value, key, index) -> 
    (key): flattenObject(value)
)
---
{
    openapi: attributes.queryParams.openapiversion default "3.0.3",
    components: {
        schemas: flattenedObject mapObject ((mainObj, mainObjKey) -> 
            (mainObjKey): {
                "type": lower(typeOf(mainObj)),
                properties: mainObj mapObject ((props, propsKey) -> 
                    (propsKey): {
                        "type": lower(typeOf(props)),
                        format: (props match {
                            case is Number -> null
                            case d if isDateTime(d) -> "date-time"
                            case d if isDate(d) -> "date"
                            else -> null
                        })
                    }
                )
            }
        )
    }
}