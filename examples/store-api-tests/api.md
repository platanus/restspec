# API
## Hello World

## Products

### Create [POST /products]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | non |
| code | string | exercitationem |
| price | decimal | 96.51 |
| category_id | schema_id | 99 |
| category | embedded_schema | {:name=>"quo"} |
| created_at | date_time | 2014-11-25T06:02:13-05:00 |
| updated_at | date_time | 2014-12-11T22:12:56-05:00 |

### Index [GET /products]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | et |
| code | string | ratione |
| price | decimal | 73.77 |
| category_id | schema_id | 99 |
| category | embedded_schema | {:name=>"voluptatum"} |
| created_at | date_time | 2014-11-20T05:45:58-05:00 |
| updated_at | date_time | 2014-12-12T07:54:57-05:00 |

### Show [GET /products/:id]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | debitis |
| code | string | rem |
| price | decimal | 74.36 |
| category_id | schema_id | 99 |
| category | embedded_schema | {:name=>"sunt"} |
| created_at | date_time | 2014-12-11T02:13:57-05:00 |
| updated_at | date_time | 2014-12-18T20:15:50-05:00 |

### Update [PUT /products/:id]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | possimus |
| code | string | dolores |
| price | decimal | 31.17 |
| category_id | schema_id | 99 |
| category | embedded_schema | {:name=>"voluptate"} |
| created_at | date_time | 2014-12-10T17:43:00-05:00 |
| updated_at | date_time | 2014-12-20T16:59:05-05:00 |

### Destroy [DELETE /products/:id]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | consectetur |
| code | string | suscipit |
| price | decimal | 25.78 |
| category_id | schema_id | 99 |
| category | embedded_schema | {:name=>"aut"} |
| created_at | date_time | 2014-12-09T08:39:31-05:00 |
| updated_at | date_time | 2014-11-29T08:33:43-05:00 |


## Categories

### Create [POST /categories]

Returns schema **category**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | pariatur |

### Index [GET /categories]

Returns schema **category**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | veritatis |

### Show [GET /categories/:id]

Returns schema **category**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | iure |

### Update [PUT /categories/:id]

Returns schema **category**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | odio |

### Destroy [DELETE /categories/:id]

Returns schema **category**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | id |

### Products [GET /categories/:id/products]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | minus |
| code | string | possimus |
| price | decimal | 22.93 |
| category_id | schema_id | 99 |
| category | embedded_schema | {:name=>"impedit"} |
| created_at | date_time | 2014-11-21T17:27:16-05:00 |
| updated_at | date_time | 2014-11-26T15:38:02-05:00 |


