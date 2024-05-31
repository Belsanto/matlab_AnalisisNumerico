function createUI()
    % Crear la figura de la interfaz
    fig = uifigure('Name', 'Ajuste de Curva Cuadrática', 'Position', [100 100 500 400]);
    
    % Etiqueta y campo de entrada para el número de parejas de datos
    lblN = uilabel(fig, 'Text', 'Número de parejas de datos (n):', 'Position', [20 320 200 22]);
    txtN = uieditfield(fig, 'numeric', 'Position', [230 320 100 22]);
    
    % Etiqueta y campo de entrada para los valores de X
    lblX = uilabel(fig, 'Text', 'Valores de X:', 'Position', [20 280 200 22]);
    txtX = uieditfield(fig, 'text', 'Position', [230 280 240 22]);
    
    % Etiqueta y campo de entrada para los valores de Y
    lblY = uilabel(fig, 'Text', 'Valores de Y:', 'Position', [20 240 200 22]);
    txtY = uieditfield(fig, 'text', 'Position', [230 240 240 22]);
    
    % Botón para calcular la solución
    btnCalculate = uibutton(fig, 'push', 'Text', 'Calcular Ajuste', 'Position', [230 200 150 22]);
    
    % Etiqueta para mostrar el resultado
    lblResult = uilabel(fig, 'Text', 'Resultado:', 'Position', [20 160 450 22], 'FontWeight', 'bold');
    
    % Función que se ejecuta al presionar el botón
    btnCalculate.ButtonPushedFcn = @(btn, event) calculateCurveFit(txtN, txtX, txtY, lblResult);
end

function calculateCurveFit(txtN, txtX, txtY, lblResult)
    % Obtener los valores de los campos de entrada
    n = txtN.Value;
    X = str2num(txtX.Value); %#ok<ST2NM>
    Y = str2num(txtY.Value); %#ok<ST2NM>
    
    % Validación de los datos ingresados
    if length(X) ~= n || length(Y) ~= n
        lblResult.Text = 'La cantidad de valores en x e y no coincide con n.';
    else
        % Organiza los datos en una matriz
        tabla = [X; Y]';
        
        % Inicializa las sumatorias
        sumatoriaX = 0;
        sumatoriaY = 0;
        sumatoriaXY = 0;
        sumatoriaX2Y = 0;
        sumatoriaX2 = 0;
        sumatoriaX3 = 0;
        sumatoriaX4 = 0;

        % Calcula las sumatorias
        for i = 1:n
            nx = tabla(i, 1);
            ny = tabla(i, 2);
            sumatoriaX = sumatoriaX + nx;
            sumatoriaY = sumatoriaY + ny;
            sumatoriaXY = sumatoriaXY + nx * ny;
            sumatoriaX2Y = sumatoriaX2Y + nx^2 * tabla(i, 2);
            sumatoriaX2 = sumatoriaX2 + nx^2;
            sumatoriaX3 = sumatoriaX3 + nx^3;
            sumatoriaX4 = sumatoriaX4 + nx^4;
        end

        % Construye los vectores y matrices necesarios
        vectorA = [sumatoriaX2, sumatoriaX4, sumatoriaX3];
        vectorB = [sumatoriaX3, sumatoriaX2, sumatoriaX];
        vectorC = [n, sumatoriaX2, sumatoriaX];
        vectorRes = [sumatoriaY, sumatoriaX2Y, sumatoriaXY];
        matriz = [vectorA; vectorB; vectorC]';
        detMatriz = det(matriz);
        matrizA = [vectorRes; vectorB; vectorC]';
        detA = det(matrizA);
        a = vpa(detA / detMatriz, 10);
        matrizB = [vectorA; vectorRes; vectorC]';
        detB = det(matrizB);
        b = vpa(detB / detMatriz, 10);
        matrizC = [vectorA; vectorB; vectorRes]';
        detC = det(matrizC);
        c = vpa(detC / detMatriz, 10);

        % Crea un vector X para el trazado y el MSE
        X_fit = linspace(min(X), max(X), 100); % 100 puntos para el ajuste
        % Evalúa la ecuación cuadrática en X_fit
        syms x;
        Y_fit = double(subs(a * x^2 + b * x + c, x, X_fit));

        % Trazado de los datos originales y el ajuste
        figure;
        plot(X, Y, 'o', X_fit, Y_fit, 'r', 'LineWidth', 2);
        title('Ajuste de Curva Cuadrática');
        xlabel('X');
        ylabel('Y');
        legend('Datos Originales', 'Ajuste Cuadrático');
        grid on;

        % Muestra el ajuste de curva cuadrática
        resultado = ['El ajuste de curva cuadrática para los puntos dados es: y = ', char(vpa(a,4)), '*x^2 + ', char(vpa(b,4)), '*x + ', char(vpa(c,4))];
        lblResult.Text = resultado;

        % Definición de la ecuación cuadrática
        y_estimado = a * X.^2 + b * X + c;

        % Calcula el error cuadrático medio (MSE)
        mse = sum((Y - y_estimado).^2) / n;
        disp(['El error cuadrático medio (MSE) es: ', char(vpa(mse,4))]);
    end
end

% Llama a la función principal para crear la interfaz
createUI();
