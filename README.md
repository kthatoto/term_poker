# term_poker
Draw Poker on Terminal

<img src="/kthatoto/term_poker/raw/master/images/term_poker.gif" alt="Demo" width="500">

## Requirement
* `Ruby`
* `term_canvas` https://github.com/kthatoto/term_canvas

## Installation
    $ gem install term_canvas
    $ git clone git@github.com:kthatoto/term_poker.git

## Getting Started
    $ ruby term_poker/main.rb

### Quit
|key|action|
|---|---|
|`q`|Quit game|

### Betting
<img src="/kthatoto/term_poker/raw/master/images/betting.png" alt="Betting" width="500">

|key|action|
|---|---|
|`k`|Up bet $1|
|`K`|Up bet $5|
|`j`|Down bet $1|
|`J`|Down bet $5|
|`h`|Bet half of total|
|`m`|Bet all|
|`0`|Cancel betting|
|`Enter`|Decide bet and Start to play|

### Playing
The cards which has been raised are going to change.  
The change is only once.

<img src="/kthatoto/term_poker/raw/master/images/playing.png" alt="Playing" width="500">

|key|action|
|---|---|
|`h`|Move cursor to left|
|`l`|Move cursor to right|
|`Space`|Toggle the card at the cursor position to change|
|`Enter`|Change the cards|

### Result

<img src="/kthatoto/term_poker/raw/master/images/result.png" alt="Result" width="500">

|key|action|
|---|---|
|`Enter`|Get payout and return to betting|
