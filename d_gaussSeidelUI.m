function createUI()
    % Crear la figura de la interfaz
    fig = uifigure('Name', 'Calculadora de Gauss-Seidel', 'Position', [100 100 500 400]);
    
    % Etiqueta y campo de entrada para la matriz
    lblMatrix = uilabel(fig, 'Text', 'Matriz A:', 'Position', [20 320 100 22]);
    txtMatrix = uieditfield(fig, 'text', 'Position', [130 320 340 22]);
    
    % Etiqueta y campo de entrada para el vector
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
    
    % Función que se ejecuta al presionar el botón
    btnCalculate.ButtonPushedFcn = @(btn, event) calculateSolution(txtMatrix, txtVector, txtInitialSolution, txtTolerance, txtIterations, lblResult);
end

function calculateSolution(txtMatrix, txtVector, txtInitialSolution, txtTolerance, txtIterations, lblResult)
    % Obtener los valores de los campos de entrada
    matrixStr = txtMatrix.Value;
    vectorStr = txtVector.Value;
    initialSolutionStr = txtInitialSolution.Value;
    tolerance = txtTolerance.Value;
    limitIterations = txtIterations.Value;
    
    % Convertir las cadenas de entrada en matrices y vectores
    matriz = str2num(matrixStr); %#ok<ST2NM>
    vector = str2num(vectorStr); %#ok<ST2NM>
    solucion_inicial = str2num(initialSolutionStr); %#ok<ST2NM>
    
    % Llamar a la función ecuaciones_gauss_seidel
    solucion = ecuaciones_gauss_seidel(matriz, vector, solucion_inicial, tolerance, limitIterations);
    
    % Mostrar el resultado
    lblResult.Text = ['Solución: ' num2str(solucion')];
end

function [solucion] = ecuaciones_gauss_seidel(matriz, vector, solucion_inicial, tolerancia, limite_iteraciones)
    tam_vector = length(vector);
    aproximacion = solucion_inicial;
    aproximacion_anterior = aproximacion;
    iterar = 1;
    iteracion_actual = 0;

    while (iterar == 1 && iteracion_actual <= limite_iteraciones)
        for contador_columnas = 1:tam_vector
            sumatoria = matriz(contador_columnas, 1:contador_columnas-1) * aproximacion(1:contador_columnas-1) + ...
                        matriz(contador_columnas, contador_columnas+1:tam_vector) * aproximacion(contador_columnas+1:tam_vector);

            aproximacion(contador_columnas) = (vector(contador_columnas) - sumatoria) / matriz(contador_columnas, contador_columnas);
        end

        if norm(aproximacion_anterior - aproximacion) < tolerancia
            iterar = 0;
        end

        aproximacion_anterior = aproximacion;
        iteracion_actual = iteracion_actual + 1;
    end

    solucion = aproximacion;
end
