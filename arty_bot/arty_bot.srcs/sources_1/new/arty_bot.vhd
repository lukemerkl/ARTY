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
    signal PWM_RST : STD_LOGIC := '0';
    
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
    signal btn_u_event : STD_LOGIC := '0';
    signal btn_d_event : STD_LOGIC := '0';
    signal pulse : STD_LOGIC_VECTOR(2 downto 0) := "001";
    signal duty : STD_LOGIC_VECTOR(7 downto 0);

    
    signal btn_ct : unsigned(7 downto 0) := (others=> '0');
    signal i_btn_u : STD_LOGIC := '0';
    signal o_btn_u : STD_LOGIC := '0';
    signal o_btn_lk_u : STD_LOGIC := '0';
    
    signal i_btn_d : STD_LOGIC := '0';
    signal o_btn_d : STD_LOGIC := '0';
    signal o_btn_lk_d : STD_LOGIC := '0';
    signal ena       :   STD_LOGIC:='0'; 
    signal pwm_n_out : STD_LOGIC_VECTOR(0 DOWNTO 0);
    --constant pwm_start : unsigned(31 downto 0) := to_unsigned(100_000_000, 32);
    constant pwm_period : unsigned(31 downto 0) := to_unsigned(100_000_000, 32);
    signal pwm_slider : unsigned(31 downto 0) := pwm_period/2;

    
    
    signal up_ctr : unsigned(31 downto 0) := (others => '0');
    signal f_ctr : unsigned(31 downto 0) := (others => '0');

    signal dwn_ctr : unsigned(31 downto 0) := clk_div1;
    
    signal pwm_u_ctr : unsigned(31 downto 0) := (others => '0');
    signal pwm_d_ctr : unsigned(31 downto 0) := clk_div1;
    
    
        
--    COMPONENT pwm 
--    generic(
--          sys_clk         : INTEGER := 50_000_000; --system clock frequency in Hz
--          pwm_freq        : INTEGER := 100_000;    --PWM switching frequency in Hz
--          bits_resolution : INTEGER := 8;          --bits of resolution setting the duty cycle
--          phases          : INTEGER := 1);         --number of output pwms and phases
    
    
--    port(clk       : IN  STD_LOGIC;                                    --system clock
--          reset_n   : IN  STD_LOGIC;                                    --asynchronous reset
--                 : IN  STD_LOGIC;                                    --latches in new duty cycle
--          duty      : IN  STD_LOGIC_VECTOR(bits_resolution-1 DOWNTO 0); --duty cycle
--          pwm_out   : OUT STD_LOGIC_VECTOR(phases-1 DOWNTO 0);          --pwm outputs
--          pwm_n_out : OUT STD_LOGIC_VECTOR(phases-1 DOWNTO 0));         --pwm inverse outputs
    
--    end component;
-- Component does not seem like the right way to do this.. 
-- trying entity work.pwm

begin
--    state : process(CLK100MHZ)
    U1 : entity work.pwm port map(  clk=>CLK100MHZ, 
                                     reset_n=>PWM_RST, 
                                    ena => ena, 
                                    duty => duty, 
                                     pwm_n_out => pwm_n_out);

    
    heartbeat : process (CLK100MHZ) is
        
        variable hb : unsigned(31 downto 0) := to_unsigned(50_000_000, 32);
    
    begin
    
         if pulse = "001" then
               LED3 <= '0';
         elsif pulse = "010" then 
               LED3 <= '1';
         elsif pulse = "011" then 
               LED3 <= '0';
         elsif pulse = "100" then
               LED3 <= '1';
         end if;
         
        if rising_edge(CLK100MHZ) then
            
            if pulse = "001" then
                hb := hb - 1;
                    if hb = 10_000_000  then
                        --hb := to_unsigned(500000000, 32);
                        pulse <= "010";
                    end if;
             elsif pulse = "010" then
               hb := hb + 1;
               if hb = 30_000_000 then
                   --hb := (others=>'0') ;
                   pulse <= "011";
               end if;
                    
            elsif pulse = "011" then
                hb := hb + 1;
                if hb = 45_000_000 then
                    --hb := (others=>'0') ;
                    pulse <= "100";
                end if;
            
            elsif pulse = "100" then
                hb := hb + 1;
                if hb = 50_000_001 then
                    --hb := (others=>'0') ;
                    pulse <= "001" ;
                end if;
            end if;
            
                
        end if;
                    
        
  
    end process heartbeat;
    
    
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
    
    
   up_btn_db : process(CLK100MHZ, btn_u)  is
    --variable t_db : unsigned(16 downto 0) := to_unsigned(131_072, 17);
    --variable t_db : unsigned(31 downto 0) := to_unsigned(50_000_000, 32);
    variable t_db : unsigned(31 downto 0) := tb_ctr;
    -- tb_ctr is 50
    --variable last_up_state : STD_LOGIC := '0';
    variable btn_en :  STD_LOGIC := '0';
    variable btn_lk :  STD_LOGIC := '0';
   begin
   --btn_u_event <= btn_u;
       if rising_edge(CLK100MHZ) then
           i_btn_u <= btn_u;
           
           o_btn_lk_u <= btn_lk;
           
           if i_btn_u = '1' then
            btn_lk := '1';
            end if;
            
           if btn_lk = '1' then
            t_db := t_db - 1;
            
           end if;
           
           if t_db = 1 then
            o_btn_u <= '1';
            btn_lk := '0';
            t_db := tb_ctr;
           else 
           o_btn_u <= '0';
           end if;
      
      end if;  
      
      btn_u_event <= o_btn_u;
      
      if btn_lk = '1' then
          LED0 <= '1';
         else
          LED0 <= '0';
      end if;
      
   end process up_btn_db;
    
   d_btn_db : process(CLK100MHZ, btn_d)  is
      variable t_db : unsigned(31 downto 0) := tb_ctr;
       -- tb_ctr is 50
       --variable last_up_state : STD_LOGIC := '0';
       variable btn_en :  STD_LOGIC := '0';
       variable btn_lk :  STD_LOGIC := '0';
      begin
      --btn_u_event <= btn_u;
          if rising_edge(CLK100MHZ) then
              i_btn_d <= btn_d;
              o_btn_lk_d <= btn_lk;
              
              if i_btn_d = '1' then
               btn_lk := '1';
               end if;
               
              if btn_lk = '1' then
               t_db := t_db - 1;
              
               
              end if;
              
              if t_db = 1 then
               o_btn_d <= '1';
               btn_lk := '0';
               t_db := tb_ctr;
              else 
              o_btn_d <= '0';
              end if;
         
         end if;  
         
         btn_d_event <= o_btn_d;
         
         if btn_lk = '1' then
             LED1 <= '1';
            else
             LED1 <= '0';
         end if;
         
      end process d_btn_db;  
    
    button_count : process(CLK100MHZ, btn_u_event) is
        
    begin
    
        if rising_edge(CLK100MHZ) then
            if btn_u_event = '1' then
                btn_ct <= btn_ct + 1;
            end if;
        end if;
        
    end process button_count;
    
    pwm_ctl : process(CLK100MHZ, btn_u_event, btn_d_event) is
    
        variable pwm_ct : unsigned(31 downto 0) := pwm_period;
        
        constant pwm_incr : unsigned(31 downto 0) := pwm_period/10;

        constant pwm_tb2 : unsigned(31 downto 0) := pwm_period;

        variable on_off : STD_LOGIC := '1';
        
    begin
    
        if rising_edge(CLK100MHZ) then
            if btn_u_event = '1' then
                pwm_slider <= pwm_slider + pwm_incr;
                --pwm_ct := to_unsigned(50_000_000, 32);
                pwm_ct := pwm_tb2;
            end if;
            if btn_d_event = '1' then
                pwm_slider <= pwm_slider - pwm_incr;
                pwm_ct := pwm_tb2;
            end if;
            
            
            if on_off = '1' then
                pwm_ct := pwm_ct - 1;
                
                if pwm_ct = pwm_slider then
                    on_off := '0';
                end if;
            end if;  
              
            if on_off = '0' then
                pwm_ct := pwm_ct - 1;
                if pwm_ct < 1 then
                    on_off := '1';
                    pwm_ct := pwm_tb2;
                end if;    
            end if;
            
        end if;
        
        if on_off = '1' then
            --MOTOR <= '1';
         else
            --MOTOR <= '0';
        end if;
        
       
    end process pwm_ctl;    
    
    
    


end Behavioral;
