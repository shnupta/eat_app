# snack

snacc is an app that allows you to purchase vouchers for amazing restaurants near you to get discounts like 40% off your meal, just for eating at an earlier time!

## For Andy:

**Directories or files which contain code I've written:**

- `app_engine/app.js`
- `cloud_functions/functions/index.js`
- `The entire lib/ directory`

**Interesting files and what they do:**

- `lib/blocs/find_a_restaurant/*.dart` - This is the most complex bloc in the app. It is well commented and has some cool functions such as: merge sort, calculating the distance between two GPS coordinates and handling business logic like filters of a search.
- `lib/bloc/booking/booking_bloc.dart` - This is another cool bloc. It handles the creation of vouchers and payment transactions etc. In  `mapEventToState` on the `OrderConfirmedEvent` selection, you can see where a voucher is created and written to the database and then the app waits for a change to that voucher to happen by listening to a stream from my custom database class. When a change is received it handles it appropriately (i.e show an error or the receipt)
- `lib/algolia` - This is my own Algolia API class that I wrote. Didn't realise there was a package for it but it shows me handling HTTP requests to API endpoints. `algolia_index.dart` is the most interesting file in that directory.
- `lib/database/database.dart` - This is my own custom Database class. It is the main way that I access my database throughout the app. Meaning all communication to the database can be handled and managed in one class.
- `lib/models/*` - All the files in my models directory are fairly interesting. They show loads of OOP principles in place. Particularly `restaurant.dart`, `voucher.dart` and `user.dart`. In `restaurant.dart` there is a cool function called `isInsideAvailability` which determines if a time interval picked by the user has any overlap with the availability map of a restaurant. This is used in filtering when a user wants to book find restaurants that are open on a particular time/day.
- `lib/pages/find_a_restaurant/filter_menu.dart` - This is the widget that is the filter menu used in the find a restaurant page. It shows LOADS of handling inputs like user taps and low level handling of events, along with the find a restaurant bloc mentioned earlier.
- `cloud_functions/functions/index.js` - This file contains all of my functions that are in the cloud, ready to be triggered by things such as a database write or http request. A couple interesting functions are: `onVoucherCreated` - This function is triggered when a user confirms they'd like to purchase a voucher, it shows communication with another API, exception handling and response handling; `onRestaurantBookingReceived` - This function is triggered when a transaction was successfully completed and will update the restaurants availability in the database to show that there has been a booking.


