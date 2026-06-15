----------------------------------------------------------------------------------
-- Project Name:   Mips-Pipeline; 
-- Module Name:    datapath_ex - Structural;
-- Description:    Top level do estágio de Execução (EX) do Pipeline com Branch Target;
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Necessário para a operação aritmética de soma do Branch

entity datapath_ex is
    generic (
        W       : integer := 32; -- Tamanho da palavra de dados (padrão 32 bits)
        RegBits : integer := 5   -- Tamanho do endereço do registrador (padrão 5 bits)
    );
    port (
        -- Entradas vindas do registrador ID/EX
        pc_plus_4   : in std_logic_vector(W-1 downto 0);   -- Endereço PC+4 para o cálculo do desvio
        read_data_1 : in std_logic_vector(W-1 downto 0);
        read_data_2 : in std_logic_vector(W-1 downto 0);
        sign_ext    : in std_logic_vector(W-1 downto 0);   -- Imediato com sinal estendido
        rt_addr     : in std_logic_vector(RegBits-1 downto 0); -- Instruction[20-16]
        rd_addr     : in std_logic_vector(RegBits-1 downto 0); -- Instruction[15-11]
        funct       : in std_logic_vector(5 downto 0);         -- Instruction[5-0]
        
        -- Sinais de Controle vindos do ID/EX
        alu_src     : in std_logic;
        alu_op      : in std_logic_vector(1 downto 0);
        reg_dst     : in std_logic;
        
        -- Saídas indo para o registrador EX/MEM
        alu_result      : out std_logic_vector(W-1 downto 0);
        zero_flag       : out std_logic;
        write_reg_addr  : out std_logic_vector(RegBits-1 downto 0);
        branch_target   : out std_logic_vector(W-1 downto 0) -- Endereço final do Branch calculado
    );
end datapath_ex;

architecture Structural of datapath_ex is

    -- Sinais internos (os "fios" que ligam os componentes)
    signal s_alu_ctrl     : std_logic_vector(2 downto 0);
    signal s_alu_in_b     : std_logic_vector(W-1 downto 0);
    signal s_shifted_ext  : std_logic_vector(W-1 downto 0); -- Imediato após o Shift Left 2

begin

    -- =============================================================================
    -- LÓGICA DE CÁLCULO DE BRANCH (Parte superior do diagrama)
    -- =============================================================================
    
    -- 1. Shift Left 2: Desloca 2 bits para a esquerda (multiplica por 4 o offset em palavras)
    -- Descarta os 2 bits mais significativos e injeta "00" na direita
    s_shifted_ext <= sign_ext(W-3 downto 0) & "00";

    -- 2. Somador do Branch Target: Soma PC+4 com o imediato deslocado
    branch_target <= std_logic_vector(unsigned(pc_plus_4) + unsigned(s_shifted_ext));


    -- =============================================================================
    -- LÓGICA DA ULA E COMPONENTES (Parte inferior do diagrama)
    -- =============================================================================

    -- 3. Controle da ULA
    inst_alu_control: entity work.alu_control
        port map (
            alu_op      => alu_op,
            funct       => funct,
            alu_ctrl    => s_alu_ctrl
        );

    -- 4. MUX ALUSrc (Seleciona entre ReadData2 ou Imediato para a entrada B da ULA)
    inst_mux_alusrc: entity work.mux
        generic map ( n => W )
        port map (
            a        => read_data_2,  -- Se alu_src = 0
            b        => sign_ext,     -- Se alu_src = 1
            enable   => alu_src,
            data_out => s_alu_in_b
        );

    -- 5. A ULA do MIPS
    inst_ula: entity work.ULA_MIPS
        generic map ( W => W )
        port map (
            a           => read_data_1,
            b           => s_alu_in_b,     -- Saída do MUX ALUSrc
            alu_control => s_alu_ctrl,     -- Saída do ALU Control
            result      => alu_result,
            zero        => zero_flag
        );

    -- 6. MUX RegDst (Seleciona qual registrador será escrito: rt ou rd)
    inst_mux_regdst: entity work.mux
        generic map ( n => RegBits )
        port map (
            a        => rt_addr,      -- Se reg_dst = 0
            b        => rd_addr,      -- Se reg_dst = 1
            enable   => reg_dst,
            data_out => write_reg_addr
        );

end Structural;