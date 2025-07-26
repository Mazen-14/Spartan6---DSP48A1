module DSP48A1_tb;
    reg clk;
    reg CARRYIN;
    reg CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP;
    reg RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP;
    reg [17:0] A, B, D, BCIN;
    reg [47:0] C, PCIN;
    reg [7:0]  opmode;
    wire CARRYOUT, CARRYOUTF;
    wire [17:0] BCOUT;
    wire [35:0] M;
    wire [47:0] P, PCOUT;
    reg CARRYOUT_old;
    reg [47:0] P_old;
    DSP48A1 DUT (
        .clk(clk),
        .CARRYIN(CARRYIN),
        .CEA(CEA), .CEB(CEB), .CEC(CEC), .CECARRYIN(CECARRYIN),
        .CED(CED), .CEM(CEM), .CEOPMODE(CEOPMODE), .CEP(CEP),

        .RSTA(RSTA), .RSTB(RSTB), .RSTC(RSTC), .RSTCARRYIN(RSTCARRYIN),
        .RSTD(RSTD), .RSTM(RSTM), .RSTOPMODE(RSTOPMODE), .RSTP(RSTP),

        .A(A), .B(B), .D(D), .BCIN(BCIN),
        .C(C), .PCIN(PCIN),
        .opmode(opmode),

        .CARRYOUT(CARRYOUT), .CARRYOUTF(CARRYOUTF),
        .BCOUT(BCOUT),
        .M(M),
        .P(P), .PCOUT(PCOUT)
    );
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end
    // 2. Stimulus Generation
    initial begin
        // 2.1. Verify Reset Operation
        // Assert all resets
        RSTA = 1; RSTB = 1; RSTC = 1; RSTCARRYIN = 1;
        RSTD = 1; RSTM = 1; RSTOPMODE = 1; RSTP = 1;

        // Drive remaining inputs with random values
        A = $random;B = $random;D = $random;BCIN = $random;
        C = $random;PCIN = $random;opmode = $random;CARRYIN = $random;
        CEA = $random;CEB = $random;CEC = $random;CECARRYIN = $random;
        CED = $random;CEM = $random;CEOPMODE = $random;CEP = $random;

        // Wait for negative edge of the clock
        @(negedge clk);

        // Self Checking
        if (CARRYOUT != 0 || CARRYOUTF != 0 || BCOUT != 0 ||
            M != 0 || P != 0 || PCOUT != 0) begin
            $display("Outputs are not zero during reset");
            $stop;
            end

        // Deassert all resets
        RSTA = 0; RSTB = 0; RSTC = 0; RSTCARRYIN = 0;
        RSTD = 0; RSTM = 0; RSTOPMODE = 0; RSTP = 0;
        CEA = 1;CEB = 1;CEC = 1;CECARRYIN = 1;
        CED = 1;CEM = 1;CEOPMODE = 1;CEP = 1;

        // 2.2. Verify DSP Path 1
        opmode = 8'b11011101;
        A = 20; B = 10; C = 350; D = 25;
        BCIN = $random; PCIN = $random; CARRYIN = $random;
        repeat(4)@(negedge clk);
        if (BCOUT !== 18'hf || M !== 36'h12c || P !== 48'h32 ||
            PCOUT !== 48'h32 || CARRYOUT !== 1'b0 || CARRYOUTF !== 1'b0) begin
            $display("Outputs are wrong for path 1");
            $stop;
            end

        // 2.3. Verify DSP Path 2
        opmode = 8'b00010000;
        A = 20; B = 10; C = 350; D = 25;
        BCIN = $random; PCIN = $random; CARRYIN = $random;
        repeat(3)@(negedge clk);
        if (BCOUT !== 18'h23 || M !== 36'h2bc || P !== 48'h0 ||
            PCOUT !== 48'h0 || CARRYOUT !== 1'b0 || CARRYOUTF !== 1'b0) begin
            $display("Outputs are wrong for path 2");
            $stop;
            end

        // 2.4. Verify DSP Path 3
        opmode = 8'b00001010;
        A = 20; B = 10; C = 350; D = 25;
        BCIN = $random; PCIN = $random; CARRYIN = $random;
        P_old = P; CARRYOUT_old = CARRYOUT;
        repeat(3)@(negedge clk);
        if (BCOUT !== 18'ha || M !== 36'hc8 || P !== P_old ||
            PCOUT !== P_old || CARRYOUT !== CARRYOUT_old || CARRYOUTF !== CARRYOUT_old) begin
            $display("Outputs are wrong for path 3");
            $stop;
            end

        // 2.5. Verify DSP Path 4
        opmode = 8'b10100111;
        A = 5; B = 6; C = 350; D = 25; PCIN = 3000;
        BCIN = $random; CARRYIN = $random;
        P_old = P; CARRYOUT_old = CARRYOUT;
        repeat(3)@(negedge clk);
        if (BCOUT !== 18'h6 || M !== 36'h1e || P !== 48'hfe6fffec0bb1 ||
            PCOUT !== 48'hfe6fffec0bb1 || CARRYOUT !== 1 || CARRYOUTF !== 1) begin
            $display("Outputs are wrong for path 4");
            $stop;
            end

        $stop;
    end

endmodule