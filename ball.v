module ball(
    input clk,
    input reset,
    input [9:0] racket_x,   // Posição da raquete no eixo X
    input [9:0] racket_y,   // Posição da raquete no eixo Y
    output reg [9:0] ball_x, // Posição da bola no eixo X
    output reg [9:0] ball_y, // Posição da bola no eixo Y
	 output reg [1:0] ball_dir // Direção da bola: 00 = cima-esquerda, 01 = cima-direita, 10 = baixo-esquerda, 11 = baixo-direita
);
    reg [1:0] direction;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ball_x <= 320; // Posicão inicial, é o centro da tela, ou seja, 640 / 2 = 320
            ball_y <= 240; // posicao inicial é 480 / 2 = 240
            direction <= 2'b11; // Começa indo para (baixo-direita)
        end else begin
            // Movimento da bola baseado na direção
            case(direction)
                2'b00: begin
                    ball_x <= ball_x - 1;
                    ball_y <= ball_y - 1;
                end
                2'b01: begin
                    ball_x <= ball_x + 1;
                    ball_y <= ball_y - 1;
                end
                2'b10: begin
                    ball_x <= ball_x - 1;
                    ball_y <= ball_y + 1;
                end
                2'b11: begin
                    ball_x <= ball_x + 1;
                    ball_y <= ball_y + 1;
                end
            endcase

            // Colisão com as bordas de cima e de baixo
            if (ball_y <= 0)
                direction[1] <= ~direction[1]; // Inverte a direção na vertical
            if (ball_y >= 479)
                direction[1] <= ~direction[1]; // Inverte a direção na vertical

            // Colisão com as raquetes
            if (ball_x <= racket_x && ball_y >= racket_y && ball_y <= (racket_y + 40))
                direction[0] <= ~direction[0]; // Inverte a direção horizontal
        end
    end
endmodule
