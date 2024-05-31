% createUI:
% Función principal para crear la interfaz de usuario (UI)
% calculateSolution:
%Se obtienen los valores ingresados por el usuario en los campos de entrada.
%Se convierte la cadena de texto de la ecuación en una función anónima manejable utilizando str2func.
%Se llama a la función ecuaciones_punto_fijo para calcular la solución de la ecuación usando el método punto fijo.
%Se muestra el resultado de la solución en la etiqueta de resultado.
% ecuaciones_punto_fijo:
%Esta función implementa el método de punto fijo para encontrar la solución de la ecuación.
%Se inicializan las variables necesarias: x con una aproximación inicial de ceros, iter como 
% contador de iteraciones, y error con un valor inicial infinito.
%Se itera hasta que se alcanza el límite de iteraciones o el error es menor a un umbral (1e-6).
%Durante cada iteración, se calcula el nuevo valor de x utilizando la ecuación dada, se actualiza 
% el error y el valor de x, y se incrementa el contador de iteraciones.
%Se devuelve la aproximación final como la solución encontrada.

function createUI()
    % Crear la figura de la interfaz con un título y tamaño especificado
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
    
    % Definir la función que se ejecuta al presionar el botón de cálculo
    btnCalculate.ButtonPushedFcn = @(btn, event) calculateSolution(txtEquation, txtIterations, lblResult);
end

% Función para calcular la solución utilizando el método de punto fijo
function calculateSolution(txtEquation, txtIterations, lblResult)
    % Obtener los valores ingresados por el usuario en los campos de entrada
    equationStr = txtEquation.Value;
    limitIterations = txtIterations.Value;
    
    % Convertir la cadena de la ecuación en una función manejable
    ecuacion = str2func(['@(x)' equationStr]);
    
    % Llamar a la función ecuaciones_punto_fijo para calcular la solución
    solucion = ecuaciones_punto_fijo(ecuacion, limitIterations);
    
    % Mostrar el resultado de la solución en la etiqueta de resultado
    lblResult.Text = ['Solución: ' num2str(solucion)];
end

% Función para encontrar la solución de una ecuación usando el método de punto fijo
function [solucion] = ecuaciones_punto_fijo(ecuacion, limite_iteraciones)
    % Inicialización de variables
    x = zeros(size(ecuacion(0))); % Asumimos una aproximación inicial de ceros
    iter = 0; % Contador de iteraciones
    error = inf; % Error inicial
    
    % Bucle para iterar hasta encontrar la solución con la precisión deseada o hasta alcanzar el límite de iteraciones
    while iter < limite_iteraciones && error > 1e-6
        x_new = ecuacion(x); % Calcular el nuevo valor de x usando la ecuación dada
        error = norm(x_new - x); % Calcular el error como la norma de la diferencia entre x_new y x
        x = x_new; % Actualizar el valor de x
        iter = iter + 1; % Incrementar el contador de iteraciones
    end
    
    % Devolver la aproximación final como la solución encontrada
    solucion = x;
end
