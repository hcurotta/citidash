# API 

## Authenticating

#### Request

*POST* `/login`

| Param | Value | Required |
| --- | --- | --- |
| email | Citibike account email |  ✓ |
| password | Citibike account password |  ✓ |

#### Response

```
{
    "auth_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjp7ImlkIjoxLCJleHAiOjE1MDAyNDA2MDMsImlhdCI6MTUwMDIzNzAwM319.pDARrli20g9LVPqtuFJv5js3eBomInYgXndXQUJ43T8",
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

## Load/Refresh User Data from Citibike

#### Request

*POST* `/profile/refresh_data`

#### Response 

```
{
    "id": 1,
    "user_id": 1,
    "trip_count": 276,
    "total_duration_in_seconds": 200380,
    "distance_travelled": 415
}
```

## User Details

#### Request

*GET* `/profile`

#### Response 

```
{
    "data": {
        "first_name": "Harry",
        "last_name": "Curotta",
        "name": "Harry C."
    },
    "links": {
        "self": "/profile?"
    }
}
```

## User Stats

#### Request

*GET* `/profile/stats`

#### Response 

```
{
    "data": {
        "trip_count": 276,
        "total_duration": 200380,
        "total_distance": 415,
        "yellow_jerseys": 196
    },
    "links": {
        "self": "/profile/stats?"
    }
}
```

## User Trips
Show all trips for the logged in user ordered by most recent first

#### Request

*GET* `/profile/trips`

#### Response 

```
{
    "total": 276,
    "offset": 0,
    "limit": 100,
    "data": [
        {
            "id": 1,
            "started_at": "2016-10-03T13:23:56.000+01:00",
            "ended_at": "2016-10-03T13:30:17.000+01:00",
            "origin": {
                "id": 1,
                "name": "Mott St & Prince St"
            },
            "destination": {
                "id": 2,
                "name": "Allen St & Hester St"
            }
        },
      ...
    ],
    "links": {
        "links": {
            "self": "/profile/trips?",
            "next": "/profile/trips?offset=100&"
        }
    }
}
```

## User Routes
Show all routes for the logged in user ordered by most commonly taken

#### Request

*GET* `/profile/routes`

#### Response 

```
{
    "total": 196,
    "offset": 0,
    "limit": 100,
    "data": [
        {
            "id": 656,
            "trip_count": 13,
            "origin": {
                "id": 72,
                "name": "Broadway & E 22 St"
            },
            "destination": {
                "id": 41,
                "name": "Mott St & Prince St"
            }
        },
        ...
    ],
    "links": {
        "links": {
            "self": "/profile/routes?",
            "next": "/profile/routes?offset=100&"
        }
    }
}
```

## All Routes
Show all routes across the whole system 

#### Request

*GET* `/routes`

#### Response 

```
{
    "total": 922,
    "offset": 0,
    "limit": 100,
    "data": [
        {
            "id": 1,
            "origin": {
                "id": 1,
                "name": "E 4 St & 2 Ave"
            },
            "destination": {
                "id": 2,
                "name": "E 13 St & Avenue A"
            }
        },
        ...
    ],
    "links": {
        "links": {
            "self": "/routes?",
            "next": "/routes?offset=100&"
        }
    }
}
```


## Show Route
Show details of an individual route, including the yellow jersey holder (The user with the fastest time).

#### Request

*GET* `/route/:id`

#### Response 

```
{
    "data": {
        "id": 1,
        "origin": {
            "id": 1,
            "name": "E 4 St & 2 Ave"
        },
        "destination": {
            "id": 2,
            "name": "E 13 St & Avenue A"
        },
        "yellow_jersey": {
            "user": {
                "id": 1,
                "name": "John M."
            },
            "time": 262
        }
    },
    "links": {
        "self": "/route/1?"
    }
}
```

## Show users of Route  
All users who have completed a route, ordered by fastest time

#### Request

*GET* `/route/:id/users`

#### Response 

```
{
    "total": 1,
    "offset": 0,
    "limit": 100,
    "data": [
        {
            "id": 1,
            "duration_in_seconds": 262,
            "user": {
                "id": 1,
                "name": "John M."
            },
            "origin": {
                "id": 1,
                "name": "E 4 St & 2 Ave"
            },
            "destination": {
                "id": 2,
                "name": "E 13 St & Avenue A"
            }
        }
    ],
    "links": {
        "links": {
            "self": "/route/1/users?"
        }
    }
}
```

## Stats Leaderboard

All user stats. Defaults to be ordered by trip count.

| Param | Value | Required |
| --- | --- | --- |
| order_by | trip_count, total_distance or total_duration | x |


#### Request

*GET* `/stats`

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
            "total_distance": 1953,
            "user": {
                "id": 2,
                "name": "John M."
            }
        },
        {
            "id": 1,
            "trip_count": 276,
            "total_duration": 200380,
            "total_distance": 415,
            "user": {
                "id": 1,
                "name": "Harry C."
            }
        }
    ],
    "links": {
        "links": {
            "self": "/stats?order_by=total_distance&"
        }
    }
}
```
