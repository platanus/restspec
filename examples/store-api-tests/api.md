# API

## Products
### Create [POST /products]
Returns schema **product**:

| Attribute | Type          | Example |
|-----------|:-------------:|--------:|
| name | string | repellat |
| code | string | architecto |
| price | decimal | 94.76 |
| category_id | schema_id | 48 |
| category | embedded_schema | {:name=>"autem"} |

### Index [GET /products]
Returns schema **product**:

| Attribute | Type          | Example |
|-----------|:-------------:|--------:|
| name | string | alias |
| code | string | iste |
| price | decimal | 43.09 |
| category_id | schema_id | 48 |
| category | embedded_schema | {:name=>"et"} |

### Show [GET /products/:id]
Returns schema **product**:

| Attribute | Type          | Example |
|-----------|:-------------:|--------:|
| name | string | quia |
| code | string | sint |
| price | decimal | 40.96 |
| category_id | schema_id | 48 |
| category | embedded_schema | {:name=>"suscipit"} |

### Update [PUT /products/:id]
Returns schema **product**:

| Attribute | Type          | Example |
|-----------|:-------------:|--------:|
| name | string | debitis |
| code | string | voluptate |
| price | decimal | 56.88 |
| category_id | schema_id | 48 |
| category | embedded_schema | {:name=>"est"} |

### Destroy [DELETE /products/:id]
Returns schema **product**:

| Attribute | Type          | Example |
|-----------|:-------------:|--------:|
| name | string | facilis |
| code | string | voluptas |
| price | decimal | 36.15 |
| category_id | schema_id | 48 |
| category | embedded_schema | {:name=>"molestiae"} |


## Categories
### Create [POST /categories]
Returns schema **category**:

| Attribute | Type          | Example |
|-----------|:-------------:|--------:|
| name | string | dolorum |

### Index [GET /categories]
Returns schema **category**:

| Attribute | Type          | Example |
|-----------|:-------------:|--------:|
| name | string | necessitatibus |

### Show [GET /categories/:id]
Returns schema **category**:

| Attribute | Type          | Example |
|-----------|:-------------:|--------:|
| name | string | repellat |

### Update [PUT /categories/:id]
Returns schema **category**:

| Attribute | Type          | Example |
|-----------|:-------------:|--------:|
| name | string | consequatur |

### Destroy [DELETE /categories/:id]
Returns schema **category**:

| Attribute | Type          | Example |
|-----------|:-------------:|--------:|
| name | string | porro |

### Products [GET /categories/:id/products]
Returns schema **product**:

| Attribute | Type          | Example |
|-----------|:-------------:|--------:|
| name | string | et |
| code | string | vero |
| price | decimal | 33.52 |
| category_id | schema_id | 48 |
| category | embedded_schema | {:name=>"autem"} |


