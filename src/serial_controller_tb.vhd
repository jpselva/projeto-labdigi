library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial_controller_tb is
end entity serial_controller_tb;

architecture nice of serial_controller_tb is

    component serial_controller is
        port (
            clock   : in std_logic;
            clk1khz : in std_logic;
            reset   : in std_logic;
            bytes   : in std_logic_vector(23 downto 0);
            sout    : out std_logic
        );
    end component;

    signal clock     : std_logic;
    signal clock1khz : std_logic;
    signal reset     : std_logic;
    signal bytes     : std_logic_vector(23 downto 0);
    signal sout      : std_logic;

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock1 : std_logic := '0';
    signal TbClock2 : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
begin
    -- Clock generation
    TbClock1 <= not TbClock1 after TbPeriod/2 when TbSimEnded /= '1' else '0';
    TbClock2 <= not TbClock2 after TbPeriod/20 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clock is really your main clock signal

    DUT: serial_controller
    port map (
        clock => TbClock2,
        clk1khz => TbClock1,
        reset => reset,
        bytes => bytes,
        sout => sout
    );

    BRUH: process
    begin
        reset <= '1';
        bytes <= "000000000000000000000000";
        wait for 2*TbPeriod;

        reset <= '0';
        wait for TbPeriod;

        bytes <= "00000001"&"00000010"&"00000011";
        wait for 600*TbPeriod;
        wait;   
    end process;
end architecture;