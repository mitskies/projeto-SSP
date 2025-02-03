-------------------------------------------------------------------
-----
-----  ESTADOS: 
-----      - Estado Inicial
-----         = Se todos os sensores estiverem OK -> verde aceso
-----         = Buzzer desligado 
-----         = Motor desligado
-----         = Vermelho e verde apagados
-----      - Estado RUN (Motor ligado)
-----         = Pressionado botão de iniciar
-----         = Led amarelo aceso
-----         = Vermelho e verde apagados
-----      - Falha 
-----         = Vermelho aceso
-----         = Verde e amarelo apagados
-----         = Buzzer ligado
-----         = Aguardando ACKNOWLEDGE (Reconhecimento de alarme | Reset)
-----      - Reset
-----         = Retorna ao estado inicial
-----		  - Chaveamento
-----			  = Buzzer (pino 60_led7)
-----			  = Amarelo(pino 51_led0)
-----			  = Verde(pino 52_led1)
-----			  = Vermelho(pino 57_led5)
-----			  = Motor (pino 58_led6)
-----			  = Reset(pino 50_CH0)
-----			  = Run(pino 48_CH1)
-----			  = Sensor(pino 45_CH2)
-------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Proj_rev2 is
    Port (
        clk : in STD_LOGIC;
        pinSensor : in STD_LOGIC;
        pinRun : in STD_LOGIC;
        pinReset : in STD_LOGIC;
        pinMotor : out STD_LOGIC;
        pinBuzzer : out STD_LOGIC;
        pinledVerde : out STD_LOGIC;
        pinledAmarelo : out STD_LOGIC;
        pinledVermelho : out STD_LOGIC
    );
end Proj_rev2;

architecture Behavioral of Proj_rev2 is

    -- Definição dos estados
    type state_type is (INITIAL, RUN, FAULT, RESET);
    signal current_state, next_state : state_type;

    -- Sinais auxiliares para detectar bordas dos pushbuttons
    signal run_pressed, reset_pressed : std_logic := '0';
    signal run_latched, reset_latched : std_logic := '0';
    
begin

    -- Detecção de borda de subida para `pinRun` e `pinReset`
    process(clk)
    begin
        if rising_edge(clk) then
            -- Detecta borda de subida e armazena o estado
            run_pressed <= pinRun;
            reset_pressed <= pinReset;
            
            -- Latch de `run` se detectar um pulso
            if pinRun = '1' and run_pressed = '0' then
                run_latched <= '1';
            end if;
            
            -- Latch de `reset` se detectar um pulso
            if pinReset = '1' and reset_pressed = '0' then
                reset_latched <= '1';
            end if;
            
            -- Reset manual do latch de `reset`
            if reset_latched = '1' then
                reset_latched <= '0';
                run_latched <= '0'; -- Desativa o latch de run ao resetar
            end if;
        end if;
    end process;

    -- Máquina de estados
    process(clk)
    begin
        if rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Lógica de transição de estados
    process(current_state, pinSensor, run_latched, reset_latched)
    begin
        -- Sinais padrão
        pinMotor <= '0';
        pinBuzzer <= '0';
        pinledVerde <= '0';
        pinledAmarelo <= '0';
        pinledVermelho <= '0';

        if reset_latched = '1' then
            next_state <= INITIAL;
        else
            case current_state is

                -- Estado Inicial
                when INITIAL =>
                    -- Somente o LED verde aceso, motor desligado
                    pinledVerde <= '1';

                    -- Ignora o sensor no estado inicial
                    if run_latched = '1' then
                        next_state <= RUN;
                    else
                        next_state <= INITIAL;
                    end if;

                -- Estado RUN
                when RUN =>
                    pinMotor <= '1';         -- Motor ligado
                    pinledAmarelo <= '1';    -- LED amarelo aceso

                    -- Monitora o sensor para falhas somente no estado RUN
                    if pinSensor = '1' then
                        next_state <= FAULT;
                    else
                        next_state <= RUN;
                    end if;

                -- Estado de Falha
                when FAULT =>
                    pinBuzzer <= '1';        -- Buzzer ligado
                    pinledVermelho <= '1';   -- LED vermelho aceso

                    -- Fica em FAULT até o próximo reset
                    next_state <= FAULT;

                -- Estado de Reset
                when RESET =>
                    next_state <= INITIAL;
                    
            end case;
        end if;
    end process;

end Behavioral;

