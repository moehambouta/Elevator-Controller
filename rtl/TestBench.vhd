--------------------------------------------------------------------------------
-- Company:         The Ohio State University
-- Engineer:        Mohamed Hambouta & Trey Willis
--
-- Create Date:
-- Design Name:   
-- Module Name:
-- Project Name:
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ElevatorController
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TestBench IS
END TestBench;

ARCHITECTURE behavior OF TestBench IS 
 
    COMPONENT ElevatorController
    Port (
        POC, SYSCLK, ECOMP : in  STD_LOGIC;
        EF : in  STD_LOGIC_VECTOR (3 downto 0);
        OPEN_DOOR, CLOSE_DOOR : in  STD_LOGIC;
        UP_REQ : in  STD_LOGIC_VECTOR (2 downto 0);
        DN_REQ : in  STD_LOGIC_VECTOR (3 downto 1);
        GO_REQ : in  STD_LOGIC_VECTOR (3 downto 0);
        PR_REQ : in  STD_LOGIC_VECTOR (3 downto 0);
        EMVUP, EMVDN, EOPEN, ECLOSE : out  STD_LOGIC;
        FLOOR_IND : out  STD_LOGIC_VECTOR (3 downto 0)
    );
    END COMPONENT;
 
    COMPONENT ElevatorSimulator
    PORT (
        POC : IN  std_logic;
        SYSCLK : IN  std_logic;
        EMVUP : IN  std_logic;
        EMVDN : IN  std_logic;
        EOPEN : IN  std_logic;
        ECLOSE : IN  std_logic;
        ECOMP : OUT  std_logic;
        EF : OUT  std_logic_vector(3 downto 0)
    );
    END COMPONENT;

    --controller inputs
    signal UP_REQ : std_logic_vector(2 downto 0) := (others => '0');
    signal DN_REQ : std_logic_vector(3 downto 1) := (others => '0');
    signal GO_REQ : std_logic_vector(3 downto 0) := (others => '0');
    signal PR_REQ : std_logic_vector(3 downto 0) := (others => '0');
    signal OPEN_DOOR, CLOSE_DOOR : std_logic := '0';
    signal POC : std_logic := '1';
    signal SYSCLK : std_logic := '0';
    signal ECOMP : std_logic := '0';
    signal EF : std_logic_vector(3 downto 0) := (others => '0');

    --controller outputs
    signal EMVUP : std_logic := '0';
    signal EMVDN : std_logic := '0';
    signal EOPEN : std_logic := '0';
    signal ECLOSE : std_logic := '0';
    signal FLOOR_IND : std_logic_vector(3 downto 0);

    -- Clock period definitions
    constant SYSCLK_period : time := 500 ms;

BEGIN

    uut0: ElevatorController PORT MAP (
        EF => EF,
        POC => POC,
        ECOMP => ECOMP,
        EMVUP => EMVUP,
        EMVDN => EMVDN,
        EOPEN => EOPEN,
        ECLOSE => ECLOSE,
        UP_REQ => UP_REQ,
        DN_REQ => DN_REQ,
        GO_REQ => GO_REQ,
        PR_REQ => PR_REQ,
        SYSCLK => SYSCLK,
        FLOOR_IND => FLOOR_IND,
        OPEN_DOOR => OPEN_DOOR,
        CLOSE_DOOR => CLOSE_DOOR
    );

    uut1: ElevatorSimulator PORT MAP (
        EF => EF,
        POC => POC,
        ECOMP => ECOMP,
        EMVUP => EMVUP,
        EMVDN => EMVDN,
        EOPEN => EOPEN,
        ECLOSE => ECLOSE,
        SYSCLK => SYSCLK
    );

    -- Clock process definitions
    clk_proc: process
    begin
        SYSCLK <= '1';
        wait for SYSCLK_period/2;
        SYSCLK <= '0';
        wait for SYSCLK_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
        alias REQS is <<signal uut0.REQS : STD_LOGIC_VECTOR(3 downto 0)>>;
    begin		
        wait for SYSCLK_period;
        POC <= '0';
        wait for SYSCLK_period * 2;
    
        -- Provided test sequence
        UP_REQ(2) <= '1';
        wait for SYSCLK_period * 2;
        UP_REQ(2) <= '0';
        
        UP_REQ(0) <= '1';
        wait for SYSCLK_period * 2;
        UP_REQ(0) <= '0';
        
        DN_REQ(3) <= '1';
        wait for SYSCLK_period * 2;
        DN_REQ(3) <= '0';
        
        GO_REQ(1) <= '1';
        wait for SYSCLK_period * 2;
        GO_REQ(1) <= '0';
        
        -- Open / close door test
        wait until REQS = "0000";
        wait until ECLOSE = '1';
        wait until ECOMP = '1';
        
        UP_REQ(2) <= '1';
        wait for SYSCLK_period * 2;
        UP_REQ(2) <= '0';
    
        OPEN_DOOR <= '1';
        wait for SYSCLK_period * 16;
        OPEN_DOOR <= '0';
        
        -- Priority calls test
        wait until REQS = "0000";
        wait until ECLOSE = '1';
        wait until ECOMP = '1';
        
        UP_REQ(0) <= '1';
        wait for SYSCLK_period * 2;
        UP_REQ(0) <= '0';
        
        PR_REQ(3) <= '1';
        wait for SYSCLK_period * 2;
        PR_REQ(3) <= '0';

        -- All requests at once test
        wait until REQS = "0000";
        wait until ECLOSE = '1';
        wait until ECOMP = '1';
        
        UP_REQ <= "111";
        DN_REQ <= "111";
        GO_REQ <= "1111";
        wait for SYSCLK_period * 2;
        UP_REQ <= "000";
        DN_REQ <= "000";
        GO_REQ <= "0000";
    
        wait;
    end process;
END;
