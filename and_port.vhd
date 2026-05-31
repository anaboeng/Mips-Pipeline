----------------------------------------------------------------------------------
-- Project Name:   Mips-Pipeline; 
-- Module Name:    and_port - Structural;
-- Description:    Porta "and" entre a e b;
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and_port is
		
	port(
		a	:	in std_logic;
		b	:	in std_logic;
		data_out	:	out std_logic
	);
	
end and_port;

architecture Behavioral of and_port is

begin

	--eu nao lembro pq deixamos esse not a
	data_out <= (not a) and b;

end Behavioral;

