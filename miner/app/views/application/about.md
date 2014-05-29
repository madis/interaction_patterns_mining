# Visitor rank

## Problem

There can be high number of online visitors online. The sales agents want to approach the visitors with highest potential. We need to order the online visitors based on their *interestingness* to the agents.

## Solution

We record events for different actions that the visitors take on the page. Visitors can also themselves contact the sales agents. Based on this data we rank the visitors and update the ordering of the *online visitors list*.

```ruby
class Wadiis
  def das_ist?
    "hallo"
  end

  def wut
    :in_the_but
  end
end
```

## Developed prototype

### Creating the learning dataset for testing

- user starts new learning session
- generate events by clicking buttons or number keys
- mark the sequence as good or bad

### Simulating live visitors

- web page for generating different events
- events are sent to server over *WebSocket*
- data is stored into database

### Notifying agent of the results

- VisitorRank module calculates new ordering as event data is received
- updated rankings are pushed to the online sales agents
- in browser the agent's visitor list is ordered based on updated info
