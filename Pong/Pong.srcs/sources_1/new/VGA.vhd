library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA is
    port(CLK100MHZ : in std_logic;
         HS : out std_logic;
         VS : out std_logic;
         Hcounter : out integer range 0 to 800 := 0;
         Vcounter : out integer range 0 to 525 := 0;
         CLK500HZ : out std_logic;
         CLKBALL : out std_logic;
         CLKAUD : out std_logic := '0');
end VGA;

architecture Behavioral of VGA is

    signal Hcounter_set : integer range 0 to 800 := 0;
    signal Vcounter_set : integer range 0 to 525 := 0;
    signal counter1 : std_logic := '0'; 
    signal counter2 : integer range 0 to 100000 := 0;
    signal counter3 : integer range 0 to 250000 := 0;
    signal counter4 : integer range 0 to 1134 := 0;
    signal CLKSET1 : std_logic := '0';
    signal CLKSET2 : std_logic := '0';
    signal CLKSET3 : std_logic := '0';
    signal CLK25MHZ : std_logic := '0';
    signal CLKAUD_set : std_logic := '0';

begin

    pClock : process(CLK100MHZ,CLKSET1,CLKSET2,CLKSET3,CLKAUD_set)
begin
    if rising_edge(CLK100MHZ) then
        counter1 <= not(counter1);
        if counter1 = '1' then
            CLKSET1 <= not(CLKSET1);
        end if;
        if counter2 >= 100000 then
            counter2 <= 0;
            CLKSET2 <= not(CLKSET2);
        else
            counter2 <= counter2 + 1;
        end if;
        if counter3 >= 250000 then
            counter3 <= 0;
            CLKSET3 <= not(CLKSET3);
        else
            counter3 <= counter3 + 1;
        end if;
        if counter4 >= 1134 then
            counter4 <= 0;
            CLKAUD_set <= not(CLKAUD_set);
        else
            counter4 <= counter4 + 1;
        end if;
    end if;
    CLK25MHZ <= CLKSET1;
    CLK500HZ <= CLKSET2;
    CLKBALL <= CLKSET3;
    CLKAUD <= CLKAUD_set;
end process;

    pHcount : process(CLK25MHZ)
begin
    if rising_edge(CLK25MHZ) then
        if Hcounter_set >= 800 then
            Hcounter_set <= 0;
        else 
            Hcounter_set <= Hcounter_set + 1;
        end if;
    end if;
end process;

    pVcount : process(CLK25MHZ)
begin
    if rising_edge(CLK25MHZ) then
        if Vcounter_set >= 525 then
            Vcounter_set <= 0;
        elsif Hcounter_set >= 800 then
            Vcounter_set <= Vcounter_set + 1;
        end if;
    end if;
end process;

    pHsync : process(Hcounter_set)
begin
    if Hcounter_set <= 656 then
        HS <= '1';
    elsif Hcounter_set <= 752 then
        HS <= '0';
    else
        HS <= '1';
    end if;
end process;
    
    pVsync : process(Vcounter_set)
begin
    if Vcounter_set <= 490 then
        VS <= '1';
    elsif Vcounter_set <= 492 then
        VS <= '0';
    else
        VS <= '1';
    end if;
end process;

    Hcounter <= Hcounter_set;
    Vcounter <= Vcounter_set;
    
end Behavioral;