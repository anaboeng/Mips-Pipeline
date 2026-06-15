----------------------------------------------------------------------------------
-- Module Name:    alu_control - Behavioral
-- Description:    Decodifica o ALUOp e o campo funct para controlar a ULA
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_control is
    port (
        alu_op      : in  std_logic_vector(1 downto 0); -- Vem da Unidade de Controle Principal
        funct       : in  std_logic_vector(5 downto 0); -- Instruction[5-0]
        alu_ctrl    : out std_logic_vector(2 downto 0)  -- Vai para a ULA
    );
end alu_control;

architecture Behavioral of alu_control is
begin
    process(alu_op, funct)
    begin
        case alu_op is
            when "00" => -- LW / SW (Sempre precisam de Soma para calcular endereço)
                alu_ctrl <= "010"; 
                
            when "01" => -- BEQ (Sempre precisa de Subtração para ver se são iguais)
                alu_ctrl <= "110";
                
            when "10" => -- Tipo R (A operação depende do campo funct)
                case funct is
                    when "100000" => alu_ctrl <= "010"; -- ADD
                    when "100010" => alu_ctrl <= "110"; -- SUB
                    when "100100" => alu_ctrl <= "000"; -- AND
                    when "100101" => alu_ctrl <= "001"; -- OR
                    when others   => alu_ctrl <= "000"; -- Default
                end case;
                
            when others =>
                alu_ctrl <= "000";
        end case;
    end process;
end Behavioral;