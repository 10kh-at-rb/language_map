Using Google BigQuery GitHub dataset and d3.js to map repositories by language.

The dataset can be found here:
https://bigquery.cloud.google.com/table/githubarchive:github.timeline

I haven't figured out out exactly which data to pull for the visualization, but the query I'm using for my seed data in development is as follows:

```sql
SELECT payload_head, repository_url, repository_language, actor_attributes_location
FROM [githubarchive:github.timeline]
WHERE type="PushEvent"
AND payload_head IS NOT NULL
AND repository_url IS NOT NULL
AND repository_language IS NOT NULL
AND actor_attributes_location IS NOT NULL
AND PARSE_UTC_USEC(created_at) >= PARSE_UTC_USEC('2013-11-01 00:00:00')
LIMIT 1000;
```

To seed data, run this query and export to CSV, and upload the CSV at http://localhost:3000/data.

To populate latitude/longitude, run `rake latlong:populate`. I haven't figured out how the Geocoder/Google rate limiting works but you'll probably need to run the rake task a few times before all of the records with findable location names are populated.
