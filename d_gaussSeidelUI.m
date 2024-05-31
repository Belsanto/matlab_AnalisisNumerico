%createUI:
% Función principal para crear la interfaz de usuario (UI)
% calculateSolution:
%Obtiene los valores ingresados por el usuario en los campos de entrada.
%Convierte las cadenas de texto de la matriz A, el vector b y la solución 
%inicial en matrices y vectores numéricos utilizando str2num.
%Llama a la función ecuaciones_gauss_seidel para calcular la solución utilizando el método de Gauss-Seidel.
%Muestra el resultado de la solución en la etiqueta de resultado.
% ecuaciones_gauss_seidel:
%Implementa el método iterativo de Gauss-Seidel para resolver sistemas de ecuaciones lineales.
%Inicializa las variables necesarias para el cálculo, incluyendo la solución 
% inicial y el contador de iteraciones.
%Realiza iteraciones hasta que la solución converge dentro de la tolerancia 
% especificada o se alcanza el límite de iteraciones.
%En cada iteración, actualiza la solución para cada variable utilizando la fórmula de Gauss-Seidel.
%Verifica si la solución ha convergido comparando la norma de la diferencia 
% entre la solución actual y la solución anterior con la tolerancia.
%Devuelve la solución final.

function createUI()
    % Crear la figura de la interfaz con un título y tamaño especificado
    fig = uifigure('Name', 'Calculadora de Gauss-Seidel', 'Position', [100 100 500 400]);
    
    % Etiqueta y campo de entrada para la matriz A
    lblMatrix = uilabel(fig, 'Text', 'Matriz A:', 'Position', [20 320 100 22]);
    txtMatrix = uieditfield(fig, 'text', 'Position', [130 320 340 22]);
    
    % Etiqueta y campo de entrada para el vector b
    lblVector = uilabel(fig, 'Text', 'Vector b:', 'Position', [20 280 100 22]);
    txtVector = uieditfield(fig, 'text', 'Position', [130 280 340 22]);
    
    % Etiqueta y campo de entrada para la solución inicial
    lblInitialSolution = uilabel(fig, 'Text', 'Solución Inicial:', 'Position', [20 240 100 22]);
    txtInitialSolution = uieditfield(fig, 'text', 'Position', [130 240 340 22]);
    
    % Etiqueta y campo de entrada para la tolerancia
    lblTolerance = uilabel(fig, 'Text', 'Tolerancia:', 'Position', [20 200 100 22]);
    txtTolerance = uieditfield(fig, 'numeric', 'Position', [130 200 100 22]);
    
    % Etiqueta y campo de entrada para el límite de iteraciones
    lblIterations = uilabel(fig, 'Text', 'Límite Iteraciones:', 'Position', [20 160 100 22]);
    txtIterations = uieditfield(fig, 'numeric', 'Position', [130 160 100 22]);
    
    % Botón para calcular la solución
    btnCalculate = uibutton(fig, 'push', 'Text', 'Calcular Solución', 'Position', [130 120 150 22]);
    
    % Etiqueta para mostrar el resultado
    lblResult = uilabel(fig, 'Text', 'Solución:', 'Position', [20 80 450 22], 'FontWeight', 'bold');
    
    % Definir la función que se ejecuta al presionar el botón de cálculo
    btnCalculate.ButtonPushedFcn = @(btn, event) calculateSolution(txtMatrix, txtVector, txtInitialSolution, txtTolerance, txtIterations, lblResult);
end

% Función para calcular la solución utilizando el método de Gauss-Seidel
function calculateSolution(txtMatrix, txtVector, txtInitialSolution, txtTolerance, txtIterations, lblResult)
    % Obtener los valores ingresados por el usuario en los campos de entrada
    matrixStr = txtMatrix.Value;
    vectorStr = txtVector.Value;
    initialSolutionStr = txtInitialSolution.Value;
    tolerance = txtTolerance.Value;
    limitIterations = txtIterations.Value;
    
    % Convertir las cadenas de entrada en matrices y vectores numéricos
    matriz = str2num(matrixStr); %#ok<ST2NM>
    vector = str2num(vectorStr); %#ok<ST2NM>
    solucion_inicial = str2num(initialSolutionStr); %#ok<ST2NM>
    
    % Llamar a la función ecuaciones_gauss_seidel para calcular la solución
    solucion = ecuaciones_gauss_seidel(matriz, vector, solucion_inicial, tolerance, limitIterations);
    
    % Mostrar el resultado en la etiqueta de resultado
    lblResult.Text = ['Solución: ' num2str(solucion')];
end

% Función que implementa el método de Gauss-Seidel
function [solucion] = ecuaciones_gauss_seidel(matriz, vector, solucion_inicial, tolerancia, limite_iteraciones)
    % Inicialización de variables
    tam_vector = length(vector); % Tamaño del vector
    aproximacion = solucion_inicial; % Solución inicial
    aproximacion_anterior = aproximacion; % Almacena la solución anterior para verificar la convergencia
    iterar = 1; % Variable de control para el ciclo de iteraciones
    iteracion_actual = 0; % Contador de iteraciones

    % Bucle para iterar hasta alcanzar la tolerancia o el límite de iteraciones
    while (iterar == 1 && iteracion_actual <= limite_iteraciones)
        for contador_columnas = 1:tam_vector
            % Calcular la suma de las filas excepto el elemento diagonal
            sumatoria = matriz(contador_columnas, 1:contador_columnas-1) * aproximacion(1:contador_columnas-1) + ...
                        matriz(contador_columnas, contador_columnas+1:tam_vector) * aproximacion(contador_columnas+1:tam_vector);
            
            % Actualizar la solución para la variable actual
            aproximacion(contador_columnas) = (vector(contador_columnas) - sumatoria) / matriz(contador_columnas, contador_columnas);
        end

        % Verificar si la solución ha convergido dentro de la tolerancia
        if norm(aproximacion_anterior - aproximacion) < tolerancia
            iterar = 0; % Detener las iteraciones si la solución ha convergido
        end

        % Actualizar la solución anterior y el contador de iteraciones
        aproximacion_anterior = aproximacion;
        iteracion_actual = iteracion_actual + 1;
    end

    % Devolver la solución final
    solucion = aproximacion;
end
