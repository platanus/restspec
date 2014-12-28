# API
## Hello World

## Products

### Create [POST /products]

#### Payload

The payload is an instance of the **product** schema.


  ```json
  {
    "name": "consequatur",
    "code": "corporis",
    "price": 86.56,
    "category_id": "5"
  }
  ```


#### Response
  Returns schema **product**


  ```json
  {
    "created_at": "2014-12-08T20:04:00-05:00",
    "updated_at": "2014-12-02T21:02:47-05:00",
    "name": "ut",
    "code": "nobis",
    "price": 13.52,
    "category_id": "1",
    "category": {
      "name": "delectus"
    }
  }
  ```

### Index [GET /products]


#### Response
  Returns schema **product**


  ```json
  {
    "created_at": "2014-12-27T12:23:04-05:00",
    "updated_at": "2014-12-04T23:20:43-05:00",
    "name": "voluptatem",
    "code": "facilis",
    "price": 41.47,
    "category_id": "8"
  }
  ```

### Show [GET /products/:id]


#### Response
  Returns schema **product**


  ```json
  {
    "created_at": "2014-11-28T20:21:40-05:00",
    "updated_at": "2014-12-28T08:10:27-05:00",
    "name": "quasi",
    "code": "rerum",
    "price": 39.48,
    "category_id": "0",
    "category": {
      "name": "saepe"
    }
  }
  ```

### Update [PUT /products/:id]


#### Response
  Returns schema **product**


  ```json
  {
    "created_at": "2014-12-27T02:32:32-05:00",
    "updated_at": "2014-12-05T22:31:32-05:00",
    "name": "iure",
    "code": "autem",
    "price": 47.17,
    "category_id": "1",
    "category": {
      "name": "ut"
    }
  }
  ```

### Destroy [DELETE /products/:id]


#### Response
  The response is empty.


## Categories

### Create [POST /categories]


#### Response
  Returns schema **category**


  ```json
  {
    "name": "quaerat"
  }
  ```

### Index [GET /categories]


#### Response
  Returns schema **category**


  ```json
  {
    "name": "amet"
  }
  ```

### Show [GET /categories/:id]


#### Response
  Returns schema **category**


  ```json
  {
    "name": "consequatur"
  }
  ```

### Update [PUT /categories/:id]


#### Response
  Returns schema **category**


  ```json
  {
    "name": "voluptatem"
  }
  ```

### Destroy [DELETE /categories/:id]


#### Response
  The response is empty.

### Products [GET /categories/:id/products]


#### Response
  Returns schema **product**


  ```json
  {
    "created_at": "2014-12-13T00:42:13-05:00",
    "updated_at": "2014-12-12T18:31:59-05:00",
    "name": "labore",
    "code": "exercitationem",
    "price": 15.84,
    "category_id": "0",
    "category": {
      "name": "incidunt"
    }
  }
  ```


