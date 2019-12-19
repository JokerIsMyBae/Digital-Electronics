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
         SW_P : in std_logic;
         lost : in std_logic;
         SW_AI1 : in std_logic;
         SW_AI2 : in std_logic); 
end PongBat;

architecture Behavioral of PongBat is

    signal YposP1_set : integer range 0 to 480 := 265;
    signal YposP2_set : integer range 0 to 480 := 265;
    signal toggleD1 : std_logic := '0';
    signal toggleD2 : std_logic := '1';

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
    if SW_AI2 = '1' then
        if SW_P = '0' and lost = '0' then
            if YposP1_set >= 473 then
                toggleD2 <= '1';
                YposP1_set <= YposP1_set - 1;
            elsif YposP1_set - gBatHeight <= 7 then
                toggleD2 <= '0';
                YposP1_set <= YposP1_set + 1;
            elsif toggleD2 = '0' then
                YposP1_set <= YposP1_set + 1;
            elsif toggleD2 = '1' then
                YposP1_set <= YposP1_set - 1;
            end if;
        end if;
    else
        if YposP1_set - gBatHeight > 7 then
            if SW_P = '0' and lost = '0' then 
                if BTNL = '1' then
                    YposP1_set <= YposP1_set - 1;
                end if;
            end if;
        end if;
        
        if YposP1_set < 473 then
            if SW_P = '0' and lost = '0' then
                if BTND = '1' then
                    YposP1_set <= YposP1_set + 1;
                end if;
            end if;
        end if;
    end if;
end if;
end process;

    pPlayer2 : process(CLKBALL) -- set location and height of bat player 2 / AI
begin
if rising_edge(CLKBALL) then
    if SW_AI1 = '1' then
        if SW_P = '0' and lost = '0' then
            if YposP2_set >= 473 then
                toggleD1 <= '1';
                YposP2_set <= YposP2_set - 1;
            elsif YposP2_set - gBatHeight <= 7 then
                toggleD1 <= '0';
                YposP2_set <= YposP2_set + 1;
            elsif toggleD1 = '0' then
                YposP2_set <= YposP2_set + 1;
            elsif toggleD1 = '1' then
                YposP2_set <= YposP2_set - 1;
            end if;
        end if;
    else
        if YposP2_set - gBatHeight > 7 then
            if SW_P = '0' and lost = '0' then
                if BTNU = '1' then
                    YposP2_set <= YposP2_set - 1;
                end if;
            end if;
        end if;
        
        if YposP2_set < 473 then
            if SW_P = '0' and lost = '0' then
                if BTNR = '1' then
                    YposP2_set <= YposP2_set + 1;
                end if;
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
