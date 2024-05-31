function ajusteExponencialCompleto()
    % Crear la figura de la interfaz
    fig = uifigure('Name', 'Ajuste de Curva Exponencial', 'Position', [100 100 500 400]);
    
    % Etiqueta y campo de entrada para los datos X
    lblDataX = uilabel(fig, 'Text', 'Datos X (separados por comas):', 'Position', [20 340 180 22]);
    txtDataX = uieditfield(fig, 'text', 'Position', [210 340 250 22]);
    
    % Etiqueta y campo de entrada para los datos Y
    lblDataY = uilabel(fig, 'Text', 'Datos Y (separados por comas):', 'Position', [20 300 180 22]);
    txtDataY = uieditfield(fig, 'text', 'Position', [210 300 250 22]);
    
    % Botón para calcular el ajuste exponencial
    btnCalculate = uibutton(fig, 'push', 'Text', 'Calcular Ajuste', 'Position', [180 260 150 22]);
    
    % Etiquetas para mostrar los resultados
    lblResultA = uilabel(fig, 'Text', 'Valor de A:', 'Position', [20 220 460 22], 'FontWeight', 'bold');
    lblResultB = uilabel(fig, 'Text', 'Valor de b:', 'Position', [20 180 460 22], 'FontWeight', 'bold');
    
    % Función que se ejecuta al presionar el botón
    btnCalculate.ButtonPushedFcn = @(btn, event) calculateExponentialFit(txtDataX, txtDataY, lblResultA, lblResultB);
end

function calculateExponentialFit(txtDataX, txtDataY, lblResultA, lblResultB)
    % Obtener los valores de los campos de entrada
    dataXStr = txtDataX.Value;
    dataYStr = txtDataY.Value;
    
    % Convertir las cadenas de entrada en vectores numéricos
    dataX = str2num(dataXStr); %#ok<ST2NM>
    dataY = str2num(dataYStr); %#ok<ST2NM>
    
    % Verificar que los datos sean válidos
    if length(dataX) ~= length(dataY)
        uialert(fig, 'Los vectores X e Y deben tener la misma longitud.', 'Error');
        return;
    end
    
    % Realizar el ajuste exponencial y generar la tabla de resultados
    [A, b, tabla] = ajusteExponencial(dataX, dataY);
    
    % Mostrar los resultados
    lblResultA.Text = ['Valor de A: ' num2str(A)];
    lblResultB.Text = ['Valor de b: ' num2str(b)];
    
    % Generar y mostrar la gráfica
    plotExponentialFit(dataX, dataY, A, b);
    
    % Mostrar la tabla de resultados en la consola
    disp('Tabla de Ajuste Exponencial:');
    disp(tabla);
end

function [A, b, tabla] = ajusteExponencial(x, y)
    % Realizar la transformación logarítmica de y
    logy = log(y);
    
    % Ajustar una línea recta a los datos transformados
    p = polyfit(x, logy, 1);
    
    % Extraer los coeficientes
    b = p(1);
    logA = p(2);
    A = exp(logA);
    
    % Calcular valores intermedios para la tabla
    n = length(x);
    V = log(y);
    x2 = x.^2;
    xV = x .* V;
    y_est = A * exp(b * x);
    e = y - y_est;
    e2 = e.^2;
    
    % Crear la tabla de resultados
    tabla = table(x', y', V', x2', xV', y_est', e', e2', ...
        'VariableNames', {'x', 'y', 'lny', 'x2', 'xV', 'y_est', 'e', 'e2'});
end

function plotExponentialFit(x, y, A, b)
    % Crear un vector de puntos para la curva ajustada
    x_fit = linspace(min(x), max(x), 100);
    y_fit = A * exp(b * x_fit);
    
    % Crear la gráfica
    figure;
    plot(x, y, 'o', x_fit, y_fit, 'r-', 'LineWidth', 2);
    title('Ajuste de Curva Exponencial');
    xlabel('X');
    ylabel('Y');
    legend('Datos Originales', 'Ajuste Exponencial');
    grid on;
end

% Llama a la función principal para crear la interfaz
ajusteExponencialCompleto();
