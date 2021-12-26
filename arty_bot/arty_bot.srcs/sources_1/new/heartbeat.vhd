----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/02/2021 06:11:55 PM
-- Design Name: 
-- Module Name: heartbeat - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity heartbeat is
    Port ( clk  : in STD_LOGIC;
           LED_HB : out STD_LOGIC);
end heartbeat;

architecture Behavioral of heartbeat is
    signal pulse : STD_LOGIC_VECTOR(2 downto 0) := "001";


begin
    heartbeat : process (clk) is
        variable hb : unsigned(31 downto 0) := to_unsigned(50_000_000, 32);

    begin
         if pulse = "001" then
               LED_HB <= '0';
         elsif pulse = "010" then 
               LED_HB <= '1';
         elsif pulse = "011" then 
               LED_HB <= '0';
         elsif pulse = "100" then
               LED_HB <= '1';
         end if;
         
        if rising_edge(clk) then
            
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
   
end Behavioral;
