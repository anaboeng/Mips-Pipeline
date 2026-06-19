----------------------------------------------------------------------------------
-- Project Name:   Mips-Pipeline; 
-- Module Name:    rom - Behavioral
-- Description:    Memória de instruções de 16 bits baseada no Green Card.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity rom is
    generic (
        n: integer := 4;  -- Bits de endereço (16 posições)
        m: integer := 16  -- Tamanho da instrução em bits
    );
    Port ( 
        rom_in  : in  std_logic_vector(n-1 downto 0); -- Vem do PC
        rom_out : out std_logic_vector(m-1 downto 0)  -- Vai para o IF/ID
    );
end rom;

architecture Behavioral of rom is

    type v_instruct is array (0 to (2**n)-1) of std_logic_vector(m-1 downto 0);
    
    -- Exemplo de programa 
    constant rom_content: v_instruct := (
        -- OPCODE(3) | RS(3) | RT(3) | RD/IMM(3/7) | FUNC(4)
        -- 0: ADDI R4, ZERO, 8 
        -- Opcode(110) | RS(100) | RT(000) | Imm(0001000)
        0  => "1101000000001000", 
        
        -- 1: ADDI R5, ZERO, 5 
        -- Opcode(110) | RS(101) | RT(000) | Imm(0000101)
        1  => "1101010000000101", 
        
        -- 2: NOP
        2  => "000000000000000",
        
        -- 3: NOP
        3  => "0000000000000000",
        
        -- 4: SW R4, 0(SP) -> Store Word
        -- Opcode(101) | RS=R4(100) | RT=SP(111) | Imm(0000000)
        4  => "1011001110000000",
        
        -- 5: ADD R1, R4, R5
        -- Opcode(001) | RS(001) | RT(100) | RD(101) | Func(0001)
        5  => "0010011001010001",
        
        -- 6: SUB R2, R4, R5
        -- Opcode(010) | RS(100) | RT(100) | RD(101) | Func(0010)
        6  => "0101001001010010",
        
        -- 7: LW R1, 0(SP) -> Load Word
        -- Opcode(101) | RS=R1(001) | RT=SP(111) | Imm(0000000)
        7  => "1010011110000000",

        others => (others => '0')
    );

begin
    process(rom_in)
    begin
        rom_out <= rom_content(to_integer(unsigned(rom_in)));
    end process;
end Behavioral;