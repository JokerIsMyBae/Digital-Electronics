--Uitbreidingen: 
--Generics om breedte en lengte van bal, palletjes en randen te bepalen
--lfsr om random color te bepalen van de bal
--Geluidje bij botsingen, langer wanneer er gescoord wordt
--Meest rechtse switch is pauzeknop
--Bij het bereiken van een score van 25 wordt er op het andere display 'LOSE' afgebeeld, en wordt de score gereset
--Meest linkse switch activeert discomodus

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Pong is
    Port(CLK100MHZ : in std_logic;
         BTNU : in std_logic;
         BTNL : in std_logic;
         BTNR : in std_logic;
         BTND : in std_logic;
         AN : out std_logic_vector(7 downto 0);
         CA : out std_logic_vector(0 to 6);
         VGA_R : out std_logic_vector(3 downto 0);
         VGA_G : out std_logic_vector(3 downto 0);
         VGA_B : out std_logic_vector(3 downto 0);
         HS : out std_logic;
         VS : out std_logic;
         AUD_PWM : out std_logic;
         AUD_SD : out std_logic;
         SW_P : in std_logic;
         SW_C : in std_logic);
end Pong;

architecture Behavioral of Pong is

component VGA
    port(CLK100MHZ : in std_logic;
         HS : out std_logic;
         VS : out std_logic;
         Hcounter : out integer range 0 to 800 := 0;
         Vcounter : out integer range 0 to 525 := 0;
         CLK500HZ : out std_logic;
         CLKBALL : out std_logic;
         CLKAUD : out std_logic := '0');
end component;

component Borders
    generic(gWidth : integer := 5);
    port(Hcounter : in integer range 0 to 800;
         Vcounter : in integer range 0 to 525;
         write_h : out std_logic := '0';
         write_v : out std_logic := '0';
         write_p : out std_logic := '0';
         SW_P : in std_logic);
end component;

component PongBat
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
         SW_P : in std_logic);
end component;

component Ball
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
         SW_P : in std_logic);
end component;

component Scorebord
    generic(gBallSize : integer := 5);
    port(AN : out std_logic_vector(7 downto 0);
         CA : out std_logic_vector(0 to 6);
         CLK500HZ : in std_logic;
         CLKBALL : in std_logic;
         BallposX : in integer range 0 to 640);
end component;

component Random
    generic(seed : std_logic_vector(11 downto 0) := "000000000001");
    port(CLKCOLOR : in std_logic;
         color1 : out std_logic_vector(3 downto 0);
         color2 : out std_logic_vector(3 downto 0);
         color3 : out std_logic_vector(3 downto 0));
end component;

component Audio
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
end component;

component Background
    port(CLK100MHZ : in std_logic;
         red_out : out std_logic_vector(3 downto 0);
         green_out : out std_logic_vector(3 downto 0);
         blue_out : out std_logic_vector(3 downto 0));
end component;
         
    signal CLKBALL : std_logic;
    signal CLK500HZ : std_logic;
    signal Hcounter :  integer range 0 to 800;
    signal Vcounter :  integer range 0 to 525;
    signal write_h : std_logic;
    signal write_v : std_logic;
    signal write_p : std_logic;
    signal write_hP12 : std_logic;
    signal write_vP1 : std_logic;
    signal write_vP2 : std_logic;
    signal YposP1 : integer range 0 to 480 := 277;
    signal YposP2 : integer range 0 to 480 := 277;
    signal BallposX : integer range 0 to 640;
    signal BallposY : integer range 0 to 480;
    signal write_ball : std_logic;
    signal color1 : std_logic_vector(3 downto 0);
    signal color2 : std_logic_vector(3 downto 0);
    signal color3 : std_logic_vector(3 downto 0);
    signal CLKCOLOR : std_logic := '0';
    signal CLKAUD : std_logic :='0';
    signal R : std_logic_vector(3 downto 0);
    signal G : std_logic_vector(3 downto 0);
    signal B : std_logic_vector(3 downto 0);
begin

Timings : VGA
    port map(CLK100MHZ => CLK100MHZ,
             HS => HS,
             VS => VS,
             Hcounter => Hcounter,
             Vcounter => Vcounter,
             CLK500HZ => CLK500HZ,
             CLKBALL => CLKBALL,
             CLKAUD => CLKAUD);

Border : Borders
    generic map(gWidth => 5)
    port map(Hcounter => Hcounter,
             Vcounter => Vcounter,
             write_h => write_h,
             write_v => write_v,
             write_p => write_p,
             SW_P => SW_P);
             
Players : PongBat
    generic map(gBatHeight => 50,
                gBatWidth => 5,
                gBatOffset => 16)
    port map(BTNU => BTNU,
             BTNL => BTNL,
             BTNR => BTNR,
             BTND => BTND,
             write_hP12 => write_hP12,
             write_vP1 => write_vP1,
             write_vP2 => write_vp2,
             YposP1 => YposP1,
             YposP2 => YposP2,
             Hcounter => Hcounter,
             Vcounter => Vcounter,
             CLKBALL => CLKBALL,
             SW_P => SW_P);

BallPos : Ball
    generic map(gBallsize => 5,
                gBatHeight => 50)
    port map(BallposX_out => BallposX,
             BallposY_out => BallposY,
             write_ball => write_ball,
             Hcounter => Hcounter,
             Vcounter => Vcounter,
             CLKBALL => CLKBALL,
             YposP1 => YposP1,
             YposP2 => YposP2,
             CLKCOLOR_out => CLKCOLOR,
             SW_P => SW_P);

Score : Scorebord
    generic map(gBallSize => 5)
    port map(AN => AN,
             CA => CA,
             CLK500HZ => CLK500HZ,
             CLKBALL => CLKBALL,
             BallposX => BallposX);
             
RandomColor : Random
    generic map(seed => "000000000001")
    port map(CLKCOLOR => CLKCOLOR,
             color1 => color1,
             color2 => color2,
             color3 => color3);
             
Audiodriver : Audio
    generic map(gBallSize => 5,
                gBatHeight => 50)
    port map(CLKAUD => CLKAUD,
             AUD_PWM => AUD_PWM,
             BallposX => BallposX,
             BallposY => BallposY,
             CLKBALL => CLKBALL,
             YposP1 => YposP1,
             YposP2 => YposP2,
             AUD_SD => AUD_SD);
             
BackgroundColor : Background
    port map(CLK100MHZ => CLK100MHZ,
             red_out => R,
             green_out => G,
             blue_out => B);

    pWrite : process(write_h,write_v,write_p,write_hP12,write_vP1,write_vP2,write_ball,Hcounter,Vcounter,color1,color2,color3,SW_C,R,G,B)
begin
    if Hcounter < 640 and Vcounter < 480 then
        if write_p = '1' then
            VGA_R <= "0000";
            VGA_G <= "1111";
            VGA_B <= "1111";
        elsif write_ball = '1' then
            if SW_C = '1' then
                VGA_R <= "1111";
                VGA_G <= "1111";
                VGA_B <= "1111";
            else
                VGA_R <= color1;
                VGA_G <= color2;
                VGA_B <= color3;
            end if;
        elsif write_h = '1' or write_v = '1' then
            VGA_R <= "1111";
            VGA_G <= "1111";
            VGA_B <= "1111";
        elsif write_hP12 = '1' and write_vP1 = '1' then
            VGA_R <= "0000";
            VGA_G <= "0000";
            VGA_B <= "1111";
        elsif write_hP12 = '1' and write_vP2 = '1' then
            VGA_R <= "1111";
            VGA_G <= "0000";
            VGA_B <= "0000";
        elsif SW_C = '1' then
        
            VGA_R <= R;
            VGA_G <= G;
            VGA_B <= B;
        else
            VGA_R <= "0000";
            VGA_G <= "0000";
            VGA_B <= "0000";
        end if;
    else    
        VGA_R <= "0000";
        VGA_G <= "0000";
        VGA_B <= "0000";
    end if;
end process;

end Behavioral;