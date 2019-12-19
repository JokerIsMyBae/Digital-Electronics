library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Background is
    port(CLK100MHZ : in std_logic;
         red_out : out std_logic_vector(3 downto 0);
         green_out : out std_logic_vector(3 downto 0);
         blue_out : out std_logic_vector(3 downto 0);
         SW_P : in std_logic);
end Background;

architecture Behavioral of Background is

    signal counter : integer range 0 to 3000000 := 0;
    signal CLK : std_logic;
    signal red : unsigned(3 downto 0) := "1111";
    signal green : unsigned(3 downto 0);
    signal blue : unsigned(3 downto 0);
    signal counter1 : integer range 0 to 2 := 0;
    
begin

    pClock : process(CLK100MHZ)
begin
    if rising_edge(CLK100MHZ) then
        if counter >= 2525000 then
            counter <= 0;
            CLK <= not(CLK);
        else
            counter <= counter + 1;    
        end if;
    end if;
end process;

    pChooseColor : process(CLK)
begin
    if rising_edge(CLK) then      
        if SW_P = '0' then
            if counter1 = 0 then
                red <= red + 1;
                blue <= blue - 1;
                if red = "1110" then
                    counter1 <= 1;
                end if;
            elsif counter1 = 1 then
                green <= green + 1;
                red <= red - 1;
                if green = "1110" then
                    counter1 <= 2;
                end if;
            elsif counter1 = 2 then
                blue <= blue + 1;
                green <= green - 1;
                if blue = "1110" then
                    counter1 <= 0;
                end if;
            end if;
        end if;
    end if;
end process; 

    red_out <= std_logic_vector(red);
    green_out <= std_logic_vector(green);
    blue_out <= std_logic_vector(blue);

end Behavioral;