module pong(
    input clk,              
    input reset,            
    input up_p1,            // Move o player 1 (esquerda) para cima
    input down_p1,          // Move o player 1 (esquerda) para baixo
    input up_p2,            // Move o player 2 (esquerda) para cima
    input down_p2,          // Move o player 2 (esquerda) para baixo
    output hsync,           // Sincronização horizontal VGA
    output vsync,           // Sincronização vertical VGA
    output [2:0] rgb        // Sinal RGB (3 bits: 1 bit por cor: R, G, B)
);
    // Parâmetros de posicionamento e tamanho
    parameter largura_raquete = 10;
    parameter altura_raquete = 40;
    parameter largura_bola = 5;

    // Coordenadas das raquetes e bola
    wire [9:0] raquete1_y, raquete2_y;
    wire [9:0] bola_x, bola_y;

    // Coordenadas VGA
    wire [9:0] vga_x, vga_y;
    wire display_on;

    // Instanciando o controlador VGA
    vga_controller vga(
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .x(vga_x),
        .y(vga_y)
    );

    // Instanciando o controle das raquetes
    racket raquete1(
        .clk(clk),
        .reset(reset),
        .up(up_p1),
        .down(down_p1),
        .racket_y(raquete1_y)
    );

    racket raquete2(
        .clk(clk),
        .reset(reset),
        .up(up_p2),
        .down(down_p2),
        .racket_y(raquete2_y)
    );

    // Instanciando o controle da bola
    ball bola_inst(
        .clk(clk),
        .reset(reset),
		  //problema aqui
        //.racket1_x(20),              // Raquete 1 está a 20 pixels da borda esquerda
        //.racket1_y(raquete1_y),
        //.racket2_x(620),             // Raquete 2 está a 20 pixels da borda direita (640-20 = 620)
        //.racket2_y(raquete2_y),
		  //fim do problema
        .ball_x(bola_x),
        .ball_y(bola_y)
    );

    // Lógica de exibição na tela (renderização)
    assign display_on = (vga_x >= 0 && vga_x < 640 && vga_y >= 0 && vga_y < 480);

    assign rgb = (display_on && ((vga_x >= 20 && vga_x <= 20 + largura_raquete && 
                                  vga_y >= raquete1_y && vga_y <= raquete1_y + altura_raquete) ||  // Desenha raquete 1
                                 (vga_x >= 620 && vga_x <= 620 + largura_raquete && 
                                  vga_y >= raquete2_y && vga_y <= raquete2_y + altura_raquete) ||  // Desenha raquete 2
                                 (vga_x >= bola_x && vga_x <= bola_x + largura_bola && 
                                  vga_y >= bola_y && vga_y <= bola_y + largura_bola))) ? 
                                  3'b111 : 3'b000; // Branco para objetos, preto para o fundo

endmodule
