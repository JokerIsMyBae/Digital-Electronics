library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Borders is
    generic(gWidth : integer := 5);
    port(Hcounter : in integer range 0 to 800;
         Vcounter : in integer range 0 to 525;
         write_h : out std_logic := '0';
         write_v : out std_logic := '0';
         write_p : out std_logic := '0';
         SW_P : in std_logic);
end Borders;

architecture Behavioral of Borders is

begin

    pHwrite : process(Hcounter) --vertical lines
begin
    if (Hcounter <= gWidth)
    or (Hcounter <= 640 and Hcounter >= 640 - gWidth) 
    or (Hcounter >= 318 and Hcounter <= 322) 
    then
        write_h <= '1';
    else
        write_h <= '0';
    end if;
end process;

    pVwrite : process(Vcounter) --horizontal lines
begin
    if (Vcounter <= gWidth) 
    or (Vcounter >= 480 - gWidth and Vcounter <= 480) 
    then
        write_v <= '1';
    else
        write_v <= '0';
    end if;
end process;
    
    pPauseWrite : process(Hcounter,Vcounter,SW_P)
begin
    if ((Hcounter <=315 and Hcounter >= 300) or (Hcounter >= 325 and Hcounter <= 340)) 
    and (Vcounter <= 260 and Vcounter >= 220) 
    and (SW_P = '1') 
    then
        write_p <= '1';
    else
        write_p <= '0';
    end if;
end process;

end Behavioral;