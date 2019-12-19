library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Scorebord is
    generic(gBallSize : integer := 5);
    port(AN : out std_logic_vector(7 downto 0);
         CA : out std_logic_vector(0 to 6);
         CLK500HZ : in std_logic;
         CLKLOSE : in std_logic;
         BallposX : in integer range 0 to 640;
         lost : out std_logic);
end Scorebord;

architecture Behavioral of Scorebord is
    
    signal counterC : integer range 0 to 7 := 7;
    signal counterL : integer range 0 to 1000 := 0;
    signal unitsP1 : integer range 0 to 10 := 0;
    signal tensP1 : integer range 0 to 10:= 0;
    signal unitsP2 : integer range 0 to 10 := 0;
    signal tensP2 : integer range 0 to 10:= 0;
    signal scoreP1 : integer range 0 to 100;
    signal scoreP2 : integer range 0 to 100;
    signal lostP1 : std_logic := '0';
    signal lostP2 : std_logic := '0';

    type tSegm is array(0 to 11) of std_logic_vector(6 downto 0);
        constant cSegm : tSegm := ("0000001", -- 0, O
                               "1001111", -- 1
                               "0010010", -- 2
                               "0000110", -- 3
                               "1001100", -- 4
                               "0100100", -- 5, S
                               "0100000", -- 6
                               "0001111", -- 7
                               "0000000", -- 8
                               "0000100", -- 9
                               "0110000", -- E
                               "1110001"); --L

begin

    pScoreSet : process(CLKLOSE)
begin
    if rising_edge(CLKLOSE) then
        if counterL = 0 then
            lostP1 <= '0';
            lostP2 <= '0';
            if scoreP1 >= 25 then
                counterL <= 1;
                lostP1 <= '0';
                lostP2 <= '1';
            elsif scoreP2 >= 25 then
                counterL <= 1;
                lostP1 <= '1';
                lostP2 <= '0';
            elsif BallposX < 7 then
                scoreP2 <= scoreP2 + 1;
            elsif BallposX + gBallSize > 633 then
                scoreP1 <= scoreP1 + 1;
            end if;
        elsif counterL >= 1000 then
            counterL <= 0;
            scoreP1 <= 0;
            scoreP2 <= 0;
            lostP1 <= '0';
            lostP2 <= '0';
        else
            counterL <= counterL + 1;
            scoreP1 <= 0;
            scoreP2 <= 0;
        end if;
    end if;
end process;

    lost <= lostP1 or lostP2;
        
    pSplitScore : process(scoreP1,scoreP2,tensP1,tensP2)
begin
    if scoreP1 > 99 then
        tensP1 <= 10;
    elsif scoreP1 >= 90 then
        tensP1 <= 9;
    elsif scoreP1 >= 80 then
        tensP1 <= 8;
    elsif scoreP1 >= 70 then
        tensP1 <= 7;
    elsif scoreP1 >= 60 then
        tensP1 <= 6;
    elsif scoreP1 >= 50 then
        tensP1 <= 5;
    elsif scoreP1 >= 40 then
        tensP1 <= 4;
    elsif scoreP1 >= 30 then
        tensP1 <= 3;
    elsif scoreP1 >= 20 then
        tensP1 <= 2;
    elsif scoreP1 >= 10 then
        tensP1 <= 1;
    else
        tensP1 <= 0;
    end if;
    
    if scoreP2 > 99 then
        tensP2 <= 10;
    elsif scoreP2 >= 90 then
        tensP2 <= 9;
    elsif scoreP2 >= 80 then
        tensP2 <= 8;
    elsif scoreP2 >= 70 then
        tensP2 <= 7;
    elsif scoreP2 >= 60 then
        tensP2 <= 6;
    elsif scoreP2 >= 50 then
        tensP2 <= 5;
    elsif scoreP2 >= 40 then
        tensP2 <= 4;
    elsif scoreP2 >= 30 then
        tensP2 <= 3;
    elsif scoreP2 >= 20 then
        tensP2 <= 2;
    elsif scoreP2 >= 10 then
        tensP2 <= 1;
    else
        tensP2 <= 0;
    end if;
    
    if scoreP1 < 100 then
        unitsP1 <= scoreP1 - tensP1*10;
        unitsP2 <= scoreP2 - tensP2*10;
    else
        unitsP1 <= 10;
        unitsP2 <= 10;
    end if;
end process;

    pDisplayScores : process(CLK500HZ)
begin
    if rising_edge(CLK500HZ) then
        if counterC <= 0 then
            counterC <= 7;
        else 
            counterC <= counterC - 1;
        end if;
        if  counterL = 0 then
            if counterC = 7 then
                CA <= cSegm(tensP1);
                AN <= (7 => '0', others => '1');
            elsif counterC = 6 then
                CA <= cSegm(unitsP1);
                AN <= (6 => '0', others => '1');
            elsif counterC = 1 then
                CA <= cSegm(tensP2);
                AN <= (1 => '0', others => '1');
            elsif counterC = 0 then
                CA <= cSegm(unitsP2);
                AN <= (0 => '0', others => '1');
            else
                CA <= "1111111";
                AN <= "11111111";
            end if;
        else
            if lostP1 = '1' then
                if counterC = 7 then
                    CA <= cSegm(11);
                    AN <= (7 => '0', others => '1');
                elsif counterC = 6 then
                    CA <= cSegm(0);
                    AN <= (6 => '0', others => '1');
                elsif counterC = 5 then
                    CA <= cSegm(5);
                    AN <= (5 => '0', others => '1');
                elsif counterC = 4 then
                    CA <= cSegm(10);
                    AN <= (4 => '0', others => '1');
                else
                    CA <= "1111111";
                    AN <= "11111111";
                end if;
            elsif lostP2 = '1' then
                if counterC = 3 then
                    CA <= cSegm(11);
                    AN <= (3 => '0', others => '1');
                elsif counterC = 2 then
                    CA <= cSegm(0);
                    AN <= (2 => '0', others => '1');
                elsif counterC = 1 then
                    CA <= cSegm(5);
                    AN <= (1 => '0', others => '1');
                elsif counterC = 0 then
                    CA <= cSegm(10);
                    AN <= (0 => '0', others => '1');
                else
                    CA <= "1111111";
                    AN <= "11111111";
                end if;
            else
                CA <= "1111111";
                AN <= "11111111";
            end if;
        end if;
    end if;
end process;
end Behavioral;