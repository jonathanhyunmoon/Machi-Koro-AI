(**[roll ()] is a random number between 1 and 6. The value that it gives
   changes each time it's called.*)
val roll : unit -> int
(**[multiple_roll ()] is the sum of two calls for roll (). As such, the value
   that it gives also changes each time it's called.*)
val multiple_roll : unit -> int
