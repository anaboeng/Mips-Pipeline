----------------------------------------------------------------------------------
-- Project Name:   Mips-Pipeline; 
-- Module Name:    banco_registradores - Behavioral;
-- Description:    banco de registradores do processador;
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity banco_registradores is
	generic( 
        n: integer := 32;
        bits_enderecamento: integer := 5
		num_registradores	:	integer := 32
    );

	port(
		reg_write	: in std_logic;
		data_in 		: in std_logic_vector(n-1 downto 0);
		clock			: in std_logic;
		reg_address	: in std_logic_vector(n-1 downto 0);
		r0_out 		: out std_logic_vector(n-1 downto 0);
		data_out		: out std_logic_vector(n-1 downto 0)
	);
	
end banco_registradores;

architecture Behavioral of banco_registradores is

	type t_reg_array is array (0 to num_registradores-1) of std_logic_vector(n-1 downto 0);
    signal s_registradores: t_reg_array := (others => (others => '0'));
begin

    -- processo de escrita
    process(clock)
    begin
        if rising_edge(clock) then
            if reg_write = '1' then
                -- usa apenas os 3 LSBs para acessar os registradores
                s_registradores(to_integer(unsigned(reg_address(bits_enderecamento-1 downto 0)))) <= data_in;
            end if;
        end if;
    end process;

    -- sa�das
    data_out <= s_registradores(to_integer(unsigned(reg_address(bits_enderecamento-1 downto 0))));
    r0_out   <= s_registradores(2);
	 
end Behavioral;

