----------------------------------------------------------------------------------
-- Engineer: Luke Merkl
-- 
-- Create Date: 02/27/2018 06:05:19 PM
-- Design Name: Arty Bot
-- Module Name: arty_bot - Behavioral
-- Project Name: 
-- Target Devices: Arty - Artix 7 35T
-- Tool Versions: Vivado 2017.4
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

library myLib;
use myLib.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity arty_bot is
    Port ( CLK100MHZ : in STD_LOGIC;
           LEDR : out STD_LOGIC;
           LEDG : out STD_LOGIC;
           
           LED0 : out STD_LOGIC;
           LED1 : out STD_LOGIC;
           LED2 : out STD_LOGIC;
           LED3 : out STD_LOGIC;
           
           
           MOTOR :  out STD_LOGIC;
           --SERVO : out STD_LOGIC;
           sw : in STD_LOGIC;
           sw2 : in STD_LOGIC;
           btn_u : in STD_LOGIC;
           --btn_rst : in STD_LOGIC;
           btn_d : in STD_LOGIC);
           
end arty_bot;

architecture Behavioral of arty_bot is
    
    constant clk_max : unsigned(31 downto 0) := to_unsigned(10_000, 32);
    --constant clk_div : unsigned(31 downto 0) := to_unsigned(500_000_000, 32);
    constant clk_div1 : unsigned(31 downto 0) := to_unsigned(500_000_000, 32);
    constant clk_div2 : unsigned(31 downto 0) := to_unsigned(50_000_000, 32);
    constant clk_div3 : unsigned(31 downto 0) := to_unsigned(5_000_000, 32);
    
    constant clk_hb : unsigned(31 downto 0) := to_unsigned(500_000_000, 32);
    
    constant tb_ctr : unsigned(31 downto 0) := to_unsigned(50_000_000, 32);
    -- value for test bench. takes too long w real numbers
    
    
    --constant pwm_inc : unsigned(31 downto 0) := to_unsigned(50_000_000, 32);

    
    signal led_en_blink : STD_LOGIC := '0';
    
    signal pulse : STD_LOGIC_VECTOR(2 downto 0) := "001";
    signal duty : STD_LOGIC_VECTOR(7 downto 0) :=  "00000011";
    signal PWM_RST : STD_LOGIC := '1';

    signal ena       :   STD_LOGIC:='1'; 
    signal pwm_n_out : STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal pwm_out : STD_LOGIC_VECTOR(0 DOWNTO 0);
    
    
    --constant pwm_start : unsigned(31 downto 0) := to_unsigned(100_000_000, 32);
    constant pwm_period : unsigned(31 downto 0) := to_unsigned(100_000_000, 32);
    signal pwm_slider : unsigned(31 downto 0) := pwm_period/2;

    
    
    signal up_ctr : unsigned(31 downto 0) := (others => '0');
    signal f_ctr : unsigned(31 downto 0) := (others => '0');

    signal dwn_ctr : unsigned(31 downto 0) := clk_div1;
    
    signal pwm_u_ctr : unsigned(31 downto 0) := (others => '0');
    signal pwm_d_ctr : unsigned(31 downto 0) := clk_div1;
    
    constant bits_resolution : integer := 8;
    constant phases : integer := 1;
    
    component heartbeat
            PORT(   
                    clk  : IN STD_LOGIC;
                    LED_HB : out STD_LOGIC);
            end component heartbeat;
            
    component pwm 
       PORT(
            clk       : IN  STD_LOGIC;                                    --system clock
            reset_n   : IN  STD_LOGIC;                                    --asynchronous reset
            ena       : IN  STD_LOGIC;                                    --latches in new duty cycle
            duty      : IN  STD_LOGIC_VECTOR(bits_resolution-1 DOWNTO 0); --duty cycle
            pwm_out   : OUT STD_LOGIC_VECTOR(phases-1 DOWNTO 0);          --pwm outputs
            pwm_n_out : OUT STD_LOGIC_VECTOR(phases-1 DOWNTO 0));         --pwm inverse outputs
       end component ;
       
     
       

begin
  
     
     U1: pwm port map(                     clk=>CLK100MHZ, 
                                         reset_n=>PWM_RST, 
                                        ena => ena, 
                                        duty => duty, 
                                        pwm_out => pwm_out,
                                         pwm_n_out => pwm_n_out);     
                                         
    U2 : heartbeat port map( clk => CLK100MHZ , LED_HB => LED0 );                           
                                     
    process (CLK100MHZ) is 
    begin
        if (pwm_out(0) = '1') then
            MOTOR <= '1';
         else
            MOTOR <= '0';
         end if;
         
         
         if sw = '0'  and sw2 = '0' then
         
            duty <=  "00000011";
            elsif sw = '1'  and sw2 = '0' then
             duty <=  "00001111";
           elsif sw = '0'  and sw2 = '1' then
               duty <=  "00111111";
            elsif sw = '1'  and sw2 = '1' then
                duty <=  "11111111";
            
         
         end if;
         
         
         
         
         
         
     end process;
    
   
    
    
    blink_led : process(CLK100MHZ) is
    
        variable clk_div : unsigned(31 downto 0) := to_unsigned(500_000_000, 32);

    begin
    
        if sw = '1' and sw2 = '0' then
            clk_div := clk_div2;
        elsif sw2 = '1' and sw = '1' then
            clk_div := clk_div3;
        else
            clk_div := clk_div1;
         end if;
       
        
        if rising_edge(CLK100MHZ)then
            if led_en_blink = '0' then
                up_ctr <= up_ctr+1;
                if up_ctr > clk_div then
                    led_en_blink <= '1';
                    --LEDG <= '1';
                    up_ctr <= (others => '0'); 
                end if;
            elsif led_en_blink = '1' then
                dwn_ctr <= dwn_ctr-1;
                if dwn_ctr < 1 then
                    led_en_blink <= '0';
                    --LEDG <= '0';
                    dwn_ctr <= clk_div; 
                end if;
            end if;
        end if;
            
        if led_en_blink = '1' then    
            LEDG <= '1';
            LEDR <= '0';
        else
            LEDG <= '0';
            LEDR <= '1';
        end if;
    
    end process blink_led;
    

end Behavioral;
