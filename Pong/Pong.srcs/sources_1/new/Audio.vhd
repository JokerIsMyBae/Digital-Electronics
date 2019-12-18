library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Audio is
    generic(gBallSize : integer := 5;
            gBatHeight : integer := 50);
    port(CLKAUD : in std_logic;
         AUD_PWM : out std_logic;
         BallposX : in integer range 0 to 640;
         BallposY : in integer range 0 to 480;
         CLKBALL : in std_logic;
         YposP1 : in integer range 0 to 480;
         YposP2 : in integer range 0 to 480;
         AUD_SD : out std_logic);
end Audio;

architecture Behavioral of Audio is

    signal counter : integer range 0 to 22;
    signal clkset : std_logic := '0';
    signal AUD_SD1 : std_logic := '0';
    signal AUD_SD2 : std_logic := '0';
    signal AUD_SD3 : std_logic := '0';
    signal SD : integer range 0 to 10 := 0;
    signal SD1 : integer range 0 to 30 := 0;
    signal EN : std_logic := '0';

begin

    pCLK : process(CLKAUD)
begin
    if rising_edge(CLKAUD) then
        if counter >= 22 then
            counter <= 0;
            clkset <= not(clkset);
        else
            counter <= counter + 1;
        end if;
    end if;
end process;

    pBallMvmnt : process(CLKBALL)
begin
    if rising_edge(CLKBALL) then
        if BallposX < 7 then -- linkerzijde
            AUD_SD1 <= '0';
            AUD_SD2 <= '0';
            AUD_SD3 <= '1';
        elsif BallposX + gBallSize > 633 then --rechterzijde
            AUD_SD1 <= '0';
            AUD_SD2 <= '0';
            AUD_SD3 <= '1';
        elsif BallposX = 21 
        and (BallposY - gBallSize <= YposP1 and BallposY >= YposP1 - gBatHeight) 
        then -- linkerpalletje
            AUD_SD1 <= '1';
            AUD_SD2 <= '0';
            AUD_SD3 <= '0';
        elsif BallposX + gBallSize = 619 
        and (BallposY - gBallSize <= YposP2 and BallposY >= YposP2 - gBatHeight) 
        then -- rechterpalletje
            AUD_SD1 <= '1';
            AUD_SD2 <= '0';
            AUD_SD3 <= '0';
        elsif BallposY - gBallSize < 7 then -- bovenzijde
            AUD_SD1 <= '0';
            AUD_SD2 <= '1';
            AUD_SD3 <= '0';
        elsif BallposY > 473 then -- onderzijde
            AUD_SD1 <= '0';
            AUD_SD2 <= '1';
            AUD_SD3 <= '0';
        else
            AUD_SD1 <= '0';
            AUD_SD2 <= '0';
            AUD_SD3 <= '0';
        end if;
    end if;
end process;

    pProlong : process(CLKBALL)
begin
    if rising_edge(CLKBALL) then
        if AUD_SD1 = '1' or AUD_SD2 = '1' then
            SD <= 1;
        elsif SD >= 10 then
            SD <= 0;
        elsif SD > 0 then
            SD <= SD + 1;
        else
            SD <= 0;
        end if;
        
        if AUD_SD3 = '1' then
            SD1 <= 1;
        elsif SD1 >= 30 then
            SD1 <= 0;
        elsif SD1 > 0 then
            SD1 <= SD1 + 1;
        else
            SD1 <= 0;
        end if;
    end if;
end process;

    pEnable : process(SD,SD1)
begin
    if SD > 0 or SD1 > 0 then
        EN <= '1';
    else 
        EN <= '0';
    end if;
end process;

    AUD_PWM <= clkset;
    AUD_SD <= AUD_SD1 or AUD_SD2 or EN;

end Behavioral;