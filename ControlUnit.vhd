----------------------------------------------------------------------------------
-- Project Name:   Mips-Pipeline 
-- Module Name:    unidade_controle - Behavioral
-- Description:    Unidade de controle principal para a arquitetura de 16 bits.
--                 Gera os sinais de controle com base nos 3 bits do OPCODE.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity unidade_controle is
    port(
        opcode      : in  std_logic_vector(2 downto 0); -- Bits [15:13] da instrução
        
        -- Sinais de controle do pipeline
        reg_dst     : out std_logic;
        alu_src     : out std_logic;
        mem_to_reg  : out std_logic;
        reg_write   : out std_logic;
        mem_read    : out std_logic;
        mem_write   : out std_logic;
        alu_op      : out std_logic_vector(1 downto 0)
    );
end unidade_controle;

architecture Behavioral of unidade_controle is
begin
    process(opcode)
    begin
        reg_dst    <= '0';
        alu_src    <= '0';
        mem_to_reg <= '0';
        reg_write  <= '0';
        mem_read   <= '0';
        mem_write  <= '0';
        alu_op     <= "00";

        case opcode is
            when "000" => 
                -- NOP
                null;
                
            when "001" | "010" | "011" => 
                -- ADD, SUB, AND Instruções Tipo R
                reg_dst    <= '1';   -- O destino é o registrador RD
                reg_write  <= '1';   -- Salva o resultado no banco de registradores
                alu_op     <= "10";  -- Avisa o ALU Control para usar o campo FUNC
                
            when "100" => 
                -- LOAD (Tipo I)
                alu_src    <= '1';   -- ULA usa o Imediato
                mem_to_reg <= '1';   -- O dado que vai pro registrador vem da Memória
                reg_write  <= '1';   -- Salva o dado no banco de registradores
                mem_read   <= '1';   -- Habilita leitura da memória
                alu_op     <= "00";  -- ULA faz Soma (Base + Offset)
                
            when "101" => 
                -- STORE (Tipo I)
                alu_src    <= '1';   -- ULA usa o Imediato
                mem_write  <= '1';   -- Habilita escrita na memória
                alu_op     <= "00";  -- ULA faz Soma (Base + Offset)
                
            when "110" => 
                -- ADDI (Tipo I)
                alu_src    <= '1';   -- ULA usa o Imediato
                reg_write  <= '1';   -- Salva o resultado no banco de registradores
                alu_op     <= "00";  -- ULA faz Soma
                
            when others =>
                -- Opcode inválido ou não mapeado
                null;
        end case;
    end process;
end Behavioral;