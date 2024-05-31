function createUI()
    % Crear la figura de la interfaz
    fig = uifigure('Name', 'Calculadora de Raíces - Método de Bisección', 'Position', [100 100 400 300]);
    
    % Etiqueta y campo de entrada para la ecuación
    lblEquation = uilabel(fig, 'Text', 'Ecuación:', 'Position', [20 240 100 22]);
    txtEquation = uieditfield(fig, 'text', 'Position', [130 240 250 22]);
    
    % Etiqueta y campo de entrada para el límite izquierdo
    lblLeftLimit = uilabel(fig, 'Text', 'Límite Izquierdo:', 'Position', [20 200 100 22]);
    txtLeftLimit = uieditfield(fig, 'numeric', 'Position', [130 200 100 22]);
    
    % Etiqueta y campo de entrada para el límite derecho
    lblRightLimit = uilabel(fig, 'Text', 'Límite Derecho:', 'Position', [20 160 100 22]);
   
    txtRightLimit = uieditfield(fig, 'numeric', 'Position', [130 160 100 22]);
    
    % Etiqueta y campo de entrada para la tolerancia
    lblTolerance = uilabel(fig, 'Text', 'Tolerancia:', 'Position', [20 120 100 22]);
    txtTolerance = uieditfield(fig, 'numeric', 'Position', [130 120 100 22]);
    
    % Botón para calcular la raíz
    btnCalculate = uibutton(fig, 'push', 'Text', 'Calcular Raíz', 'Position', [130 80 100 22]);
    
    % Etiqueta para mostrar el resultado
    lblResult = uilabel(fig, 'Text', 'Raíz:', 'Position', [20 40 360 22], 'FontWeight', 'bold');
    
    % Función que se ejecuta al presionar el botón
    btnCalculate.ButtonPushedFcn = @(btn, event) calculateRoot(txtEquation, txtLeftLimit, txtRightLimit, txtTolerance, lblResult);
end

function calculateRoot(txtEquation, txtLeftLimit, txtRightLimit, txtTolerance, lblResult)
    % Obtener los valores de los campos de entrada
    equationStr = txtEquation.Value;
    leftLimit = txtLeftLimit.Value;
    rightLimit = txtRightLimit.Value;
    tolerance = txtTolerance.Value;
    
    % Convertir la cadena de la ecuación en una función manejable
    ecuacion = str2func(['@(x)' equationStr]);
    
    % Llamar a la función raices_biseccion
    raiz = raices_biseccion(ecuacion, leftLimit, rightLimit, tolerance);
    
    % Mostrar el resultado
    lblResult.Text = ['Raíz: ' num2str(raiz)];
end

function [raiz] = raices_biseccion(ecuacion, lim_izquierda, lim_derecha, tolerancia)
    iterar = 1;
    aproximacion_anterior = nan;
    aproximacion = nan;

    while (iterar)
        aproximacion = (lim_izquierda + lim_derecha) / 2;

        if (abs(aproximacion - aproximacion_anterior) / aproximacion < tolerancia || ecuacion(aproximacion) == 0)
            iterar = 0;
        end

        if (ecuacion(lim_izquierda) * ecuacion(lim_derecha) < 0)
            lim_derecha = aproximacion;
        else
            if (ecuacion(lim_izquierda) * ecuacion(lim_derecha) > 0)
                lim_izquierda = aproximacion;
            end
        end

        aproximacion_anterior = aproximacion;
    end

    raiz = aproximacion;
end
