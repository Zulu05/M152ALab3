# M152ALab3
4 digit display: left 2 count mins, right 2 count seconds
select switch -> min or sec for adjust mode -> non selected freezes and other ticks up + flashes
reset -> 00:00 
pause -> pause/play behavior

3.5 controls -> reset, pause, select and adjust mode
4 clocks -> counting speed clock 1hz, adjust speed clocks 2 hz + blinks at speed > 1hz, display multiplexing speed b/c when coding 7 segment display all 4 values display at the same time = need multiplexing speed to make sure each value appears differently than each other
tesbench not required but good way to see if you're on the right track
pulse -> whatever happens in if statement happens once
50% edge clock -> what we're using, traditional wave = high for 50% and low for 50% -> whatever is in the always @posedge is sustained till next cycle
50% 2 edge -> always @ clock, we aren't using it here

clock enable -> don't have nested always blocks, esp w/ different speeds
concurrent assignment -> common error = assign same val to variable across multiple always blocks rather than just in 1 block, avoids race conditions/conflicts

implementing lab
1. setting up 7 segment display, each corresponds to a 7 digit cathode. 1 is off, 0 is on. switch statement -> these are the bits for the 7 digit cathode.
   ABCDEFG -> we want to display 1 -> 1001111
   Anode selection, 0 is on 1 is off, to select which digit to turn on. left to right
2. the board connected all 7 cathode wires to all 4 anodes at the same time, so to combat that we only turn on 1 anode bit at a time to ensure each position has their own unique counter. then we use the multiplexing clock to ensure 4 different numbers are shown via optical illusion
3. hardcode some numbers to check if your numbers are write. logic is flipped when coding. abc... 5 = 0100100 but when we code its 5 = 0010010
4. adding buttons -> encoding a reset and pause. can add this to finite state machine
5. adjust and select switches = 1 and 0 respectively, increment at 2hz and blinks > 1hz and < 2hz. deselect adjust switches counter picks up at new time. entire clock blinks
6. debouncing: lots of noise coming in when we press a button or seelct a swtich. to reduce meta stability and noise we hav a debouncer (think lab 0)
