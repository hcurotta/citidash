# Database Strategy

## Schema

![image](https://user-images.githubusercontent.com/1894233/27995574-cf4a0066-64c8-11e7-929b-6a2e12307ad8.png)

## Modelling Routes

Routes are considered to be any station pair. Given that there are over 600 docking stations in NY, this means there are more than 360,000 possible routes. Many of these routes are impossible/unlikely due to the 30 minute time limit on each rental - i.e. it is unlikely that someone will ride from a dock on the Upper West Side to Dumbo without docking it and taking another bike along the way. 

Given this, it's silly to pre-generate every possible route so we should only save a route to the routes table once it has been ridden for the first time. 
