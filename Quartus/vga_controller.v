module vga_controller(
    input clk,               
    input reset,             
    output reg hsync,        // sinal de sincronização horizontal
    output reg vsync,        // sinal de sincronização vertical
    output reg [9:0] x,      // posição x (horizontal)
    output reg [9:0] y       // posição y (vertical)
);
    // Resolução 640x480 VGA
    parameter H_SYNC_PULSE = 96;
    parameter H_BACK_PORCH = 48;
    parameter H_DISPLAY = 640;
    parameter H_FRONT_PORCH = 16;
    parameter H_TOTAL = H_SYNC_PULSE + H_BACK_PORCH + H_DISPLAY + H_FRONT_PORCH;
    
    parameter V_SYNC_PULSE = 2;
    parameter V_BACK_PORCH = 33;
    parameter V_DISPLAY = 480;
    parameter V_FRONT_PORCH = 10;
    parameter V_TOTAL = V_SYNC_PULSE + V_BACK_PORCH + V_DISPLAY + V_FRONT_PORCH;

    reg [9:0] h_count;
    reg [9:0] v_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_count <= 0;
            v_count <= 0;
            hsync <= 1;
            vsync <= 1;
        end else begin
            // Contador horizontal
            if (h_count == H_TOTAL - 1) begin
                h_count <= 0;
                // Contador vertical
                if (v_count == V_TOTAL - 1) begin
                    v_count <= 0;
                end else begin
                    v_count <= v_count + 1;
                end
            end else begin
                h_count <= h_count + 1;
            end

            // Sinais de sincronização horizontal
            if (h_count < H_SYNC_PULSE)
                hsync <= 0;
            else
                hsync <= 1;

            // Sinais de sincronização vertical
            if (v_count < V_SYNC_PULSE)
                vsync <= 0;
            else
                vsync <= 1;

            // Coordenadas de vídeo
            if ((h_count >= (H_SYNC_PULSE + H_BACK_PORCH)) &&
                (h_count < (H_SYNC_PULSE + H_BACK_PORCH + H_DISPLAY)))
                x <= h_count - (H_SYNC_PULSE + H_BACK_PORCH);
            else
                x <= 0;

            if ((v_count >= (V_SYNC_PULSE + V_BACK_PORCH)) &&
                (v_count < (V_SYNC_PULSE + V_BACK_PORCH + V_DISPLAY)))
                y <= v_count - (V_SYNC_PULSE + V_BACK_PORCH);
            else
                y <= 0;
        end
    end
endmodule
