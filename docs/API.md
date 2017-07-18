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
