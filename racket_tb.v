module racket_tb;
    reg clk;             
    reg reset;           
    reg up;              
    reg down;            
    wire [9:0] racket_y; 

    // Instanciando o módulo 'racket'
    racket uut (
        .clk(clk),
        .reset(reset),
        .up(up),
        .down(down),
        .racket_y(racket_y)
    );

    // Gerando o clock (oscila a cada 10 unidades de tempo)
    always #5 clk = ~clk;

    // Testes de movimentação da raquete
    initial begin
        // Inicializando os sinais
        clk = 0;
        reset = 0;
        up = 0;
        down = 0;

        // Teste 1: Reset (posiciona a raquete no meio)
        reset = 1;
        #10;
        reset = 0;
        #10;

        // Teste 2: Movimento para cima (por 20 ciclos)
        up = 1;
        #200;
        up = 0;

        // Teste 3: Movimento para baixo (por 30 ciclos)
        down = 1;
        #300;
        down = 0;

        // Teste 4: Movendo para cima e para baixo (alternado)
        up = 1;
        #50;
        up = 0;
        down = 1;
        #50;
        down = 0;

        // Finaliza a simulação
        #100;
        $finish;
    end

    // Monitorar os sinais para verificar o comportamento durante a simulação
    initial begin
        $monitor("Time: %0t | Reset: %b | Up: %b | Down: %b | Racket Y: %d", 
                 $time, reset, up, down, racket_y);
    end

endmodule
