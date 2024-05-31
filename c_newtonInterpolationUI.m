function createUI()
    % Crear la figura de la interfaz
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
    
    % Función que se ejecuta al presionar el botón
    btnCalculate.ButtonPushedFcn = @(btn, event) calculateInterpolation(txtX, txtY, txtN, txtXEval, lblResult, uit);
end

function calculateInterpolation(txtX, txtY, txtN, txtXEval, lblResult, uit)
    % Obtener los valores de los campos de entrada
    X = str2num(txtX.Value); %#ok<ST2NM>
    Y = str2num(txtY.Value); %#ok<ST2NM>
    n = txtN.Value;
    XEval = txtXEval.Value;
    
    % Validación de los datos ingresados
    if length(X) ~= length(Y)
        lblResult.Text = 'Los vectores x e y deben tener la misma longitud.';
    else
        % Llamar a la función NewtonInt
        [Yval, NewtonPol, M] = NewtonInt(X, Y, n, XEval);
        
        % Mostrar el resultado y la tabla
        lblResult.Text = ['Resultado: P(', num2str(XEval), ') = ', num2str(Yval)];
        uit.Data = M(2:end, :);
        uit.ColumnName = M(1, :);
    end
end

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
    xterm = 1; yint = ddf(1,1); yacum = yint;
    for i = 2:n+1
        xterm = xterm*(X-x(i-1));
        yint(i) = ddf(1,i)*xterm; %#ok<AGROW>
        yacum(i) = yacum(i-1) + yint(i); %#ok<AGROW>
        ea(i) = yacum(i) - yacum(i-1); %#ok<AGROW>
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
    Datos = num2cell([(vn)', yacum', [0 ea(2:end)]']);
    M = [Encabezado; Datos];

    % Gráfica
    fs = str2sym(NewtonPol); % Convierte el string a función simbólica.
    figure;
    fplot(fs, [min(x)-1, max(x)+1], 'k-', 'LineWidth', 2); % Grafica la función de color negro y grosor 2
    title(['P(x) = ', NewtonPol]); 
    hold on;
    scatter(x, y, 'LineWidth', 2, 'MarkerEdgeColor', 'b'); % Gráfica los puntos originales
    plot(X, Y, 'ro', 'MarkerFaceColor', 'r'); % Gráfica el punto evaluado
    grid on;
end
