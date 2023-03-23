library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity gerador_freq is
	port (
        clock 		: in  std_logic;
        nota 		: in  std_logic_vector(11 downto 0);
        toca_nota   : in std_logic;
        saida 		: out std_logic
    );
end entity;
	 
architecture arch of gerador_freq is

	component contador_m_maior is
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

	signal s_notas, tom : std_logic_vector(11 downto 0);
	signal s_notas_not : std_logic_vector(11 downto 0);

begin
    s_notas <= nota;
    s_notas_not <= not s_notas;

	do4 : contador_m_maior
    generic map (
        M => 191110 -- do da quarta oitava
    )
    port map (
        clock   => clock,
        zera_as => s_notas_not(0),
        zera_s  => '0',
        conta   => s_notas(0),
        Q       => open,
        fim     => open,
        meio    => tom(0)
    );

	re4 : contador_m_maior
    generic map (
        M => 170265 -- re da quarta oitava
    )
    port map(
        clock   => clock,
        zera_as => s_notas_not(1),
        zera_s  => '0',
        conta   => s_notas(1),
        Q       => open,
        fim     => open,
        meio    => tom(1)
    );

	mi4 : contador_m_maior
    generic map (
        M => 151685 -- mi da quarta oitava
    )
    port map (
        clock   => clock,
        zera_as => s_notas_not(2),
        zera_s  => '0',
        conta   => s_notas(2),
        Q       => open,
        fim     => open,
        meio    => tom(2)
    );

	fa4 : contador_m_maior
    generic map (
        M => 143172 -- fa da quarta oitava
    )
    port map (
        clock   => clock,
        zera_as => s_notas_not(3),
        zera_s  => '0',
        conta   => s_notas(3),
        Q       => open,
        fim     => open,
        meio    => tom(3)
    );

	sol4 : contador_m_maior
    generic map (
        M => 127551 -- sol da quarta oitava
    )
    port map (
        clock   => clock,
        zera_as => s_notas_not(4),
        zera_s  => '0',
        conta   => s_notas(4),
        Q       => open,
        fim     => open,
        meio    => tom(4)
    );
    
	la4 : contador_m_maior
    generic map (
        M => 113636 -- 50 Mhz / 440 Hz la da quarta oitava
    )
    port map (
        clock   => clock,
        zera_as => s_notas_not(5),
        zera_s  => '0',
        conta   => s_notas(5),
        Q       => open,
        fim     => open,
        meio    => tom(5)
    );

	si4 : contador_m_maior
    generic map (
        M => 101239 -- si da quarta oitava
    )
    port map (
        clock   => clock,
        zera_as => s_notas_not(6),
        zera_s  => '0',
        conta   => s_notas(6),
        Q       => open,
        fim     => open,
        meio    => tom(6)
    );

    do_m4 : contador_m_maior
    generic map (
        M => 180388 -- si da quarta oitava
    )
    port map (
        clock   => clock,
        zera_as => s_notas_not(7),
        zera_s  => '0',
        conta   => s_notas(7),
        Q       => open,
        fim     => open,
        meio    => tom(7)
    );

    re_m4 : contador_m_maior
    generic map (
        M => 160705 -- si da quarta oitava
    )
    port map(
        clock   => clock,
        zera_as => s_notas_not(8),
        zera_s  => '0',
        conta   => s_notas(8),
        Q       => open,
        fim     => open,
        meio    => tom(8)
    );

    fa_m4 : contador_m_maior
    generic map(
        M => 135139 -- si da quarta oitava
    )
    port map (
        clock   => clock,
        zera_as => s_notas_not(9),
        zera_s  => '0',
        conta   => s_notas(9),
        Q       => open,
        fim     => open,
        meio    => tom(9)
    );

    sol_m4 : contador_m_maior
    generic map(
		M => 120395 -- si da quarta oitava
    )
    port map(
		 clock   => clock,
		 zera_as => s_notas_not(10),
		 zera_s  => '0',
		 conta   => s_notas(10),
		 Q       => open,
		 fim     => open,
		 meio    => tom(10)
    );

    la_m4 : contador_m_maior
    generic map(
        M => 107259 -- si da quarta oitava
    )
    port map(
        clock   => clock,
        zera_as => s_notas_not(11),
        zera_s  => '0',
        conta   => s_notas(11),
        Q       => open,
        fim     => open,
        meio    => tom(11)
    );

	saida <= (tom(8) or tom(7) or tom(6) or tom(5) or tom(4) or tom(3) or tom(2) or tom(1) or tom(0) or tom(11) or tom(10) or tom(9)) and toca_nota;
end architecture;
