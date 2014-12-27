# API
## Hello World

## Products

### Create [POST /products]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| created_at | date_time | 2014-12-08T22:35:55-05:00 |
| updated_at | date_time | 2014-12-02T07:52:23-05:00 |
| name | string | doloremque |
| code | string | voluptatem |
| price | decimal | 61.76 |
| category_id | schema_id | 51 |
| category | embedded_schema | {:name=>"deserunt"} |

### Index [GET /products]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| created_at | date_time | 2014-11-27T10:18:05-05:00 |
| updated_at | date_time | 2014-11-25T14:47:53-05:00 |
| name | string | quaerat |
| code | string | et |
| price | decimal | 70.28 |
| category_id | schema_id | 51 |
| category | embedded_schema | {:name=>"rerum"} |

### Show [GET /products/:id]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| created_at | date_time | 2014-12-05T13:39:27-05:00 |
| updated_at | date_time | 2014-12-23T13:04:47-05:00 |
| name | string | sed |
| code | string | quam |
| price | decimal | 81.56 |
| category_id | schema_id | 51 |
| category | embedded_schema | {:name=>"commodi"} |

### Update [PUT /products/:id]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| created_at | date_time | 2014-12-11T19:55:48-05:00 |
| updated_at | date_time | 2014-12-01T18:33:17-05:00 |
| name | string | possimus |
| code | string | omnis |
| price | decimal | 13.37 |
| category_id | schema_id | 51 |
| category | embedded_schema | {:name=>"tempora"} |

### Destroy [DELETE /products/:id]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| created_at | date_time | 2014-12-17T17:29:46-05:00 |
| updated_at | date_time | 2014-12-22T08:20:22-05:00 |
| name | string | quos |
| code | string | aut |
| price | decimal | 32.84 |
| category_id | schema_id | 51 |
| category | embedded_schema | {:name=>"saepe"} |


## Categories

### Create [POST /categories]

Returns schema **category**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | nam |

### Index [GET /categories]

Returns schema **category**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | ut |

### Show [GET /categories/:id]

Returns schema **category**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | tempore |

### Update [PUT /categories/:id]

Returns schema **category**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | vel |

### Destroy [DELETE /categories/:id]

Returns schema **category**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| name | string | rerum |

### Products [GET /categories/:id/products]

Returns schema **product**


|  Attribute  |             Type           |     Example    |
|-------------|:--------------------------:|---------------:|
| created_at | date_time | 2014-12-23T23:47:07-05:00 |
| updated_at | date_time | 2014-11-29T07:40:59-05:00 |
| name | string | corrupti |
| code | string | aut |
| price | decimal | 03.80 |
| category_id | schema_id | 51 |
| category | embedded_schema | {:name=>"qui"} |


