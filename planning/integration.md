## Retrieving Trips

A non-paginated list of trips in plain HTML form can be retrieved by hitting the below link:

https://member.citibikenyc.com/profile/trips/NU7S9DAK-1/print/preview?edTripsPrint[startDate]=07/07/2016&edTripsPrint[endDate]=07/07/2017

Parameters:

| Param | Description |
| --- | --- |
| User Id | Citibike user id e.g. NU7S9DAK-1 |
| edTripsPrint[startDate] | Start date for list of trips MM/DD/YYY |
| edTripsPrint[endDate] | End date for list of trips MM/DD/YYY |

* Note that the start and end dates may not be more than 16 months apart

The response contains a div-formed table of trips as below:

The HTML representation of this table is: 

```
<div class="ed-table_trips-wrapper ed-table_closed-trips-wrapper ed-table_closed-trips-print-wrapper">
    <div class="ed-table ed-table_trip">
        <div class="ed-table__headers">
            <div class="ed-table__header ed-table__header_trip-start ed-table__col ed-table__col_trip-start">Start</div>
            <div class="ed-table__header ed-table__header_trip-end ed-table__col ed-table__col_trip-end">End</div>
            <div class="ed-table__header ed-table__header_trip-duration ed-table__col ed-table__col_trip-duration">Duration</div>
        </div>
        <div class="ed-table__items">
            <div class="ed-table__item ed-table__item_trip ed-table__item_odd ">
                <div class="ed-table__item__info ed-table__item__info_trip-start ed-table__col ed-table__col_trip-start ">
                    <div class="ed-table__item__info__sub-info ed-table__item__info__sub-info_1 ed-table__item__info__sub-info_trip-start-date">10/03/2016 12:23:56 PM</div>
                    <div class="ed-table__item__info__sub-info ed-table__item__info__sub-info_2 ed-table__item__info__sub-info_trip-start-station">Mott St &amp; Prince St</div>
                </div>
                <div class="ed-table__item__info ed-table__item__info_trip-end ed-table__col ed-table__col_trip-end ">
                    <div class="ed-table__item__info__sub-info ed-table__item__info__sub-info_1 ed-table__item__info__sub-info_trip-end-date">10/03/2016 12:30:17 PM</div>
                    <div class="ed-table__item__info__sub-info ed-table__item__info__sub-info_2 ed-table__item__info__sub-info_trip-end-station">Allen St &amp; Hester St</div>
                </div>
                <div class="ed-table__item__info ed-table__item__info_trip-duration ed-table__col ed-table__col_trip-duration ">
                    6 min 21 s </div>
            </div>
            <div class="ed-table__item ed-table__item_trip ed-table__item_even ">
                <div class="ed-table__item__info ed-table__item__info_trip-start ed-table__col ed-table__col_trip-start ">
                    <div class="ed-table__item__info__sub-info ed-table__item__info__sub-info_1 ed-table__item__info__sub-info_trip-start-date">09/27/2016 10:11:49 PM</div>
                    <div class="ed-table__item__info__sub-info ed-table__item__info__sub-info_2 ed-table__item__info__sub-info_trip-start-station">Leonard St &amp; Church St</div>
                </div>
                <div class="ed-table__item__info ed-table__item__info_trip-end ed-table__col ed-table__col_trip-end ">
                    <div class="ed-table__item__info__sub-info ed-table__item__info__sub-info_1 ed-table__item__info__sub-info_trip-end-date">09/27/2016 10:17:52 PM</div>
                    <div class="ed-table__item__info__sub-info ed-table__item__info__sub-info_2 ed-table__item__info__sub-info_trip-end-station">Cleveland Pl &amp; Spring St</div>
                </div>
                <div class="ed-table__item__info ed-table__item__info_trip-duration ed-table__col ed-table__col_trip-duration ">
                    6 min 3 s </div>
            </div>
        </div>
    </div>
</div>
```
