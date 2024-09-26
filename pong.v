module pong(
    input clk,
    input reset,
    input up_p1, // Entrada para mover raquete 1 para cima
    input down_p1, // Entrada para mover raquete 1 para baixo
    input up_p2, // Entrada para mover raquete 2 para cima
    input down_p2, // Entrada para mover raquete 2 para baixo
    output hsync,
    output vsync,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue
);
    wire [9:0] ball_x, ball_y;
    wire [9:0] racket1_y, racket2_y;
    wire [9:0] vga_x, vga_y;
    wire [1:0] ball_dir;

    ball ball_inst(
        .clk(clk),
        .reset(reset),
        .racket_x(10'd40),  // Posição fixa da raquete 1 (esquerda)
        .racket_y(racket1_y),
        .ball_x(ball_x),
        .ball_y(ball_y),
        .ball_dir(ball_dir)
    );

    // player 1
    racket racket1(
        .clk(clk),
        .reset(reset),
        .up(up_p1),
        .down(down_p1),
        .racket_y(racket1_y)
    );

    // player 2
    racket racket2(
        .clk(clk),
        .reset(reset),
        .up(up_p2),
        .down(down_p2),
        .racket_y(racket2_y)
    );


    vga_controller vga_inst(
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .x(vga_x),
        .y(vga_y)
    );

    // Renderização na tela 
    assign red = ((vga_x == ball_x && vga_y == ball_y) || 
                  (vga_x == 10'd40 && vga_y >= racket1_y && vga_y <= racket1_y + 40) ||
                  (vga_x == 10'd600 && vga_y >= racket2_y && vga_y <= racket2_y + 40)) ? 4'hF : 4'h0;
    assign green = red;
    assign blue = red;

endmodule
