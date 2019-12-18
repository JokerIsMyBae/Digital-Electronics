library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PongBat is
    generic(gBatHeight : integer := 50;
            gBatWidth : integer := 5;
            gBatOffset : integer := 16);
    port(BTNU : in std_logic;
         BTNL : in std_logic;
         BTNR : in std_logic;
         BTND : in std_logic;
         write_hP12 : out std_logic;
         write_vP1 : out std_logic;
         write_vP2 : out std_logic;
         YposP1 : out integer range 0 to 480;
         YposP2 : out integer range 0 to 480;
         Hcounter : in integer range 0 to 799 := 0;
         Vcounter : in integer range 0 to 524 := 0;
         CLKBALL : in std_logic;
         SW_P : in std_logic); -- pauzeknop
end PongBat;

architecture Behavioral of PongBat is

    signal YposP1_set : integer range 0 to 480 := 265;
    signal YposP2_set : integer range 0 to 480 := 265;

begin

    pHorizontal : process(Hcounter) -- set width bats
begin
    if (Hcounter >= gBatOffset and Hcounter <= gBatOffset + gBatWidth) 
    or (Hcounter >= 640 - gBatOffset - gBatWidth and Hcounter <= 640 - gBatOffset) 
    then
        write_hP12 <= '1';
    else    
        write_hP12 <= '0';
    end if;
end process;

    pPlayer1 : process(CLKBALL) -- set location and height of bat player 1
begin
if rising_edge(CLKBALL) then
    if YposP1_set - gBatHeight > 7 then
        if SW_P = '0' then 
            if BTNL = '1' then
                YposP1_set <= YposP1_set - 1;
            end if;
        end if;
    end if;
    
    if YposP1_set < 473 then
        if SW_P = '0' then
            if BTND = '1' then
                YposP1_set <= YposP1_set + 1;
            end if;
        end if;
    end if;
end if;
end process; 

    pPlayer2 : process(CLKBALL) -- set location and height of bat player 2
begin
if rising_edge(CLKBALL) then
    if YposP2_set - gBatHeight > 7 then
        if SW_P = '0' then
            if BTNU = '1' then
                YposP2_set <= YposP2_set - 1;
            end if;
        end if;
    end if;
    
    if YposP2_set < 473 then
        if SW_P = '0' then
            if BTNR = '1' then
                YposP2_set <= YposP2_set + 1;
            end if;
        end if;
    end if;
end if;
end process;

    pWrite : process(Vcounter,Hcounter,YposP1_set,YposP2_set)
begin
    if (Vcounter >= YposP1_set - gBatHeight) 
    and (Vcounter <= YposP1_set) 
    and (Hcounter >= 16 and Hcounter <= 21) 
    then
        write_vP1 <= '1';
    else
        write_vP1 <= '0';
    end if;    
    if (Vcounter >= YposP2_set - gBatHeight) 
    and (Vcounter <= YposP2_set) 
    and (Hcounter >= 619 and Hcounter <= 624)  
    then
        write_vP2 <= '1';
    else
        write_vP2 <= '0';
    end if;
end process;

    YposP1 <= YposP1_set;
    YposP2 <= YposP2_set;

end Behavioral;
