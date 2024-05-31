% rungeKuttaUI:
% Función principal para crear la interfaz de usuario (UI) del método de Runge-Kutta de tercer grado
%calculateApproximation:
%Obtiene los valores ingresados por el usuario en los campos de entrada.
%Convierte la cadena de la función en una función manejable utilizando str2func.
%Llama a la función de Runge-Kutta de tercer grado con los parámetros proporcionados.
%Muestra el resultado de la aproximación en la etiqueta de resultado.
%rungeKutta3:
%Implementa el método de Runge-Kutta de tercer grado para resolver ecuaciones diferenciales.
%Inicializa las variables necesarias, incluyendo el vector de puntos de evaluación y el vector para almacenar los resultados intermedios.
%Itera sobre cada punto en el intervalo y calcula los valores de  𝑘1 𝑘2 𝑘3​ para actualizar el valor de 𝑦
%Actualiza y almacena el valor de 𝑦 y en cada iteración. Convierte el resultado final a un valor numérico.
%Crea una gráfica de la solución aproximada. 

function rungeKuttaUI()
    % Crear la figura de la interfaz con un título y tamaño especificado
    fig = uifigure('Name', 'Runge-Kutta de Tercer Grado', 'Position', [100 100 450 400]);
    
    % Etiqueta y campo de entrada para la función z
    lblFunction = uilabel(fig, 'Text', 'Función (z):', 'Position', [20 340 100 22]);
    txtFunction = uieditfield(fig, 'text', 'Position', [130 340 290 22]);
    
    % Etiqueta y campo de entrada para el valor inicial y0
    lblInitialValue = uilabel(fig, 'Text', 'Valor Inicial (y0):', 'Position', [20 300 100 22]);
    txtInitialValue = uieditfield(fig, 'numeric', 'Position', [130 300 100 22]);
    
    % Etiqueta y campo de entrada para el límite inferior a
    lblLowerLimit = uilabel(fig, 'Text', 'Límite Inferior (a):', 'Position', [20 260 100 22]);
    txtLowerLimit = uieditfield(fig, 'numeric', 'Position', [130 260 100 22]);
    
    % Etiqueta y campo de entrada para el límite superior b
    lblUpperLimit = uilabel(fig, 'Text', 'Límite Superior (b):', 'Position', [20 220 100 22]);
    txtUpperLimit = uieditfield(fig, 'numeric', 'Position', [130 220 100 22]);
    
    % Etiqueta y campo de entrada para el tamaño del paso h
    lblStepSize = uilabel(fig, 'Text', 'Tamaño del Paso (h):', 'Position', [20 180 100 22]);
    txtStepSize = uieditfield(fig, 'numeric', 'Position', [130 180 100 22]);
    
    % Botón para calcular la aproximación
    btnCalculate = uibutton(fig, 'push', 'Text', 'Calcular Aproximación', 'Position', [130 140 150 22]);
    
    % Etiqueta para mostrar el resultado
    lblResult = uilabel(fig, 'Text', 'Resultado:', 'Position', [20 100 400 22], 'FontWeight', 'bold');
    
    % Función que se ejecuta al presionar el botón
    btnCalculate.ButtonPushedFcn = @(btn, event) calculateApproximation(txtFunction, txtInitialValue, txtLowerLimit, txtUpperLimit, txtStepSize, lblResult);
end

% Función para calcular la aproximación usando el método de Runge-Kutta de tercer grado
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

% Función que implementa el método de Runge-Kutta de tercer grado
function [resultado] = rungeKutta3(z, yo, a, b, h)
    format long; % Usar formato de número largo
    syms x y; % Definir variables simbólicas
    inter = a:h:b; % Crear un vector de puntos de evaluación
    f = 0; % Inicializar la variable de resultado
    bandera = []; % Inicializar el vector para almacenar los resultados intermedios
    
    % Iterar sobre cada punto en el intervalo
    for i = 1:length(inter)
        % Calcular los valores de k1, k2 y k3
        k1 = subs(z, {x, y}, {inter(i), yo});
        k2 = subs(z, {x, y}, {inter(i) + h/2, yo + (h/2) * k1});
        k3 = subs(z, {x, y}, {inter(i) + h, yo - h * k1 + 2 * h * k2});
        
        % Calcular el siguiente valor de y usando el método de Runge-Kutta de tercer grado
        y1 = yo + (h/6) * (k1 + 4 * k2 + k3);
        
        % Actualizar el valor de y y almacenar el resultado
        f = y1;
        yo = y1;
        bandera = [bandera f];
    end
    
    % Convertir el resultado a un valor numérico
    resultado = double(f);
    
    % Crear una figura para la gráfica
    figure();
    hold on;
    grid on;
    plot(inter, bandera);
    title('Solución usando el método de Runge-Kutta de Tercer Grado');
    xlabel('x');
    ylabel('y');
end