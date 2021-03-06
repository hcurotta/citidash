# DockDash 

## Accessing the API

DockDash is an HTTP API accessible at [https://api.dockdash.racing/v1/](https://api.dockdash.racing/v1/)

## Summary of Endpoints

✓ = Implemented
* Friend based filtering is not yet implemented for any list views. 

```
## Authentication
✓ POST  /register
✓ POST  /login

## Search/View User Profiles
✓ GET   /user
✓ GET   /users
✓ GET   /users/:id
✓ GET   /users/:id/routes
✓ GET   /users/:id/trips
✓ GET   /users/:id/friendships

## Request/Accept/Destroy Friendships
✓ POST  /friendships
✓ PUT   /friendships/:id
✓ DELETE  /friendships/:id

## Route Details and Leaderboards
✓ GET   /routes
✓ GET   /routes/:id
✓ GET   /routes/:id/users
✓ GET   /routes/:id/trips

## Trip Details and Leaderboards
✓ GET   /trips
✓ GET   /trips/:id

## Overall Stats Leaderboard
✓ GET   /stats

## Notifications
GET   /notifications
PUT   /notifications/:id

## Other
✓ POST  /refresh_data

```

## Authentication
### Registering

Create a new user and retrieve a valid auth_token.

#### Request

*POST* `/register`

| Param | Value | Required |
| --- | --- | --- |
| email | Citibike account email |  ✓ |
| password | Citibike account password |  ✓ |
| accepts_terms | true/false |  ✓ |

#### Response

```
{
  "auth_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjp7ImlkIjoxLCJl
  "user": {
    "id": 1,
    "name": "Harry C."
  }
}
```

The `auth_token` returned here must be included in all subsequent API requests. The token must be included in the request header

```
Authorization: Bearer AbCdeyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjp7ImlkIjoxLCJleHAiOjE1MDAyNDA2MDMsImlhdCI6MTUwMDIzNzAwM319.pDARrli20g9LVPqtuFJv5js3eBomInYgXndXQUJ43T8Ef123456
```


### Logging In

Retrieve a valid auth_token for an existing user.

#### Request

*POST* `/login`

| Param | Value | Required |
| --- | --- | --- |
| email | Citibike account email |  ✓ |
| password | Citibike account password |  ✓ |

#### Response

```
{
  "auth_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjp7ImlkIjoxLCJl
  "user": {
    "id": 1,
    "name": "Harry C."
  }
}
```

The `auth_token` returned here must be included in all subsequent API requests. The token must be included in the request header

```
Authorization: Bearer AbCdeyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjp7ImlkIjoxLCJleHAiOjE1MDAyNDA2MDMsImlhdCI6MTUwMDIzNzAwM319.pDARrli20g9LVPqtuFJv5js3eBomInYgXndXQUJ43T8Ef123456
```

## User Profiles

### Search for Users
Return a list of users matching a query, e.g. name/email

#### Request

*GET* `/users`

| Param | Value | Required |
| --- | --- | --- |
| query | Email address or name. e.g. `harry@domain.com` |  ✓ |

#### Response 


```
{
  "total": 1,
  "offset": 0,
  "limit": 100,
  "data": [
    {
      "id": 1,
      "first_name": "Harry",
      "last_name": "Curotta",
      "name": "Harry C.",
      "friendship": {
          "id": 5,
          "status": "requested",
      },
    },
  ],
}
```

### User Details
Retrieve user including top level stats and 5 favourite routes and 5 latest trips. 

Routes in common is a list of 5 routes where both the logged-in user and the retrieved user have completed trips. These are ordered by the number of trips (of the retrieved user) descending. 

Favourite routes are routes with most trips, ordered by number of trips descending. 

#### Request

*GET* `/user` (retrieve logged in user)

*GET* `/users/:id` (retrieve arbitrary user)

#### Response 

```
{
  "id": 1,
  "first_name": "Harry",
  "last_name": "Curotta",
  "name": "Harry C.",
  "friendship": {
      "id": 5,
      "status": "requested",
  },
  "stats" {
    "trip_count": 276,
    "total_duration": 200380,
    "total_distance": 415,
  },
  "last_refreshed_at": "2018-06-14T06:14:41.634+00:00",
  "latest_trips": [
    {
      "id": 1,
      "started_at": "2016-10-03T13:23:56.000+01:00",
      "ended_at": "2016-10-03T13:30:17.000+01:00",
      "route": {
        "id": 656,
        "origin": {
          "id": 1,
          "name": "E 4 St & 2 Ave"
          "lat": -73.99392888,
          "lon": 40.76727216,
        },
        "destination": {
          "id": 2,
          "name": "E 13 St & Avenue A"
          "lat": -73.99392888,
          "lon": 40.76727216,
        },
        "maps": {
          "thumb": "https://dockdash.s3.amazonaws.com/production/maps/8210_thumb_v20180511.png",
          "small": "https://dockdash.s3.amazonaws.com/production/maps/8210_small_v20180511.png",
          "large": "https://dockdash.s3.amazonaws.com/production/maps/8210_large_v20180511.png"
        },
      },
    },    
  ],
  "favourite_routes": [
    {
      "id": 656,
      "trip_count": 13,
      "origin": {
        "id": 1,
        "name": "E 4 St & 2 Ave"
        "lat": -73.99392888,
        "lon": 40.76727216,
      },
      "destination": {
        "id": 2,
        "name": "E 13 St & Avenue A"
        "lat": -73.99392888,
        "lon": 40.76727216,
      },
      "maps": {
        "thumb": "https://dockdash.s3.amazonaws.com/production/maps/8210_thumb_v20180511.png",
        "small": "https://dockdash.s3.amazonaws.com/production/maps/8210_small_v20180511.png",
        "large": "https://dockdash.s3.amazonaws.com/production/maps/8210_large_v20180511.png"
      },
    },
  ],
  "routes_in_common": [
    {
      "id": 656,
      "trip_count": 13,
      "origin": {
        "id": 1,
        "name": "E 4 St & 2 Ave"
        "lat": -73.99392888,
        "lon": 40.76727216,
      },
      "destination": {
        "id": 2,
        "name": "E 13 St & Avenue A"
        "lat": -73.99392888,
        "lon": 40.76727216,
      },
      "maps": {
        "thumb": "https://dockdash.s3.amazonaws.com/production/maps/8210_thumb_v20180511.png",
        "small": "https://dockdash.s3.amazonaws.com/production/maps/8210_small_v20180511.png",
        "large": "https://dockdash.s3.amazonaws.com/production/maps/8210_large_v20180511.png"
      },
    },
  ],
}
```

### User Routes
Show all routes for a user.

#### Request

*GET* `/users/:id/routes`

| Param | Value | Required | Default |
| --- | --- | --- | --- |
| order_by | `trip_count`, `last_trip_ended_at` | no | `trip_count` |
| start_date | ISO 8601 format date | no | all time |
| end_date | ISO 8601 format date | no | all time |

#### Response 

```
{
  "total": 1,
  "offset": 0,
  "limit": 100,
  "data": [
    {
      "id": 656,
      "trip_count": 13,
      "last_trip_ended_at": "2016-10-03T13:30:17.000+01:00",
      "origin": {
        "id": 1,
        "name": "E 4 St & 2 Ave"
        "lat": -73.99392888,
        "lon": 40.76727216,
      },
      "destination": {
        "id": 2,
        "name": "E 13 St & Avenue A"
        "lat": -73.99392888,
        "lon": 40.76727216,
      },
      "maps": {
        "thumb": "https://dockdash.s3.amazonaws.com/production/maps/8210_thumb_v20180511.png",
        "small": "https://dockdash.s3.amazonaws.com/production/maps/8210_small_v20180511.png",
        "large": "https://dockdash.s3.amazonaws.com/production/maps/8210_large_v20180511.png"
      },
    },
  ],
}
```

### User Trips
Show all trips for the logged in user ordered by most recent first

#### Request

*GET* `/users/:id/trips`

| Param | Value | Required | Default |
| --- | --- | --- | --- |
| start_date | ISO 8601 format date | no | all time |
| end_date | ISO 8601 format date | no | all time |

#### Response 

```
{
  "total": 1,
  "offset": 0,
  "limit": 100,
  "data": [
    {
      "id": 1,
      "started_at": "2016-10-03T13:23:56.000+01:00",
      "ended_at": "2016-10-03T13:30:17.000+01:00",
      "duration_in_seconds": 204,
      "route": {
        "id": 656,
        "origin": {
          "id": 1,
          "name": "E 4 St & 2 Ave"
          "lat": -73.99392888,
          "lon": 40.76727216,
        },
        "destination": {
          "id": 2,
          "name": "E 13 St & Avenue A"
          "lat": -73.99392888,
          "lon": 40.76727216,
        },
        "maps": {
          "thumb": "https://dockdash.s3.amazonaws.com/production/maps/8210_thumb_v20180511.png",
          "small": "https://dockdash.s3.amazonaws.com/production/maps/8210_small_v20180511.png",
          "large": "https://dockdash.s3.amazonaws.com/production/maps/8210_large_v20180511.png"
        },
      },
    },
  ],
}
```


### User Friendships
List a given user's friends.

#### Request

*GET* `/users/:id/friendships`

| Param | Value | Required | Default |
| --- | --- | --- | --- |
| status | Friendship status: `pending` or `active` |  no | returns all |

#### Response 

```
{
  "total": 1,
  "offset": 0,
  "limit": 100,
  "data": [
    {
      "id": 1,
      "status": "pending",
      "user": {
        "id": 2,
        "first_name": "John",
        "last_name": "Mair",
        "name": "John M.",
      },
    },
  ],
}
```

## Managing Friendships
### Request Friendship
Create a pending friend request between the logged-in user and another user. 

#### Request

*POST* `/friendship`

| Param | Value | Required |
| --- | --- | --- |
| user_id | ID of the friend to be requested |  ✓ |


#### Response


```
{
  "id": 1,
  "status": "requested",
  "user": {
    "id": 2,
    "first_name": "John",
    "last_name": "Mair",
    "name": "John M.",
  },
}
```

### Accept Friendship
Accept a pending friend request. Status changes from 'pending' to 'active'. 

Note: Only friendships with 'pending' status may be accepted. Friendships with a 'requested' status are awaiting the other person accepting.

#### Request

*PUT* `/friendships/:id`

#### Response


```
{
  "id": 1,
  "status": "active",
  "user": {
    "id": 2,
    "first_name": "John",
    "last_name": "Mair",
    "name": "John M.",
  },
}
```

### Reject/Destroy Friendship

Delete a friendship regardless of status.

#### Request

*DELETE* `/friendships/:id`

#### Response

`200 OK`

## Route Details
### All Routes
Show all routes across the whole system. A date range and friends_only flag can be provided to scope results. 

They can be ordered by total trip count descending, or by routes with the most recent trips. 

#### Request

*GET* `/routes`

| Param | Value | Required | Default |
| --- | --- | --- | --- |
| order_by | `trip_count`, `last_trip_ended_at` | no | `trip_count` |
| start_date | ISO 8601 format date | no | all time |
| end_date | ISO 8601 format date | no | all time |
| friends_only | `true` or `false`  | no | `false` |

#### Response 

```
{
  "total": 1,
  "offset": 0,
  "limit": 100,
  "data": [
    {
      "id": 1,
      "trip_count": 13,
      "last_trip_ended_at": "2016-10-03T13:30:17.000+01:00",
      "origin": {
        "id": 1,
        "name": "E 4 St & 2 Ave"
        "lat": -73.99392888,
        "lon": 40.76727216,
      },
      "destination": {
        "id": 2,
        "name": "E 13 St & Avenue A"
        "lat": -73.99392888,
        "lon": 40.76727216,
      },
    },
  ],
}
```


### Show Route
Show details of an individual route, including the total number of trips and fastest trip.

#### Request

*GET* `/routes/:id`

#### Response 

```
{
  "id": 1,
  "origin": {
    "id": 1,
    "name": "E 4 St & 2 Ave"
    "lat": -73.99392888,
    "lon": 40.76727216,
  },
  "destination": {
    "id": 2,
    "name": "E 13 St & Avenue A"
    "lat": -73.99392888,
    "lon": 40.76727216,
  },
  "maps": {
    "thumb": "https://dockdash.s3.amazonaws.com/production/maps/8210_thumb_v20180511.png",
    "small": "https://dockdash.s3.amazonaws.com/production/maps/8210_small_v20180511.png",
    "large": "https://dockdash.s3.amazonaws.com/production/maps/8210_large_v20180511.png"
  },
  "trip_count": 27,
  "fastest_trip": {
    "id": 1,
    "started_at": "2016-10-03T13:23:56.000+01:00",
    "ended_at": "2016-10-03T13:30:17.000+01:00",
    "duration_in_seconds": 262,
    "user": {
      "id": 2,
      "first_name": "John",
      "last_name": "Mair",
      "name": "John M.",
    },
  },
}
```

### Show Users of Route  
All users who have completed trips on a route. Can be scoped by date range.

#### Request

*GET* `/routes/:id/users`

| Param | Value | Required | Default |
| --- | --- | --- | --- |
| order_by | `most_recent`, `most_trips` or `fastest_trip` | no | `fastest_trip` |
| friends_only | `true` or `false`  | no | `false` |
| start_date | ISO 8601 format date | no | all time |
| end_date | ISO 8601 format date | no | all time |

#### Response 

```
{
  "total": 1,
  "offset": 0,
  "limit": 100,
  "data": [
    {
      "id": 1,
      "first_name": "Harry",
      "last_name": "Curotta",
      "name": "Harry C.",
      "fastest_trip_duration_in_seconds": 262,
      "trip_count": 20,
      "last_trip_ended_at": "2016-10-03T13:23:56.000+01:00",
    }
  ],
}
```

### Show Trips for Route  
All completed trips for a route.

#### Request

*GET* `/routes/:id/trips`

| Param | Value | Required | Default |
| --- | --- | --- | --- |
| order_by | `last_trip_ended_at`, `fastest_trip` | no | `fastest_trip` |
| friends_only | `true` or `false`  | no | `false` |
| start_date | ISO 8601 format date | no | all time |
| end_date | ISO 8601 format date | no | all time |

#### Response 

```
{
  "total": 1,
  "offset": 0,
  "limit": 100,
  "data": [
    {
      "id": 1,
      "started_at": "2016-10-03T13:23:56.000+01:00",
      "ended_at": "2016-10-03T13:30:17.000+01:00",
      "user": {
        "id": 2,
        "first_name": "John",
        "last_name": "Mair",
        "name": "John M.",
      },
      duration_in_seconds: 503,
    },
  ],
}
```

## Trip Details
### List all Trips
All completed trips.

#### Request

*GET* `/trips`

| Param | Value | Required | Default |
| --- | --- | --- | --- |
| start_date | ISO 8601 format date | no | all time |
| end_date | ISO 8601 format date | no | all time |
| friends_only | `true` or `false`  | no | `false` |

#### Response 

```
{
  "total": 1,
  "offset": 0,
  "limit": 100,
  "data": [
    {
      "id": 1,
      "started_at": "2016-10-03T13:23:56.000+01:00",
      "ended_at": "2016-10-03T13:30:17.000+01:00",
      "duration_in_seconds": 240,
      "user": {
        "id": 1,
        "first_name": "Harry",
        "last_name": "Curotta",
        "name": "Harry C.",
      },
      "route": {
        "id": 656,
        "origin": {
          "id": 1,
          "name": "E 4 St & 2 Ave"
          "lat": -73.99392888,
          "lon": 40.76727216,
        },
        "destination": {
          "id": 2,
          "name": "E 13 St & Avenue A"
          "lat": -73.99392888,
          "lon": 40.76727216,
        },
        "maps": {
          "thumb": "https://dockdash.s3.amazonaws.com/production/maps/8210_thumb_v20180511.png",
          "small": "https://dockdash.s3.amazonaws.com/production/maps/8210_small_v20180511.png",
          "large": "https://dockdash.s3.amazonaws.com/production/maps/8210_large_v20180511.png"
        },
      },
    },    
  ],
}
```

### Show Trip
Show specific trip details.

#### Request

*GET* `/trips/:id`

#### Response 

```
{
  "id": 1,
  "started_at": "2016-10-03T13:23:56.000+01:00",
  "ended_at": "2016-10-03T13:30:17.000+01:00",
  "duration_in_seconds": 240,
  "user": {
    "id": 1,
    "first_name": "Harry",
    "last_name": "Curotta",
    "name": "Harry C.",
  },
  "route": {
    "id": 656,
    "origin": {
      "id": 1,
      "name": "E 4 St & 2 Ave"
      "lat": -73.99392888,
      "lon": 40.76727216,
    },
    "destination": {
      "id": 2,
      "name": "E 13 St & Avenue A"
      "lat": -73.99392888,
      "lon": 40.76727216,
    },
    "maps": {
      "thumb": "https://dockdash.s3.amazonaws.com/production/maps/8210_thumb_v20180511.png",
      "small": "https://dockdash.s3.amazonaws.com/production/maps/8210_small_v20180511.png",
      "large": "https://dockdash.s3.amazonaws.com/production/maps/8210_large_v20180511.png"
    },
  },
}
```

## Overall Leaderboard
### Stats

All user stats. Defaults to be ordered by trip count.

#### Request

*GET* `/stats`

| Param | Value | Required | Default |
| --- | --- | --- | --- |
| order_by | `trip_count`, `total_distance` or `total_duration` | no | `trip_count` |
| friends_only | `true` or `false`  | no | `false` |
| start_date | ISO 8601 format date | no | all time |
| end_date | ISO 8601 format date | no | all time |

#### Response 

```
{
  "total": 2,
  "offset": 0,
  "limit": 100,
  "data": [
    {
      "id": 2,
      "trip_count": 1569,
      "total_duration": 942975,
      "total_distance": "2132.0",
      "user": {
        "id": 2,
        "first_name": "John",
        "last_name": "Mair",
        "name": "John M.",
      },
    },
    {
      "id": 1,
      "trip_count": 276,
      "total_duration": 200380,
      "total_distance": "415.1",
      "user": {
        "id": 1,
        "first_name": "Harry",
        "last_name": "Curotta",
        "name": "Harry C.",
      },
  ],
}
```

## Notifications
### List all Notifications

List all notifications for the logged in user by most recent first.

#### Request

*GET* `/notifications`

| Param | Value | Required | Default |
| --- | --- | --- | --- |
| read | `true` or `false`  | no | all notifications |

#### Response

```
{
  "total": 2,
  "offset": 0,
  "limit": 100,
  "data": [
    {
      "id": 1,
      "body": "Harry C. has sent you a friend request.",
      "associated_object_id": 1,
      "associated_object_type": "User",
      "read": false
    },
    {
      "id": 2,
      "body": "John M. has sent you a friend request.",
      "associated_object_id": 2,
      "associated_object_type": "User",
      "read": true
    }
  ],
}
```

### Acknowledge Notification

Acknowledge a notification, changing its read status to true. 

#### Request

*PUT* `/notifications/:id`

#### Response

```
{
  "id": 1,
  "body": "Harry C. has sent you a friend request.",
  "associated_object_id": 1,
  "associated_object_type": "User",
  "read": true
}
```

## Other
### Load/Refresh User Data from Citibike

Refresh data from citibike for current logged-in user. 

#### Request

*POST* `/refresh_data`

#### Response 

`200 OK`