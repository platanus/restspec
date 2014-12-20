# API
## Hello World

## Products

### Create [POST /products]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | libero |
| code | string | expedita |
| price | decimal | 49.18 |
| category_id | schema_id | 1 |
| category | embedded_schema | {:name=>"rerum"} |
| created_at | date_time | 2014-12-15T12:37:23-05:00 |
| updated_at | date_time | 2014-12-14T18:01:19-05:00 |

### Index [GET /products]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | voluptatum |
| code | string | blanditiis |
| price | decimal | 77.09 |
| category_id | schema_id | 2 |
| category | embedded_schema | {:name=>"ipsam"} |
| created_at | date_time | 2014-12-11T18:07:45-05:00 |
| updated_at | date_time | 2014-12-20T22:30:23-05:00 |

### Show [GET /products/:id]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | distinctio |
| code | string | blanditiis |
| price | decimal | 55.84 |
| category_id | schema_id | 4 |
| category | embedded_schema | {:name=>"iure"} |
| created_at | date_time | 2014-12-07T13:39:53-05:00 |
| updated_at | date_time | 2014-12-07T13:45:22-05:00 |

### Update [PUT /products/:id]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | sit |
| code | string | ut |
| price | decimal | 85.80 |
| category_id | schema_id | 5 |
| category | embedded_schema | {:name=>"qui"} |
| created_at | date_time | 2014-12-02T15:11:53-05:00 |
| updated_at | date_time | 2014-11-29T13:55:04-05:00 |

### Destroy [DELETE /products/:id]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | aut |
| code | string | illo |
| price | decimal | 81.59 |
| category_id | schema_id | 3 |
| category | embedded_schema | {:name=>"quis"} |
| created_at | date_time | 2014-11-25T07:30:09-05:00 |
| updated_at | date_time | 2014-11-30T22:45:02-05:00 |


## Categories

### Create [POST /categories]

Returns schema **category**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | voluptate |

### Index [GET /categories]

Returns schema **category**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | odit |

### Show [GET /categories/:id]

Returns schema **category**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | explicabo |

### Update [PUT /categories/:id]

Returns schema **category**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | quos |

### Destroy [DELETE /categories/:id]

Returns schema **category**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | fuga |

### Products [GET /categories/:id/products]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | eos |
| code | string | odit |
| price | decimal | 41.37 |
| category_id | schema_id | 8 |
| category | embedded_schema | {:name=>"et"} |
| created_at | date_time | 2014-11-24T12:34:34-05:00 |
| updated_at | date_time | 2014-11-25T02:07:06-05:00 |


