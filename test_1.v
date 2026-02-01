module traffic_test;

reg clock,X,clear;
wire [1:0] hwy,cntry;
control test(clock,hwy,cntry,X,clear);

initial begin
    clock=0;
    repeat(50)
    begin
    #5 clock= 1;
    #5 clock =0;
    end
end

initial
    begin
        #3 clear=1'b1; X=1'b0;
        #5 clear=1 ;X=1;
        #5 clear=0 ;X=1;
        #25 clear=0;X=1;
        #5 clear=0 ;X=0;
    end
    initial
    begin
        $dumpfile ("cont.vcd");
        $dumpvars (0,traffic_test);
        #300 $finish;
    end

endmodule
