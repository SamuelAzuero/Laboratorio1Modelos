% Definir funciones de transferencia
G1 = tf([1 105 900], [10 1075 15000 90000 0]);
G2 = tf([-1 -240 -3600], [40 4300 60000 360000 0]);

% Convertir a polinomios numerador y denominador
[numG1, denG1] = tfdata(G1, 'v');
[numG2, denG2] = tfdata(G2, 'v');

% Definir variable simbólica s
syms s real

% Crear funciones simbólicas
G1_sym = poly2sym(numG1, s) / poly2sym(denG1, s);
G2_sym = poly2sym(numG2, s) / poly2sym(denG2, s);

% Suma simbólica de funciones
Gsum_sym = G1_sym + G2_sym;

% Función para calcular valor final (lim s->0 s*G(s))
valor_final_fun = @(G_sym) limit(s*G_sym, s, 0);

% Función para calcular valor inicial (lim s->inf s*G(s))
valor_inicial_fun = @(G_sym) limit(s*G_sym, s, inf);

% Calcular valores para G1
vf_G1 = double(valor_final_fun(G1_sym));
vi_G1 = double(valor_inicial_fun(G1_sym));

% Calcular valores para G2
vf_G2 = double(valor_final_fun(G2_sym));
vi_G2 = double(valor_inicial_fun(G2_sym));

% Calcular valores para la suma G1 + G2
vf_Gsum = double(valor_final_fun(Gsum_sym));
vi_Gsum = double(valor_inicial_fun(Gsum_sym));

% Mostrar resultados
fprintf('G1 - Valor Final: %f\n', vf_G1);
fprintf('G1 - Valor Inicial: %f\n', vi_G1);
fprintf('G2 - Valor Final: %f\n', vf_G2);
fprintf('G2 - Valor Inicial: %f\n', vi_G2);
fprintf('Suma G1+G2 - Valor Final: %f\n', vf_Gsum);
fprintf('Suma G1+G2 - Valor Inicial: %f\n', vi_Gsum);
