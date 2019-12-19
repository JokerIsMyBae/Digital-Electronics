library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Random is
    generic(seed : std_logic_vector(11 downto 0) := "000000000001");
    port(CLKCOLOR : in std_logic;
         color1 : out std_logic_vector(3 downto 0);
         color2 : out std_logic_vector(3 downto 0);
         color3 : out std_logic_vector(3 downto 0));
end Random;

architecture Behavioral of Random is

    signal lfsr : std_logic_vector(11 downto 0) := seed;

begin

    pRandom : process(CLKCOLOR)
begin
    if rising_edge(CLKCOLOR) then
        for I in 1 to 11 loop
            lfsr(I) <= lfsr(I - 1);
        end loop;
        lfsr(0) <= ((lfsr(11) xor lfsr(8)) xor lfsr(7)) xor lfsr(4);
    end if;
end process;

    pColor : process(lfsr)
begin
    case lfsr(3 downto 0) is
        when "0001" => color1 <= "1011";
        when "0010" => color1 <= "1101";
        when "0100" => color1 <= "0111";
        when "1000" => color1 <= "1110";
        when others => color1 <= lfsr(3 downto 0);
    end case;
    
    case lfsr(7 downto 4) is
        when "0001" => color2 <= "1011";
        when "0010" => color2 <= "1101";
        when "0100" => color2 <= "0111";
        when "1000" => color2 <= "1110";
        when others => color2 <= lfsr(7 downto 4);
    end case;
    
    case lfsr(11 downto 8) is
        when "0001" => color3 <= "1011";
        when "0010" => color3 <= "1101";
        when "0100" => color3 <= "0111";
        when "1000" => color3 <= "1110";
        when others => color3 <= lfsr(11 downto 8);
    end case;
end process;

end Behavioral;