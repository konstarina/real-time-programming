# real-time-programming
## description
### Lab 3
The data from previous laboratory work  in the directory ```previouslab``` that is evaluated by sentimental and engagement scores & transmitted to **Collector** 
that saves in database all the information. Message Broker is sending the data received in the previous lab and stpored in database to the subscribers on topic tweets.
The client is in the previouslab module, the server is in the broker module. 


## installation
To run the program, first you need to run docker containers in the background in detached mode
```elixir  
docker-compose up -d
```
Telnet ip 127.0.0.1 port 4444
