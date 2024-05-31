%createUI:
% Función principal para crear la interfaz de usuario (UI)
% calculateInterpolation:
%Se obtienen los valores ingresados por el usuario en los campos de entrada.
%Se convierte la cadena de texto de los vectores de coordenadas en X y Y a 
%arreglos numéricos utilizando str2num.
%Se verifica que los vectores X y Y tengan la misma longitud.
%Se llama a la función NewtonInt para calcular la interpolación de Newton.
%Se muestra el resultado de la interpolación y se actualiza la tabla con los valores interpolados y errores.
% NewtonInt:
%Esta función implementa el método de interpolación de Newton.
%Se construye la matriz de diferencias divididas finitas (ddf).
%Se calcula el polinomio de interpolación de Newton y se evalúa en el punto X.
%Se construye una representación en cadena del polinomio de Newton.
%Se crea un resumen en una tabla con los valores interpolados y errores.
%Se grafica el polinomio de interpolación, los puntos originales y el punto evaluado.

function createUI()
    % Crear la figura de la interfaz con un título y tamaño especificado
    fig = uifigure('Name', 'Interpolación de Newton', 'Position', [100 100 600 500]);
    
    % Etiqueta y campo de entrada para el vector de coordenadas en x
    lblX = uilabel(fig, 'Text', 'Vector de coordenadas en x:', 'Position', [20 420 200 22]);
    txtX = uieditfield(fig, 'text', 'Position', [230 420 340 22]);
    
    % Etiqueta y campo de entrada para el vector de coordenadas en y
    lblY = uilabel(fig, 'Text', 'Vector de coordenadas en y:', 'Position', [20 380 200 22]);
    txtY = uieditfield(fig, 'text', 'Position', [230 380 340 22]);
    
    % Etiqueta y campo de entrada para el grado del polinomio
    lblN = uilabel(fig, 'Text', 'Grado del polinomio (n):', 'Position', [20 340 200 22]);
    txtN = uieditfield(fig, 'numeric', 'Position', [230 340 100 22]);
    
    % Etiqueta y campo de entrada para la coordenada X a evaluar
    lblXEval = uilabel(fig, 'Text', 'Coordenada X a evaluar:', 'Position', [20 300 200 22]);
    txtXEval = uieditfield(fig, 'numeric', 'Position', [230 300 100 22]);
    
    % Botón para calcular la solución
    btnCalculate = uibutton(fig, 'push', 'Text', 'Calcular Interpolación', 'Position', [230 260 150 22]);
    
    % Etiqueta para mostrar el resultado
    lblResult = uilabel(fig, 'Text', 'Resultado:', 'Position', [20 220 560 22], 'FontWeight', 'bold');
    
    % Tabla para mostrar los valores interpolados y errores
    uit = uitable(fig, 'Position', [20 20 560 180]);
    
    % Definir la función que se ejecuta al presionar el botón de cálculo
    btnCalculate.ButtonPushedFcn = @(btn, event) calculateInterpolation(txtX, txtY, txtN, txtXEval, lblResult, uit);
end

% Función para calcular la interpolación utilizando el método de Newton
function calculateInterpolation(txtX, txtY, txtN, txtXEval, lblResult, uit)
    % Obtener los valores ingresados por el usuario en los campos de entrada
    X = str2num(txtX.Value); %#ok<ST2NM>
    Y = str2num(txtY.Value); %#ok<ST2NM>
    n = txtN.Value;
    XEval = txtXEval.Value;
    
    % Validación de los datos ingresados
    if length(X) ~= length(Y)
        lblResult.Text = 'Los vectores x e y deben tener la misma longitud.';
    else
        % Llamar a la función NewtonInt para calcular la interpolación
        [Yval, NewtonPol, M] = NewtonInt(X, Y, n, XEval);
        
        % Mostrar el resultado y la tabla
        lblResult.Text = ['Resultado: P(', num2str(XEval), ') = ', num2str(Yval)];
        uit.Data = M(2:end, :);
        uit.ColumnName = M(1, :);
    end
end

% Función para calcular la interpolación de Newton
function [Y, NewtonPol, M] = NewtonInt(x, y, n, X)
    % Construir la matriz de diferencias divididas finitas
    ddf = zeros(length(x), length(y)); 
    ddf(:,1) = y;
    for j = 2:n+1
        for i = 1:(n+1)-(j-1)
            ddf(i,j) = (ddf(i+1,j-1) - ddf(i,j-1)) / (x(i+j-1) - x(i));
        end
    end

    % Interpolación de Newton
    xterm = 1; 
    yint = ddf(1,1); 
    yacum = yint;
    for i = 2:n+1
        xterm = xterm * (X - x(i-1));
        yint(i) = ddf(1,i) * xterm;
        yacum(i) = yacum(i-1) + yint(i);
        ea(i) = yacum(i) - yacum(i-1);
    end
    Y = sum(yint);

    % Construir el polinomio de Newton como un string
    pol{1,1} = num2str(ddf(1,1));
    for i = 2:n+1
        if x(i-1) ~= 0
            xr{1,i} = ['*(x - ', num2str(x(i-1)), ')'];            
        else
            xr{1,i} = ['*x'];
        end
        if ddf(1,i) > 0
            pol{1,i} = [' + ', num2str(ddf(1,i)), xr{1,2:i}];
        elseif ddf(1,i) < 0
            pol{1,i} = [' ', num2str(ddf(1,i)), xr{1,2:i}];
        end
    end
    NewtonPol = strjoin(pol, '');

    % Resumen en una tabla
    vn = 0:n;
    Encabezado = {'Grado', 'P(x)', 'Error'};
    Datos = num2cell([vn', yacum', [0 ea(2:end)]']);
    M = [Encabezado; Datos];

    % Gráfica
    fs = str2sym(NewtonPol); % Convierte el string a función simbólica.
    figure;
    fplot(fs, [min(x)-1, max(x)+1], 'k-', 'LineWidth', 2); % Grafica la función de color negro y grosor 2
    title(['P(x) = ', NewtonPol]); 
    hold on;
    scatter(x, y, 'LineWidth', 2, 'MarkerEdgeColor', 'b'); % Graficar los puntos originales
    plot(X, Y, 'ro', 'MarkerFaceColor', 'r'); % Graficar el punto evaluado
    grid on;
end
