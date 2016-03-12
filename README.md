# flightstats

Visualizing 1M flight routes with CartoDB

### Usage

to get the ratings data, you will need a FlightStats API key

```
ruby get_ratings.rb
```

once the CSV has been imported to [CartoDB](https://cartodb.com/), replace the `vizJSON` in `www/index.html` with your own data

```
cd www
python -m SimpleHTTPServer
```

### License

Copyright (c) 2016 Carlos Matallín

Licensed under the MIT license, see LICENSE.md for more information.
