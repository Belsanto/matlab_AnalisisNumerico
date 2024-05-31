function createUI()
    % Crear la figura de la interfaz
    fig = uifigure('Name', 'Análisis Numérico', 'Position', [100 100 450 350]);
    
    % ComboBox con las opciones
    comboOptions = {'Seleccionar', 'Bisección', 'Punto Fijo', 'Integración Newton (Tabla)', ...
                    'Gauss-Seidel', 'Ajuste Cuadrático', 'Ajuste Exponencial', ...
                    'Derivadas Primera y Segunda Centradas', 'Integral Simpson 3/8', 'RK-3'};
    comboAnalysis = uidropdown(fig, 'Items', comboOptions, 'Position', [20 280 200 22]);
    
    % Botón para ejecutar la opción seleccionada
    btnExecute = uibutton(fig, 'push', 'Text', 'Ejecutar', 'Position', [240 280 100 22]);
    
    % Función que se ejecuta al presionar el botón
    btnExecute.ButtonPushedFcn = @(btn, event) executeOption(comboAnalysis.Value);
end

function executeOption(selectedOption)
    switch selectedOption
        case 'Bisección'
            % Aquí llamar a la función correspondiente para la Bisección
            a_biseccionUI();
            disp('Implementación de Bisección');
        case 'Punto Fijo'
            % Aquí llamar a la función correspondiente para el Punto Fijo
            b_puntoFijoUI();
        case 'Integración Newton (Tabla)'
            % Aquí puedes a la función correspondiente para la Integración Newton
            c_newtonInterpolationUI();
            disp('Implementación de Integración Newton (Tabla)');
        case 'Gauss-Seidel'
            % Aquí llamar a la función correspondiente para Gauss-Seidel
            d_gaussSeidelUI();
            disp('Implementación de Gauss-Seidel');
        case 'Ajuste Cuadrático'
            % Aquí llamar a la función correspondiente para el Ajuste Cuadrático
            e_justeCuadraticoUI();
            disp('Implementación de Ajuste Cuadrático');
        case 'Ajuste Exponencial'
            % Aquí llamar a la función correspondiente para el Ajuste Exponencial
            f_ajusteExponencialUI();
            disp('Implementación de Ajuste Exponencial');
        case 'Derivadas Primera y Segunda Centradas'
            % Aquí llamar a la función correspondiente para las Derivadas Centradas
            g_derivadasUI();
            disp('Implementación de Derivadas Primera y Segunda Centradas');
        case 'Integral Simpson 3/8'
            % Aquí llamar a la función correspondiente para la Integral Simpson 3/8
            h_sinsomp3_8UI();
            disp('Implementación de Integral Simpson 3/8');
        case 'RK-3'
            % Aquí llamar a la función correspondiente para RK-3
            i_rktUI();
            disp('Implementación de RK-3');
        otherwise
            % Opción por defecto: no hacer nada
            disp('Selecciona una opción válida.');
    end
end
