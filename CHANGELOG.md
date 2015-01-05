0.1
---
- FEATURE: Added `:for` option to `schema` methods on the endpoint definition. This allows to specify schemas for payloads, schemas for responses and schemas for whatever. See: https://github.com/platanus/restspec/issues/2.
- FEATURE: Added `no_schema` method to endpoint definitions. This is a subtask of https://github.com/platanus/restspec/issues/2..

0.2
---
- FIX: Fixed a problem with schema extensions (`:without`) not working due to the fact that endpoints saved schema clones that just were shallow clones. They still were sharing the internal attributes hash.
- FIX: Fixed `no_schema`. It was not working because the schema setting of the namepsace were happening after the `no_schema` call. From now, `all` definitions will happen before the specific schema definitions.
- FEATURE: Changed abilities of schemas related to endpoints to just be the same as the schema roles. It's preferrable to have attributes only for payload or only for responses than attributes only for examples or only for checks. This is the new feature of the release.

0.3
---
- FIX: Fixed varios minor problems with internal access to hashes/openstructs related to properties with names of hashes methods.
- FIX: SchemaID was requiring the existence of the **index** endpoint.
- FIX: ChangedTilt dependency due to dependency problem with Rails 4.2.
- FEATURE: SchemaID's id property is now configurable. (SchemaId now can receive an `:id` option in case you don't want to use `:id`).
- FEATURE: Added `root` option to schema definition to allow wrapping the object in a root key.
