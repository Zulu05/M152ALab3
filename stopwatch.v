module stopwatch (
   input wire [3:0] sw,       //switches
   output reg [6:0] seg,      //cathodes
   output reg [3:0] an,        //anodes
   //pause button, reset button, clock
   input btnS, 
   input btnR, 
   input clk
);
   parameter NUM_0 = 7'b1000000;
   parameter NUM_1 = 7'b1111001;
   parameter NUM_2 = 7'b0100100;
   parameter NUM_3 = 7'b0110000;
   parameter NUM_4 = 7'b0011001;
   parameter NUM_5 = 7'b0010010;
   parameter NUM_6 = 7'b0000010;
   parameter NUM_7 = 7'b1111000;
   parameter NUM_8 = 7'b0000000;
   parameter NUM_9 = 7'b0010000;
   reg [26:0] count_1hz = 0;
   reg clk_1hz = 0;
   reg [25:0] count_2hz = 0;
   reg [17:0] count_refresh = 0;
   reg [24:0] count_blink = 0; 
   
   always @(posedge clk) begin
      // Default display state: Hardcoded to show 9 across the board
      seg <= NUM_9;
      
      // Master Display Toggle: Drive anodes low (ON) if clk_1hz is 1, else high (OFF)
      if (clk_1hz) begin
          an <= 4'b0000; 
      end else begin
          an <= 4'b1111;
      end

      // 1 Hz Clock Generator Logic
      if (count_1hz == 49_999_999) begin
          count_1hz <= 0;
          clk_1hz   <= ~clk_1hz;
      end else begin
          count_1hz <= count_1hz + 1;
      end
  end
 

endmodule


    // // --- 2 Hz Clock Block ---
    // // Toggles every 25,000,000 cycles of a 100MHz clock
    // always @(posedge clk) begin
    //     if (count_2hz == 24_999_999) begin
    //         count_2hz <= 0;
    //         clk_2hz   <= ~clk_2hz;
    //     end else begin
    //         count_2hz <= count_2hz + 1;
    //     end
    // end

    // // --- 400 Hz Anode Refresh Clock Block (Fits the 50-700 Hz requirement) ---
    // // Toggles every 125,000 cycles of a 100MHz clock
    // always @(posedge clk) begin
    //     if (count_refresh == 124_999) begin
    //         count_refresh <= 0;
    //         clk_refresh   <= ~clk_refresh;
    //     end else begin
    //         count_refresh <= count_refresh + 1;
    //     end
    // end

    // // --- 4 Hz Blinking Clock Block ---
    // // Toggles every 12,500,000 cycles of a 100MHz clock
    // always @(posedge clk) begin
    //     if (count_blink == 12_499_999) begin
    //         count_blink <= 0;
    //         clk_blink   <= ~clk_blink;
    //     end else begin
    //         count_blink <= count_blink + 1;
    //     end
    // end

// output reg clk_1hz,      // Internal 1 Hz stopwatch clock
//     output reg clk_2hz,      // Internal 2 Hz adjustment speed clock
//     output reg clk_refresh,  // Internal ~400 Hz anode cycling clock
//     output reg clk_blink     // Internal ~4 Hz digit blinking clock
// );

//     // Independent counter registers for each clock domain
//     reg [26:0] count_1hz     = 0;
//     reg [25:0] count_2hz     = 0;
//     reg [17:0] count_refresh = 0;
//     reg [24:0] count_blink   = 0;
