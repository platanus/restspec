# Types

## Array Type

- It uses the method `array`.
- It tests if the current attribute value is an array.
- Currently, it generates an array depending on the length option and the parameterized type (specified with `of`) being used.
- It only has the `length` option, that is fixed number.
- It can be composed of other types using `of`. With `of`, it can test the content of the array more deeply.

    ```ruby
    attribute :matrix, array.of(array.of(decimal | decimal_string))
    ```


## Boolean Type

- It uses the method `boolean`.
- It tests if the current attribute value is `true` or `false`.
- It generates randomly `true` or `false`.
- It doesn't use any option.

## Decimal String Type

- It uses the method `decimal_string`.
- It tests if the current attribute value is a string that looks like a decimal. (Eg: `"0.1"`)
- It generates a decimal wrapped into a string.
- It uses the following options:
    + Example Options:
        * **integer_part:** It specifies the integer part of the generated number.
        * **decimal_part:** It specifies the decimal part of the generated number.
    + Schema Options:
        * **integer_part:** It specifies the expected integer part size of the given attribute value.
        * **decimal_part:** It verifies the expected decimal part size of the given attribute value.

## Decimal Type

- It uses the method `decimal`.
- In only tests if the attribute value is numeric.
- It generates a decimal number.
- It uses the following options:
    + Example Options:
        * **integer_part:** It specifies the integer part of the generated number.
        * **decimal_part:** It specifies the decimal part of the generated number.

## Hash Type

- It uses the method `hash`.
- It tests if the attribute is a hash containing some optional keys with an optional value type.
- Currently, it generates an empty hash. (We should think further if they should generate more than this, and how)
- It uses the following options:
    + Schema Options:
        * **keys:** Array of keys that should be in the hash.
        * **value_type:** Type (method used by the type) of the values of the hash. With this, `hash` can be composed of other types.

## Integer Type

- It uses the method `integer`.
- In only tests if the attribute value is a fixed number.
- It generates a random integer number.
- It doesn't use any option.

## Null Type

- It uses the method `null`.
- It only test for null values.
- It always generates null.
- It doesn't use any option.
- It's useful composed with any other type. For example, for a value that can a string but it's optional.

    ```ruby
    attribute :address, string | null
    ```

## 'One Of' Type
- It uses the method `one_of`.
- It checks if the attribute values is one of the items specified in the `elements` array option.
- It returns one of the items in the `elements` array option.
- It only has the `elements` option.

    ```ruby
    attribute :type, one_of(elements: ['water', 'fire', 'thunder', 'psychic'])
    ```

## 'Schema Id' Type

- It uses the method `schema_id`. The first parameter of this method is the main schema to test.
- It checks if the attribute value is an id of some element in the `index` endpoint associated to the given schema.
- It generates an object by fetching one item in the `index` endpoint. If there's no item in that endpoint, it will create one item using the `create` endpoint. After this, it will return the id of the item.
- It uses the following options:
    + Schema Options:
        * **perform_validation:** A boolean to specify if we should perform a schema validation or not. (In case we only want to generate information for tests but not to check against anytime).
    + Example Options:
        * **create_schema:** Name of the schema used to generate data.
        * **hardcoded_fallback:** If we can't get or create the id, this option will be used instead of raise an error.
        * **fetch_endpoint:** The endpoint to use to fetch. By default, it's the `index` endpoint of the namespace asociated with this schema.
        * **create_endpoint:** The endpoint to use to create data. By default, it's the `create` endpoint of the namespace asociated with this schema.

## String Type

- It uses the method `string`.
- It tests if the current attribute value is a string.
- It generates a random word.
- It doesn't use any option.
