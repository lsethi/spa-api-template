# Single Page Application API Template

Hi! This is a starter kit application template that implements a very basic (and very insecure) API that you can make RESTful requests to with a single-page application frontend. The idea is that you'll be building out a single page application on the root URL using nothing but a framework (or combination of frameworks, libraries, etc.).

## Application Overview

The site you're working with is called **awsumlink**. The database behind it has three core models: users, lists, and links. Users can have lists, and lists can have links.

The DB schemas:

```sql
users(
  id INTEGER PRIMARY KEY,
  username TEXT UNIQUE,
  password TEXT
);

lists(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  name TEXT, last_updated INTEGER,
  FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

links(
  id INTEGER PRIMARY KEY,
  list_id INTEGER NOT NULL,
  url TEXT,
  name TEXT,
  description TEXT,
  last_updated INTEGER,
  FOREIGN KEY(list_id) REFERENCES lists(id) ON DELETE CASCADE
);
```

There is currently no sign-in mechanism to store sessions or users. You can implement this yourself, but the core idea behind this template is to allow you to work with a readily accessible API and build out a resulting view from it, so no emphasis has been placed on typical concerns like session variables, security, etc.

This means that while you can clone and mess around with this site, it's NOT ready to go live! Don't put it on the internet!

## API

### GET `/users`

Returns all users as an array.

Example:

```json
[
  {
    "id": 1,
    "username": "Way",
    "password": "test"
  },
  {
    "id": 2,
    "username": "Jared",
    "password": "dog"
  }
]
```

### GET `/user/:id`

Return the username, password, id, and all lists of a specific user (you can pass either id or username here).

Returns:

```json
{
  "id": 1,
  "username": "Way",
  "password": "insecurepassword",
  "lists": [
    {
      "id": 1,
      "user_id": 1,
      "name": "Dog List",
      "last_updated": 1400637227
    },
    {
      "id": 2,
      "user_id": 1,
      "name": "Second List",
      "last_updated": 1400637329
    }
  ]
}
```

### POST `/user`



### DELETE `/user`

### GET `/user/:user_id/lists`

Returns just the lists belonging to a user.

Example:

```json
[
  {
    "id": 1,
    "user_id": 1,
    "name": "Dog List",
    "last_updated": 1400637227
  },
  {
    "id": 2,
    "user_id": 1,
    "name": "Second List",
    "last_updated": 1400637329
  }
]
```

### GET `/lists`

Returns all lists.

Example:

```json
[
  {
    "id": 1,
    "user_id": 1,
    "name": "Dog List",
    "last_updated": 1400637227
  },
  {
    "id": 2,
    "user_id": 1,
    "name": "Second List",
    "last_updated": 1400637329
  },
  {
    "id": 3,
    "user_id": 2,
    "name": "Jared's List",
    "last_updated": 1400683756
  }
]
```

### POST `/list`

### DELETE `/list`

### POST `/link`

### PUT `/link`

### DELETE `/link/:id`
