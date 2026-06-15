library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memoria_instrucoes is
    port(
        address     : in  std_logic_vector(3 downto 0);
        instruction : out std_logic_vector(7 downto 0)
    );
end memoria_instrucoes;

architecture Behavioral of memoria_instrucoes is

    type t_memoria is array (0 to 15) of std_logic_vector(7 downto 0);

    constant memoria : t_memoria := (
        0 => "10010000", -- LOAD  R1, endereço 0
        1 => "10100001", -- LOAD  R2, endereço 1
        2 => "00100100", -- ADD   R2, R1
        3 => "11100010", -- STORE R2, endereço 2
        others => (others => '0')
    );

begin

    instruction <= memoria(to_integer(unsigned(address)));

end Behavioral;