function derivadasUI()
    % Crear la figura de la interfaz
    fig = uifigure('Name', 'Derivadas Centradas', 'Position', [100 100 450 400]);
    
    % Etiqueta y campo de entrada para la función
    lblFunction = uilabel(fig, 'Text', 'Función (z):', 'Position', [20 340 100 22]);
    txtFunction = uieditfield(fig, 'text', 'Position', [130 340 290 22]);
    
    % Etiqueta y campo de entrada para el punto de interés
    lblX0 = uilabel(fig, 'Text', 'Punto de Interés (x0):', 'Position', [20 300 100 22]);
    txtX0 = uieditfield(fig, 'numeric', 'Position', [130 300 100 22]);
    
    % Etiqueta y campo de entrada para el tamaño del paso
    lblStepSize = uilabel(fig, 'Text', 'Tamaño del Paso (h):', 'Position', [20 260 100 22]);
    txtStepSize = uieditfield(fig, 'numeric', 'Position', [130 260 100 22]);
    
    % Etiqueta y campo de entrada para el umbral de error
    lblError = uilabel(fig, 'Text', 'Umbral de Error:', 'Position', [20 220 100 22]);
    txtError = uieditfield(fig, 'numeric', 'Position', [130 220 100 22]);
    
    % Botón para calcular la primera derivada
    btnFirstDerivative = uibutton(fig, 'push', 'Text', 'Calcular Primera Derivada', 'Position', [20 180 200 22]);
    
    % Botón para calcular la segunda derivada
    btnSecondDerivative = uibutton(fig, 'push', 'Text', 'Calcular Segunda Derivada', 'Position', [240 180 200 22]);
    
    % Etiquetas para mostrar los resultados
    lblResultFirst = uilabel(fig, 'Text', 'Primera Derivada:', 'Position', [20 140 400 22], 'FontWeight', 'bold');
    lblResultSecond = uilabel(fig, 'Text', 'Segunda Derivada:', 'Position', [20 100 400 22], 'FontWeight', 'bold');
    
    % Función que se ejecuta al presionar el botón de primera derivada
    btnFirstDerivative.ButtonPushedFcn = @(btn, event) calculateFirstDerivative(txtFunction, txtX0, txtStepSize, txtError, lblResultFirst);
    
    % Función que se ejecuta al presionar el botón de segunda derivada
    btnSecondDerivative.ButtonPushedFcn = @(btn, event) calculateSecondDerivative(txtFunction, txtX0, txtStepSize, txtError, lblResultSecond);
end

function calculateFirstDerivative(txtFunction, txtX0, txtStepSize, txtError, lblResult)
    % Obtener los valores de los campos de entrada
    funcStr = txtFunction.Value;
    x0 = txtX0.Value;
    h = txtStepSize.Value;
    umbralerror = txtError.Value;
    
    % Convertir la cadena de la función en una función manejable
    z = str2func(['@(x)' funcStr]);
    
    % Llamar a la función de primera derivada
    [resultado, iteraciones] = firstdfm(z, x0, h, umbralerror);
    
    % Mostrar el resultado
    lblResult.Text = ['Primera Derivada: ' num2str(resultado) ', Iteraciones: ' num2str(iteraciones)];
end

function calculateSecondDerivative(txtFunction, txtX0, txtStepSize, txtError, lblResult)
    % Obtener los valores de los campos de entrada
    funcStr = txtFunction.Value;
    x0 = txtX0.Value;
    h = txtStepSize.Value;
    umbralerror = txtError.Value;
    
    % Convertir la cadena de la función en una función manejable
    z = str2func(['@(x)' funcStr]);
    
    % Llamar a la función de segunda derivada
    [resultado, iteraciones] = seconddfm(z,  x0, h, umbralerror);
    
    % Mostrar el resultado
    lblResult.Text = ['Segunda Derivada: ' num2str(resultado) ', Iteraciones: ' num2str(iteraciones)];
end

function [resultado, iteraciones] = firstdfm(z, xo, h, umbralerror)
    % Inicialización de variables
    format long;
    syms x;
    error = 100;
    iteraciones = 0;
    
    % Calcular la primera derivada utilizando el método de diferencias centradas
    while error > umbralerror
        a = (feval(z, xo + h) - feval(z, xo)) / h;
        error = abs(((feval(@(x) diff(z(x)), xo) - a) / feval(@(x) diff(z(x)), xo))) * 100;
        iteraciones = iteraciones + 1;
        h = h / 10;
    end
    
    resultado = double(a);
    fprintf('Error cometido en porcentaje=%f\n', error);
end

function [resultado, iteraciones] = seconddfm(z, xo, h, umbralerror)
    % Inicialización de variables
    format long;
    error = 100;
    iteraciones = 0;
    
    % Calcular la segunda derivada utilizando el método de diferencias centradas
    while error > umbralerror
        % Aproximación de la segunda derivada con diferencias finitas centradas
        a = (feval(z, xo + h) - 2 * feval(z, xo) + feval(z, xo - h)) / (h^2);
        
        % Calcular el error relativo
        error = abs((feval(@(x) diff(diff(z(x))), xo) - a) / feval(@(x) diff(diff(z(x))), xo)) * 100;
        
        % Actualizar el número de iteraciones y ajustar el tamaño del paso
        iteraciones = iteraciones + 1;
        h = h / 10;
    end
    
    % Resultado y mensaje de error
    resultado = a;
    fprintf('Error cometido en porcentaje = %f\n', error);
end
