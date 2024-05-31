function createUI()
    % Crear la figura de la interfaz
    fig = uifigure('Name', 'Regla de Simpson 3/8', 'Position', [100 100 600 500]);
    
    % Etiqueta y campo de entrada para la ecuación a integrar
    lblEq = uilabel(fig, 'Text', 'Ecuación a integrar f(x):', 'Position', [20 420 200 22]);
    txtEq = uieditfield(fig, 'text', 'Position', [230 420 340 22]);
    
    % Etiqueta y campo de entrada para el límite inferior
    lblA = uilabel(fig, 'Text', 'Límite inferior (a):', 'Position', [20 380 200 22]);
    txtA = uieditfield(fig, 'numeric', 'Position', [230 380 100 22]);
    
    % Etiqueta y campo de entrada para el límite superior
    lblB = uilabel(fig, 'Text', 'Límite superior (b):', 'Position', [20 340 200 22]);
    txtB = uieditfield(fig, 'numeric', 'Position', [230 340 100 22]);
    
    % Etiqueta y campo de entrada para la cantidad de iteraciones
    lblN = uilabel(fig, 'Text', 'Cantidad de iteraciones (n):', 'Position', [20 300 200 22]);
    txtN = uieditfield(fig, 'numeric', 'Position', [230 300 100 22]);
    
    % Botón para calcular la integral
    btnCalculate = uibutton(fig, 'push', 'Text', 'Calcular Integral', 'Position', [230 260 150 22]);
    
    % Etiqueta para mostrar el resultado
    lblResult = uilabel(fig, 'Text', 'Resultado:', 'Position', [20 220 560 22], 'FontWeight', 'bold');
    
    % Función que se ejecuta al presionar el botón
    btnCalculate.ButtonPushedFcn = @(btn, event) calculateSimpson38(txtEq, txtA, txtB, txtN, lblResult);
end

function calculateSimpson38(txtEq, txtA, txtB, txtN, lblResult)
    % Obtener los valores de los campos de entrada
    f_str = txtEq.Value;
    a = txtA.Value;
    b = txtB.Value;
    n = txtN.Value;
    
    % Validación de los límites de la integral
    if a >= b
        lblResult.Text = 'El límite inferior de la integral debe ser menor que el límite superior.';
        return;
    end
    
    % Validación de la cantidad de iteraciones
    if n <= 0 || mod(n, 3) ~= 0
        lblResult.Text = 'La cantidad de iteraciones debe ser un número positivo múltiplo de 3.';
        return;
    end
    
    % Convertir la ecuación a una función simbólica
    f = str2sym(f_str);
    syms x;
    
    % Cálculo de h
    h = (b - a) / n;
    
    % Cálculo de la integral utilizando la Regla de Simpson 3/8
    sumatoria = subs(f, a) + subs(f, b);
    
    for i = 1:n-1
        xi = a + i * h;
        if mod(i, 3) == 0
            sumatoria = sumatoria + 2 * subs(f, xi);
        else
            sumatoria = sumatoria + 3 * subs(f, xi);
        end
    end
    
    At = (3 * h / 8) * sumatoria;
    At = double(At); % Convertir el resultado a un valor numérico
    
    % Mostrar resultados
    lblResult.Text = sprintf('Área total: %.4f', At);
    
    % Gráfica de la función y la integral
    fplot(f, [a, b], 'k-', 'LineWidth', 2); % Grafica la función de color negro y grosor 2
    hold on;
    fplot(@(x) subs(f, x), [a b], 'r--'); % Grafica la aproximación de la regla de Simpson 3/8
    scatter([a b], [subs(f, a), subs(f, b)], 'ro'); % Puntos en los límites
    title(['f(x) = ', f_str, ', Integral = ', num2str(At, 4)]);
    xlabel('x');
    ylabel('f(x)');
    grid on;
    hold off;
end

% Ejecutar la interfaz de usuario
createUI();
