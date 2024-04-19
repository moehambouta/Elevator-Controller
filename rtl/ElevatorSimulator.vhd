----------------------------------------------------------------------------------
-- Company:        The Ohio State University
-- Engineer:       Mohamed Hambouta & Trey Willis
-- 
-- Create Date:    16:32:29 04/04/2024 
-- Design Name: 
-- Module Name:    ElevatorSimulator - Behavioral 
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

entity ElevatorSimulator is
	Port ( 
	  POC, SYSCLK : in STD_LOGIC;
	  EMVUP, EMVDN : in STD_LOGIC;
	  EOPEN, ECLOSE : in STD_LOGIC;
	  ECOMP : out STD_LOGIC;
	  EF : out STD_LOGIC_VECTOR (3 downto 0)
	);
end ElevatorSimulator;

architecture Behavioral of ElevatorSimulator is
	signal counter : INTEGER := 0;
	signal floor : INTEGER range 1 to 4 := 1;

	signal busy, command : BOOLEAN :=  false;

	type state_type is (READY, MOVING_UP, MOVING_DOWN, OPENING, CLOSING);
	signal state : state_type := READY;	 
begin

	-- signal that is asserted when elevator is busy
	busy <= not (state = READY);

	-- signal that is asserted when there is a command from the controller
	command <= (EMVUP or EMVDN or EOPEN or ECLOSE) = '1';

	-- since ECOMP needs to be negated immediately when a command is received, it
	-- needs to be asynchronous. only gets asserted when elevator is done "moving".
	ECOMP <= '0' when (command or busy) else '1';

	-- elevator current floor output signal
	EF <= "0001" when floor=1 else
		  "0010" when floor=2 else
		  "0100" when floor=3 else
		  "1000" when floor=4;

	process (SYSCLK, POC) begin
		-- reset system on power on
		if POC = '1' then
			floor <= 1;
			counter <= 0;
			state <= READY;
        
        -- state transitions below
		elsif rising_edge(SYSCLK) then
			case state is
				when READY =>
					counter <= 0;

					if EMVUP = '1' and floor < 4 then
						state <= MOVING_UP;
					elsif EMVDN = '1' and floor > 1 then
						state <= MOVING_DOWN;
					elsif EOPEN = '1' then
						state <= OPENING;
					elsif ECLOSE = '1' then
						state <= CLOSING;
					end if;

				when MOVING_UP =>
					if counter >= 2 then
						floor <= floor + 1;
						state <= READY;
					else
						counter <= counter + 1;
					end if;

				when MOVING_DOWN =>
					if counter >= 2 then
						floor <= floor - 1;
						state <= READY;
					else
						counter <= counter + 1;
					end if;

				when OPENING | CLOSING =>
					if counter >= 4 then
						state <= READY;
					else
						counter <= counter + 1;
					end if;

			end case;
		end if;
	end process;
end Behavioral;
