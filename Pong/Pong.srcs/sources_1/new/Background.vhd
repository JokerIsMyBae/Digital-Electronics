library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Background is
    port(CLK100MHZ : in std_logic;
         red_out : out std_logic_vector(3 downto 0);
         green_out : out std_logic_vector(3 downto 0);
         blue_out : out std_logic_vector(3 downto 0));
end Background;

architecture Behavioral of Background is

    signal counter : integer range 0 to 1000 := 0;
    signal CLK : std_logic;
    signal red : unsigned(3 downto 0) := "1111";
    signal green : unsigned(3 downto 0);
    signal blue : unsigned(3 downto 0);
    signal counter1 : integer range 0 to 15;
    signal counter2 : integer range 0 to 2;
    

begin

    pClock : process(CLK100MHZ)
begin
    if rising_edge(CLK100MHZ) then
        if counter >= 2000 then
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
        if counter2 = 2 and counter1 = 15 then
            counter2 <= 0;
            counter1 <= 0;
        elsif counter1 >= 15 then
            counter1 <= 0;
            counter2 <= counter2 + 1;
        else
            counter1 <= counter1 + 1;
        end if;
    end if;
end process;

    pColors : process(CLK)
begin
    if rising_edge(CLK) then
        if  counter2 = 0 then
            red <= to_unsigned(counter1,4);
            blue <= blue - 1;
        elsif counter2 = 1 then
            green <= to_unsigned(counter1,4);
            red <= red - 1;
        elsif counter2 = 2 then
            blue <= to_unsigned(counter1,4);
            green <= green - 1;
        else
            red <= "0000";
            green <= "0000";
            blue <= "0000";
        end if;
    end if;
end process;

    red_out <= std_logic_vector(red);
    green_out <= std_logic_vector(green);
    blue_out <= std_logic_vector(blue);

end Behavioral;