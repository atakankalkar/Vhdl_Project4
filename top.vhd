----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:36:53 12/11/2019 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
port(
				clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           data : in  STD_LOGIC;
           led_out : out  STD_LOGIC_VECTOR (7 downto 0);
           seg_out : out  STD_LOGIC_VECTOR (7 downto 0);
           seg_sel : out  STD_LOGIC_VECTOR (7 downto 0)
			  );

end top;

architecture Behavioral of top is
component seven_four is
    Port ( in1 : in  STD_LOGIC_VECTOR (3 downto 0);
           in2 : in  STD_LOGIC_VECTOR (3 downto 0);
           in3 : in  STD_LOGIC_VECTOR (3 downto 0);
           in4 : in  STD_LOGIC_VECTOR (3 downto 0);
			  in5 : in  STD_LOGIC;
			  in6 : in  STD_LOGIC;
			  in7 : in  STD_LOGIC;
			  in8 : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  dp  : out  STD_LOGIC;
           sel : out  STD_LOGIC_VECTOR (7 downto 0);
           segment : out  STD_LOGIC_VECTOR (6 downto 0)
			);
end component;


type state_type is (idle,st1,st2,st3,st4);
signal state_reg,state_next : state_type;
signal counterbirler,counteronlar : std_logic_vector(3 downto 0 ):= "0000";
signal led_shift : std_logic_vector (7 downto 0):="00000000";
signal new_clk : std_logic := '0';
signal dp : std_logic;
signal stater : std_logic_vector(2 downto 0):="000";
signal seg_out_4 :STD_LOGIC_VECTOR(6 downto 0);
signal seg_sel_4 : STD_LOGIC_VECTOR(7 downto 0);

signal ara_deger : STD_LOGIC_VECTOR (31 downto 0) := X"00000000";
begin
A0 : seven_four port map(counterbirler,counteronlar,"0000","0000",stater(0),stater(1),stater(2),'0',clk,dp,seg_sel_4,seg_out_4 ); 

process(clk)
begin
	if (clk = '1' and clk'event) then
 	   
					if(ara_deger<50000000) then
					ara_deger <=  ara_deger + 1;				
					elsif(ara_deger=50000000) then
					new_clk<= not new_clk;
					ara_deger <= x"00000000" ;
					end if;
				
	end if;
			
end process;
	process (new_clk,reset,data,enable,led_shift,state_reg)
		begin
			if(reset ='1') then
				state_reg <= idle;
				led_out <= "00000000";
				led_shift <="00000000";				
			 elsif(enable = '0') then
				led_shift <=led_shift;
				state_reg <= state_reg;
			elsif(new_clk'event and new_clk='1') then
				state_reg <= state_next;
				led_shift <= led_shift(6 downto 0) & data;
				led_out <= led_shift;
			end if;
		end process;
		process(state_reg,data,reset,counterbirler,counteronlar,new_clk)
		begin
			case state_reg is
				when idle=>
					if (data ='1') then
						state_next <= st1;
					else
						state_next <= idle;
					end if;
					stater <= "000";
				when st1 =>
					if(data='1') then
						state_next <= st2;
					else
						state_next <= idle;
					end if;
					stater<= "001";
				when st2=>
					if(data = '0') then
						state_next <= st3;
					else
						state_next <= st2;
					end if;
					stater <= "010";
				when st3 =>
					if(data ='1') then
						state_next <= st4;
					else
						state_next <= idle;
					end if;
					stater <= "011";
				when st4 =>
					if(data = '1') then
						state_next <= st2;
					else
						state_next <= idle;
					end if;
					stater <= "100";
			end case;
			if(state_reg = st4 and new_clk'event and new_clk='1') then		
				if(counterbirler < 9 ) then
				counterbirler <= counterbirler + 1;
				else	
				counterbirler <= "0000";
				counteronlar <= counteronlar+1;
				end if;
				end if;
				if(reset='1') then
				counterbirler<="0000";
				counteronlar<="0000";
				end if;

			
		end process;
		seg_sel <=  seg_sel_4;
		seg_out<=seg_out_4 & dp;
		
		
		

		
		




end Behavioral;

