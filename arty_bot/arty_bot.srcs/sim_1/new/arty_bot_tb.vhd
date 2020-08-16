----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2018 06:15:35 PM
-- Design Name: 
-- Module Name: arty_bot_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity arty_bot_tb is

end arty_bot_tb;

architecture Behavioral of arty_bot_tb is

    component arty_bot
        Port ( CLK100MHZ : in STD_LOGIC;
               LEDR : out STD_LOGIC;
               LEDG : out STD_LOGIC;
               
               LED0 : out STD_LOGIC;
               LED1 : out STD_LOGIC;
               LED2 : out STD_LOGIC;
               LED3 : out STD_LOGIC;
               
               MOTOR :  out STD_LOGIC;
               sw : in STD_LOGIC;
               sw2 : in STD_LOGIC;
               btn_u : in STD_LOGIC;
               --btn_rst : in STD_LOGIC;
               btn_d : in STD_LOGIC);
    end component;

   constant num_cycles : integer := 16_000_000;
   signal  CLK100MHZ : std_logic := '0';
   signal sw, sw2 : std_logic := '0';
   signal btn_d, btn_u : std_logic := '0';
   signal LEDR, LEDG, LED0 : STD_LOGIC := '0';
   
begin
   UUT: arty_bot port map (CLK100MHZ => CLK100MHZ, sw => sw, sw2 => sw2, btn_u => btn_u, 
   btn_d => btn_d);

    clk : process is
    begin
      for i in 1 to num_cycles loop
        wait for 5 ns;
        CLK100MHZ <= not CLK100MHZ;
        wait for 5 ns;
        CLK100MHZ <= not CLK100MHZ;
        -- clock period = 10 ns
      end loop;
      wait;  -- simulation stops here
    end process clk;

    process
    begin
    
     wait for 30_000_000 ns;
      btn_u <= '1';
--      wait for 200 ns;
--      btn_u <= '0';  
--      wait for 200 ns;
--      btn_u <= '1';
--      wait for 200 ns;
--      btn_u <= '0';  
--      wait for 200 ns;
--      btn_u <= '1';
      wait for 200 ns;
      btn_u <= '0';  
      wait for 30_000_000 ns;
       btn_u <= '1';
       wait for 200 ns;
       btn_u <= '0';  
       wait for 30_000_000 ns;
       
       btn_u <= '1';
       wait for 200 ns;
       btn_u <= '0';  
       wait for 30_000_000 ns;
       
       btn_u <= '1';
      wait for 200 ns;
      btn_u <= '0';  
      wait for 30_000_000 ns;
      
        btn_u <= '1';
        wait for 200 ns;
        btn_u <= '0';  
        wait for 30_000_000 ns;
      
      wait;
     
     
         
    end process ;

end Behavioral;
