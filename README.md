# real-time-programming
## description
### Lab 3
The data from previous laboratory work  in the directory ```app``` that is evaluated by sentimental and engagement scores & transmitted to **Collector** 
which saves in database all the information. Message Broker is sending the data received in the previous lab and stpored in database to the subscribers on topic tweets.
The client is in the previouslab module, the server is in the broker module. 


## installation
To run the program, first you need to run docker containers in the background in detached mode
```elixir  
cd broker
mix deps.get
elixir --sname broker@localhost -S mix run --no-halt


mix deps.get
elixir --sname publisher@localhost -S mix run --no-halt
```
Telnet ip 127.0.0.1 port 4040
