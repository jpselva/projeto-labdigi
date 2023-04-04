library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity serial_controller is
    generic (
        baudrate : integer := 9600
    );
    port (
        clock   : in std_logic;
        clk1khz : in std_logic;
        reset   : in std_logic;
        bytes   : in std_logic_vector(23 downto 0);
        sout    : out std_logic
    );
end serial_controller;

architecture fsm of serial_controller is
    type state_t is (
        inicial, idle, byte1, wait1, byte2, wait2, byte3, wait4, byte4, wait3
    );

    component edge_detector is
        port (
            clock  : in  std_logic;
            reset  : in  std_logic;
            sinal  : in  std_logic;
            pulso  : out std_logic
        );
    end component; 

    component tx is
        generic (baudrate     : integer := 9600);
        port (
            clock		: in  std_logic;							
            reset		: in  std_logic;							
            partida		: in  std_logic;							
            dado		: in  std_logic_vector(7 downto 0);	
            sout		: out std_logic;							
            out_dado	: out std_logic_vector(7 downto 0);	
            pronto		: out std_logic							
        );
    end component;
	 
	 component contador_m is
		 generic (
			  constant M: integer := 100 -- modulo do contador
		 );
		 port (
			  clock   : in  std_logic;
			  zera_as : in  std_logic;
			  zera_s  : in  std_logic;
			  conta   : in  std_logic;
			  Q       : out std_logic_vector(natural(ceil(log2(real(M))))-1 downto 0);
			  fim     : out std_logic;
			  meio    : out std_logic
		 );
	 end component;


    signal Eatual    : state_t;
    signal Eprox     : state_t;
    signal start     : std_logic;
    signal dado      : std_logic_vector(7 downto 0);
    signal tx_pronto : std_logic;
    signal sel_dado  : std_logic_vector(1 downto 0);
    signal tx_partida : std_logic;
	signal zera_cont  : std_logic;
	signal conta_cont : std_logic;
begin
	 COUNT: contador_m
	 generic map (
		   M => 100
	 )
	 port map (
			clock => clk1khz,
			zera_as => zera_cont,
			zera_s => '0',
			conta => conta_cont,
			Q => open,
			fim => start,
			meio => open
	 );

    TRAN: tx
    generic map (
        baudrate => baudrate
    )
    port map (
        clock => clock,
        reset => reset,
        partida => tx_partida,
        dado => dado,
        sout => sout,
        out_dado => open,
        pronto => tx_pronto
    );

    transition: process(clock, reset)
        begin
        if reset = '1' then
            Eatual <= inicial;
        elsif clock'event and clock = '1' then
            Eatual <= Eprox;
        end if;
    end process;

    control: process(Eatual, start, tx_pronto)
        begin
        tx_partida <= '0';
        sel_dado <= "00";
		zera_cont <= '0';
		conta_cont <= '0';

        case Eatual is
        when inicial =>
            zera_cont <= '1';
            Eprox <= idle;
				
        when idle =>
			conta_cont <= '1';
				
            if start = '0' then
                Eprox <= idle;
            else
                Eprox <= byte1;
            end if;

        when byte1 =>
            tx_partida <= '1';
            sel_dado <= "00";

            if tx_pronto = '1' then
                Eprox <= wait1;
            else
                Eprox <= byte1;
            end if;

        when wait1 =>
            if tx_pronto = '0' then
                Eprox <= byte2;
            else
                Eprox <= wait1;
            end if;

        when byte2 =>
            tx_partida <= '1';
            sel_dado <= "01";

            if tx_pronto = '1' then
                Eprox <= wait2;
            else
                Eprox <= byte2;
            end if;

        when wait2 =>
            if tx_pronto = '0' then
                Eprox <= byte3;
            else
                Eprox <= wait2;
            end if;

        when byte3 =>
            tx_partida <= '1';
            sel_dado <= "10";

            if tx_pronto = '1' then
                Eprox <= wait3;
            else
                Eprox <= byte3;
            end if;

        when wait3 =>
            if tx_pronto = '0' then
                Eprox <= byte4;
            else
                Eprox <= wait3;
            end if;

        when byte4 =>
            tx_partida <= '1';
            sel_dado <= "11";

            if tx_pronto = '1' then
                Eprox <= wait4;
            else
                Eprox <= byte4;
            end if;

        when wait4 =>
            if tx_pronto = '0' then
                Eprox <= inicial;
            else
                Eprox <= wait4;
            end if;
        end case;
    end process;

    with sel_dado select dado <=
        bytes(7 downto 0)   when "00",
        bytes(15 downto 8)  when "01",
        bytes(23 downto 16) when "10",
        "00101100"          when "11",
        "00000000"          when others;
end architecture;
