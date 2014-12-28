# API
## Hello World

## Products

### Create [POST /products]

#### Payload

The payload is an instance of the **product** schema.


  ```json
  {
    "name": "doloremque",
    "code": "sit",
    "price": 73.23,
    "category_id": "8"
  }
  ```


#### Response
  Returns schema **product**


  ```json
  {
    "name": "molestiae",
    "code": "distinctio",
    "price": 12.71,
    "category_id": "6"
  }
  ```

### Index [GET /products]


#### Response
  Returns schema **product**


  ```json
  {
    "name": "eum",
    "code": "labore",
    "price": 44.15,
    "category_id": "3"
  }
  ```

### Show [GET /products/:id]


#### Response
  Returns schema **product**


  ```json
  {
    "name": "nihil",
    "code": "ut",
    "price": 38.38,
    "category_id": "8"
  }
  ```

### Update [PUT /products/:id]


#### Response
  Returns schema **product**


  ```json
  {
    "name": "aut",
    "code": "dolores",
    "price": 51.59,
    "category_id": "6"
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
    "name": "eum"
  }
  ```

### Index [GET /categories]


#### Response
  Returns schema **category**


  ```json
  {
    "name": "optio"
  }
  ```

### Show [GET /categories/:id]


#### Response
  Returns schema **category**


  ```json
  {
    "name": "ut"
  }
  ```

### Update [PUT /categories/:id]


#### Response
  Returns schema **category**


  ```json
  {
    "name": "velit"
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
    "name": "blanditiis",
    "code": "aut",
    "price": 52.95,
    "category_id": "6"
  }
  ```


