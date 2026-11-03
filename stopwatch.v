module stopwatch (
   input wire [1:0] sw,       
   output reg [6:0] seg,      
   output reg [3:0] an,       
   input btnS,                
   input btnR,                
   input clk                  
);

    reg [6:0] num [0:9];
    initial begin
        num[0] = 7'b1000000; 
        num[1] = 7'b1111001; 
        num[2] = 7'b0100100; 
        num[3] = 7'b0110000; 
        num[4] = 7'b0011001; 
        num[5] = 7'b0010010; 
        num[6] = 7'b0000010; 
        num[7] = 7'b1111000; 
        num[8] = 7'b0000000; 
        num[9] = 7'b0010000; 
    end

   reg [3:0] sec_ones = 0;
   reg [2:0] sec_tens = 0;
   reg [3:0] min_ones = 0;
   reg [2:0] min_tens = 0;
   
   reg [1:0] anode_select = 0;
   
   reg [26:0] count_1hz = 0;
   reg [25:0] count_2hz = 0;
   reg [16:0] count_refresh = 0;
   reg [24:0] count_blink = 0; 
   
   reg pause = 0;
   reg blink_toggle = 0; 

   reg btnS_sync0, btnS_sync1;
   reg btnS_last;
   wire btnS_pressed;

    always @(posedge clk) begin
        btnS_sync0 <= btnS;       
        btnS_sync1 <= btnS_sync0;
        btnS_last  <= btnS_sync1;
    end
    assign btnS_pressed = (btnS_sync1 && !btnS_last);
    
   always @(posedge clk) begin
          
       if (btnS_pressed) begin
           pause <= ~pause;
       end 
       
       if (btnR) begin
          anode_select  <= 0; 
          sec_ones      <= 0;
          min_ones      <= 0;
          sec_tens      <= 0;
          min_tens      <= 0;
          count_1hz     <= 0;
          count_2hz     <= 0;
          count_refresh <= 0;
          count_blink   <= 0;
          pause         <= 0;
       end else begin
          
          if (sw[0]) begin
              count_1hz <= 0;
              
              if (count_2hz == 49_999_999) begin
                  count_2hz <= 0;
                  if (sw[1]) begin
                      if (sec_ones == 9) begin
                          sec_ones <= 0;
                          if (sec_tens == 5) sec_tens <= 0;
                          else sec_tens <= sec_tens + 1;
                      end else begin
                          sec_ones <= sec_ones + 1;
                      end
                  end else begin
                      if (min_ones == 9) begin
                          min_ones <= 0;
                          if (min_tens == 5) min_tens <= 0;
                          else min_tens <= min_tens + 1;
                      end else begin
                          min_ones <= min_ones + 1;
                      end
                  end
              end else begin
                  count_2hz <= count_2hz + 1;
              end
              
          end else if (!pause) begin
              count_2hz <= 0; 
              if (count_1hz == 99_999_999) begin
                    count_1hz <= 0;
                    if (sec_ones == 9) begin
                        sec_ones <= 0;
                        if (sec_tens == 5) begin
                            sec_tens <= 0;
                            if (min_ones == 9) begin
                                min_ones <= 0;
                                if (min_tens == 5) min_tens <= 0;
                                else min_tens <= min_tens + 1;
                            end else begin
                                min_ones <= min_ones + 1;
                            end
                        end else begin
                            sec_tens <= sec_tens + 1;
                        end
                    end else begin
                        sec_ones <= sec_ones + 1;
                    end
              end else begin
                    count_1hz <= count_1hz + 1;
              end
          end

          if (count_refresh == 124_999) begin
              count_refresh <= 0;
              anode_select  <= anode_select + 1;
          end else begin
              count_refresh <= count_refresh + 1;
          end

          if (count_blink == 12_499_999) begin
              count_blink  <= 0;
              blink_toggle <= ~blink_toggle;
          end else begin
              count_blink  <= count_blink + 1;
          end     
      end
  end
 
 always @(*) begin
    if (btnR) begin
        an  = 4'b0000;         
        seg = num[0]; 
    end else if (sw[0] && blink_toggle) begin
        an  = 4'b1111;         
        seg = 7'b1111111;
    end else begin
        case (anode_select)
            2'b00: begin
                an  = 4'b1110;          
                seg = num[sec_ones];    
            end
            2'b01: begin
                an  = 4'b1101;          
                seg = num[sec_tens];
            end
            2'b10: begin
                an  = 4'b1011;          
                seg = num[min_ones];
            end
            2'b11: begin
                an  = 4'b0111;          
                seg = num[min_tens];
            end
            default: begin
                an  = 4'b1111;         
                seg = 7'b1111111;
            end
        endcase
    end
 end

endmodule
