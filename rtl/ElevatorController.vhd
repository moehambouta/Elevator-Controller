----------------------------------------------------------------------------------
-- Company:        The Ohio State University
-- Engineer:       Mohamed Hambouta & Trey Willis
-- 
-- Create Date:    16:32:29 04/04/2024 
-- Design Name: 	 
-- Module Name:    ElevatorController - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity ElevatorController is
	Port (
        POC, SYSCLK, ECOMP : in  STD_LOGIC;
        OPEN_DOOR, CLOSE_DOOR : in  STD_LOGIC;
        EF : in  STD_LOGIC_VECTOR (3 downto 0);
        UP_REQ : in  STD_LOGIC_VECTOR (2 downto 0);
        DN_REQ : in  STD_LOGIC_VECTOR (3 downto 1);
        GO_REQ : in  STD_LOGIC_VECTOR (3 downto 0);
        PR_REQ : in  STD_LOGIC_VECTOR (3 downto 0);
        EMVUP, EMVDN, EOPEN, ECLOSE : out  STD_LOGIC;
        FLOOR_IND : out  STD_LOGIC_VECTOR (3 downto 0)
    );
end ElevatorController;

architecture Behavioral of ElevatorController is
    type state_type is (IDLE, MOVING_UP, MOVING_DN);
    signal state : state_type := IDLE;
    
    type door_status_type is (CLOSED, OPENED);
    signal door_status : door_status_type := CLOSED;
    
    signal GU, GD, ODI, ODU, ODD : STD_LOGIC := '0';
    signal DF, UF, REQS: STD_LOGIC_VECTOR (3 downto 0) := "0000";
    
    signal PR_REQS, SYNC_PR_REQS : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal GO_REQS, SYNC_GO_REQS, DONE_REQ : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal UP_REQS, SYNC_UP_REQS, UP_DONE_REQ : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal DN_REQS, SYNC_DN_REQS, DN_DONE_REQ : STD_LOGIC_VECTOR (3 downto 1) := "000";
begin

    GO_REQS <= (SYNC_GO_REQS or GO_REQ) and DONE_REQ; -- go requests accumulator
    UP_REQS <= (SYNC_UP_REQS or UP_REQ) and UP_DONE_REQ; -- up requests accumulator
    DN_REQS <= (SYNC_DN_REQS or DN_REQ) and DN_DONE_REQ; -- down requests accumulator
    PR_REQS <= (SYNC_PR_REQS or PR_REQ) and DONE_REQ; -- priority requests accumulator
    REQS <= ('0' & UP_REQS) or (DN_REQS & '0') or GO_REQS; -- all requests accumulator
    
    -- UP and DN requests to be marked complete under specific conditions
    DONE_REQ <= "1111" when door_status = CLOSED else not (EF);
    UP_DONE_REQ <= "111" when state = MOVING_DN and EF /= "0001" else DONE_REQ(2 downto 0);
    DN_DONE_REQ <= "111" when state = MOVING_UP and EF /= "1000" else DONE_REQ(3 downto 1) ;

    -- signal used to check for requests above
    UF <= "1110" when EF = "0001" else
          "1100" when EF = "0010" else
          "1000" when EF = "0100" else "0000";
    
    -- signal used to check for requests below
    DF <= "0111" when EF = "1000" else
          "0011" when EF = "0100" else
          "0001" when EF = "0010" else "0000";
    
    -- go up signal
    GU <= '1' when (PR_REQS and UF) /= "0000" else
          '1' when PR_REQS = "0000" and (REQS and UF) /= "0000" else '0';
    
    -- go down signal
    GD <= '1' when (PR_REQS and DF) /= "0000" else
          '1' when PR_REQS = "0000" and (REQS and DF) /= "0000" else '0';
    
    -- open door signal for IDLE state
    ODI <= '1' when (PR_REQS and EF) /= "0000" else
           '1' when PR_REQS = "0000" and (REQS and EF) /= "0000" else '0';

    -- open door signal for UP state
    ODU <= '1' when (PR_REQS and EF) /= "0000" else
           '1' when PR_REQS = "0000" and ((GO_REQS or ('0' & UP_REQS)) and EF) /= "0000" else '0';
    
    -- open door signal for DOWN state
    ODD <= '1' when (PR_REQS and EF) /= "0000" else
           '1' when PR_REQS = "0000" and ((GO_REQS or (DN_REQS & '0')) and EF) /= "0000" else '0';

    FLOOR_IND <= EF; -- floor indicator output assignment

    process (SYSCLK, POC) begin
        -- reset system on power on
        if POC = '1' then
            state <= IDLE;
            door_status <= CLOSED;
            SYNC_DN_REQS <= "000";
            SYNC_UP_REQS <= "000";
            SYNC_GO_REQS <= "0000";
            SYNC_PR_REQS <= "0000";

        elsif rising_edge(SYSCLK) then
            -- clear commands sent to simulator every clock cycle
            EMVUP <= '0';
            EMVDN <= '0';
            EOPEN <= '0';
            ECLOSE <= '0';
        
            -- synchronize previous register values every clock cycle
            SYNC_DN_REQS <= DN_REQS;
            SYNC_UP_REQS <= UP_REQS;
            SYNC_GO_REQS <= GO_REQS;
            SYNC_PR_REQS <= PR_REQS;
        
            -- perform logic once simulator is not busy (when ECOMP = '1')
            if ECOMP = '1' then
            
                -- close door if open and send appropriate control signals
                if (door_status = OPENED or CLOSE_DOOR = '1') and (OPEN_DOOR = '0') then
                    ECLOSE <= '1';
                    door_status <= CLOSED;
                
                -- move up, move down, or open door logic checks done below
                elsif door_status = CLOSED then
                    case state is
                        when IDLE =>
                            if ODI = '1' or OPEN_DOOR = '1' then
                                EOPEN <= '1';
                                door_status <= OPENED;
                            elsif GU = '1' then
                                state <= MOVING_UP;
                            elsif GD = '1' then
                                state <= MOVING_DN;
                            end if;

                        when MOVING_UP =>
                            if ODU = '1' or OPEN_DOOR = '1' then
                                EOPEN <= '1';
                                door_status <= OPENED;
                            elsif GU = '1' then
                                EMVUP <= '1';
                            elsif GD = '1' then
                                state <= MOVING_DN;
                            else
                                state <= IDLE;
                            end if;
                        
                        when MOVING_DN =>
                            if ODD = '1' or OPEN_DOOR = '1' then
                                EOPEN <= '1';
                                door_status <= OPENED;
                            elsif GD = '1' then
                                EMVDN <= '1';
                            elsif GU = '1' then
                                state <= MOVING_UP;
                            else
                                state <= IDLE;
                            end if;
                    end case;
                
                end if;
            end if;
        end if;
    end process;
end Behavioral;
