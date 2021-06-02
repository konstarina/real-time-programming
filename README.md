# real-time-programming
## description
Lab 1 + Lab 2
1. to read 2 SSE streams of actual Twitter API tweets in JSON format.
2. to route the messages to a group of workers
4. to route/load balance messages among worker actors in a round robin fashion
5. to treat "kill messages", on which the workers should be crashed.
6. to continue running the system need to have a supervisor for the workers.

'+'

1. to reuse the first Lab, with some additions.
2. to copy the Dynamic Supervisor + Workers that compute the sentiment score and adapt this copy of the system to compute the Engagement Ratio per Tweet.
3. some tweets are actually retweets and contain a special field retweet_status​ . You will have to extract it and treat it as a separate tweet. The Engagement Ratio will be computed as: (#favorites + #retweets) / #followers.
4. workers now print sentiment scores, they will have to send it to a dedicated aggregator actor where the sentiment score, the engagement ratio, and the original tweet will be merged together. 
5. to load everything into a database, for example Mongo, and given that writing messages one by one is not efficient, you will have to implement a backpressure mechanism called adaptive batching.This will be the responsibility of the sink actor(s).
6. to make things interesting, you will have to split the tweet JSON into users and tweets and keep them in separate collections/tables in the DB.
Of course, don't forget about using actors and supervisors for your system to keep it running.

## installation
To run the program, first you need to install all the dependencies
```elixir  
mix deps.get
```
After that you can run it 
```elixir 
iex -S mix
```
## demo
https://onedrive.live.com/?cid=476db69153b84057&id=476DB69153B84057%21119&authkey=!AIxPmsSRj4wcSIg
