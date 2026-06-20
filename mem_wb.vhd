library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mem_wb is
    port(
        clock : in std_logic;
        reset : in std_logic;

        dado_memoria_in  : in std_logic_vector(3 downto 0);
        resultado_ula_in : in std_logic_vector(3 downto 0);
        operando_in      : in std_logic_vector(3 downto 0);

        reg_write_in : in std_logic;

        dado_memoria_out  : out std_logic_vector(3 downto 0);
        resultado_ula_out : out std_logic_vector(3 downto 0);
        operando_out      : out std_logic_vector(3 downto 0);

        reg_write_out : out std_logic
    );
end mem_wb;

architecture Behavioral of mem_wb is
begin
    process(clock, reset)
    begin
        if reset = '1' then
            dado_memoria_out  <= (others => '0');
            resultado_ula_out <= (others => '0');
            operando_out      <= (others => '0');
            reg_write_out     <= '0';

        elsif rising_edge(clock) then
            dado_memoria_out  <= dado_memoria_in;
            resultado_ula_out <= resultado_ula_in;
            operando_out      <= operando_in;
            reg_write_out     <= reg_write_in;
        end if;
    end process;
end Behavioral;