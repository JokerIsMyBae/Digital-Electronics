library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Ball is
    generic(gBallSize : integer := 5;
            gBatHeight : integer := 50);
    port(BallposX_out : out integer range 0 to 640; 
         BallposY_out : out integer range 0 to 480;
         write_ball : out std_logic; 
         Hcounter : in integer range 0 to 800;
         Vcounter : in integer range 0 to 525;
         CLKBALL : in std_logic;
         YposP1 : in integer range 0 to 480;
         YposP2 : in integer range 0 to 480;
         CLKCOLOR_out : out std_logic;
         SW_P : in std_logic;
         lost : in std_logic);
end Ball;


-- VERANDERT TE WEINIG VAN KLEUR

architecture Behavioral of Ball is

    signal ballposX : integer range 0 to 640 := 318;
    signal ballposY : integer range 0 to 480 := 238;
    signal toggleX : std_logic := '0'; 
    signal toggleY : std_logic := '0';
    signal CLKCOLOR : std_logic := '0';

begin


    pBallMvmnt : process(CLKBALL)
begin
    if rising_edge(CLKBALL) then
        CLKCOLOR <= '0';
        if SW_P = '1' or lost = '1' then
            BallposX <= BallposX;
            BallposY <= BallposY;
            toggleX <= toggleX;
            toggleY <= toggleY;
        else
            if BallposX < 7 then
                BallposX <= 318;
                toggleX <= not(toggleX);
                CLKCOLOR <= '1';
            elsif BallposX + gBallSize > 633 then
                BallposX <= 318;
                toggleX <= not(toggleX);
                CLKCOLOR <= '1';
            elsif BallposX = 21 
            and (BallposY - gBallSize <= YposP1 and BallposY >= YposP1 - gBatHeight) 
            then 
                toggleX <= not(toggleX);    
                BallposX <= BallposX + 1;
                CLKCOLOR <= '1';
            elsif BallposX + gBallSize = 619 
            and (BallposY - gBallSize <= YposP2 and BallposY >= YposP2 - gBatHeight) 
            then 
                toggleX <= not(toggleX);
                BallposX <= BallposX - 1;
                CLKCOLOR <= '1';
            else
                if (toggleX = '0') then 
                    BallposX <= BallposX + 1;
                elsif (toggleX = '1') then 
                    BallposX <= BallposX - 1;
                end if;
            end if;
            
            if BallposY - gBallSize < 7 then 
                toggleY <= not(toggleY);   
                BallposY <= BallposY + 1;
                CLKCOLOR <= '1';
            elsif BallposY > 473 then 
                toggleY <= not(toggleY); 
                BallposY <= BallposY - 1;
                CLKCOLOR <= '1';
            else
                if (toggleY = '0') then 
                    BallposY <= BallposY + 1;
                elsif (toggleY = '1') then 
                    BallposY <= BallposY - 1;
                end if;
            end if;
        end if;
    end if;
end process;

    pWrite : process(BallposX,BallposY,Hcounter,Vcounter)
begin
    if (Hcounter >= BallposX and Hcounter <= BallposX + gBallsize) 
    and (Vcounter <= BallposY and Vcounter >= BallposY - gBallsize) 
    then
        write_ball <= '1';
    else
        write_ball <= '0';
    end if;
end process;

    BallposX_out <= BallposX;
    BallposY_out <= BallposY;
    CLKCOLOR_out <= CLKCOLOR;

end Behavioral;