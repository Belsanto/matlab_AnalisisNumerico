function createUI()
    % Crear la figura de la interfaz
    fig = uifigure('Name', 'Calculadora de Punto Fijo Multivariable', 'Position', [100 100 450 350]);
    
    % Etiqueta y campo de entrada para la ecuación
    lblEquation = uilabel(fig, 'Text', 'Ecuación:', 'Position', [20 280 100 22]);
    txtEquation = uieditfield(fig, 'text', 'Position', [130 280 290 22]);
    
    % Etiqueta y campo de entrada para el límite de iteraciones
    lblIterations = uilabel(fig, 'Text', 'Límite Iteraciones:', 'Position', [20 240 100 22]);
    txtIterations = uieditfield(fig, 'numeric', 'Position', [130 240 100 22]);
    
    % Botón para calcular la solución
    btnCalculate = uibutton(fig, 'push', 'Text', 'Calcular Solución', 'Position', [130 200 150 22]);
    
    % Etiqueta para mostrar el resultado
    lblResult = uilabel(fig, 'Text', 'Solución:', 'Position', [20 160 400 22], 'FontWeight', 'bold');
    
    % Función que se ejecuta al presionar el botón
    btnCalculate.ButtonPushedFcn = @(btn, event) calculateSolution(txtEquation, txtIterations, lblResult);
end

function calculateSolution(txtEquation, txtIterations, lblResult)
    % Obtener los valores de los campos de entrada
    equationStr = txtEquation.Value;
    limitIterations = txtIterations.Value;
    
    % Convertir la cadena de la ecuación en una función manejable
    ecuacion = str2func(['@(x)' equationStr]);
    
    % Llamar a la función ecuaciones_punto_fijo
    solucion = ecuaciones_punto_fijo(ecuacion, limitIterations);
    
    % Mostrar el resultado
    lblResult.Text = ['Solución: ' num2str(solucion)];
end

function [solucion] = ecuaciones_punto_fijo(ecuacion, limite_iteraciones)
    % Inicialización de variables
    x = zeros(size(ecuacion(0))); % Asumimos una aproximación inicial de ceros
    iter = 0;
    error = inf;
    
    while iter < limite_iteraciones && error > 1e-6
        x_new = ecuacion(x);
        error = norm(x_new - x);
        x = x_new;
        iter = iter + 1;
    end
    
    solucion = x;
end
