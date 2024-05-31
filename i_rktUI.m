function rungeKuttaUI()
    % Crear la figura de la interfaz
    fig = uifigure('Name', 'Runge-Kutta de Tercer Grado', 'Position', [100 100 450 400]);
    
    % Etiqueta y campo de entrada para la función
    lblFunction = uilabel(fig, 'Text', 'Función (z):', 'Position', [20 340 100 22]);
    txtFunction = uieditfield(fig, 'text', 'Position', [130 340 290 22]);
    
    % Etiqueta y campo de entrada para el valor inicial
    lblInitialValue = uilabel(fig, 'Text', 'Valor Inicial (y0):', 'Position', [20 300 100 22]);
    txtInitialValue = uieditfield(fig, 'numeric', 'Position', [130 300 100 22]);
    
    % Etiqueta y campo de entrada para el límite inferior
    lblLowerLimit = uilabel(fig, 'Text', 'Límite Inferior (a):', 'Position', [20 260 100 22]);
    txtLowerLimit = uieditfield(fig, 'numeric', 'Position', [130 260 100 22]);
    
    % Etiqueta y campo de entrada para el límite superior
    lblUpperLimit = uilabel(fig, 'Text', 'Límite Superior (b):', 'Position', [20 220 100 22]);
    txtUpperLimit = uieditfield(fig, 'numeric', 'Position', [130 220 100 22]);
    
    % Etiqueta y campo de entrada para el tamaño del paso
    lblStepSize = uilabel(fig, 'Text', 'Tamaño del Paso (h):', 'Position', [20 180 100 22]);
    txtStepSize = uieditfield(fig, 'numeric', 'Position', [130 180 100 22]);
    
    % Botón para calcular la aproximación
    btnCalculate = uibutton(fig, 'push', 'Text', 'Calcular Aproximación', 'Position', [130 140 150 22]);
    
    % Etiqueta para mostrar el resultado
    lblResult = uilabel(fig, 'Text', 'Resultado:', 'Position', [20 100 400 22], 'FontWeight', 'bold');
    
    % Función que se ejecuta al presionar el botón
    btnCalculate.ButtonPushedFcn = @(btn, event) calculateApproximation(txtFunction, txtInitialValue, txtLowerLimit, txtUpperLimit, txtStepSize, lblResult);
end

function calculateApproximation(txtFunction, txtInitialValue, txtLowerLimit, txtUpperLimit, txtStepSize, lblResult)
    % Obtener los valores de los campos de entrada
    funcStr = txtFunction.Value;
    y0 = txtInitialValue.Value;
    a = txtLowerLimit.Value;
    b = txtUpperLimit.Value;
    h = txtStepSize.Value;
    
    % Convertir la cadena de la función en una función manejable
    z = str2func(['@(x,y)' funcStr]);
    
    % Llamar a la función de Runge-Kutta de tercer grado
    resultado = rungeKutta3(z, y0, a, b, h);
    
    % Mostrar el resultado
    lblResult.Text = ['Resultado: ' num2str(resultado)];
end

function [resultado] = rungeKutta3(z, yo, a, b, h)
    format long;
    syms x y;
    inter = a:h:b;
    f = 0;
    bandera = [];
    
    for i = 1:length(inter)
        k1 = subs(z, {x, y}, {inter(i), yo});
        k2 = subs(z, {x, y}, {inter(i) + h/2, yo + (h/2) * k1});
        k3 = subs(z, {x, y}, {inter(i) + h, yo - h * k1 + 2 * h * k2});
        y1 = yo + (h/6) * (k1 + 4 * k2 + k3);
        f = y1;
        yo = y1;
        bandera = [bandera f];
    end
    
    resultado = double(f);
    figure();
    hold on;
    grid on;
    plot(inter, bandera);
end
