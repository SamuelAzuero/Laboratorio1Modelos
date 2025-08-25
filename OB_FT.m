%% === Resolver y obtener funciones de transferencia para X1(s) ===
clear; clc;

% --------- Símbolos ---------
syms s M B1 B2 B3 K1 K2 K3 real
syms X1 X2 X3 X4 U N

% --------- Ecuaciones en Laplace (condiciones iniciales nulas) ---------
eq1 = M*s^2*X1 == U - K2*(X1 - X2) - B3*(s*X1 - s*X3);
eq2 = 0 == -B2*s*X2 - K3*(X2 - X4) - K2*(X2 - X1);
eq3 = 0 == -B1*s*X3 - K1*(X3 - X4) - B3*s*(X3 - X1);
eq4 = 0 == -K1*(X4 - X3) - K3*(X4 - X2) - N;

% --------- Resolver para X1, X2, X3, X4 ---------
S = solve([eq1, eq2, eq3, eq4], [X1, X2, X3, X4]);
X1s = simplify(S.X1);

% --------- Separar contribuciones y funciones de transferencia ---------
X1_from_U = simplify(subs(X1s, N, 0));
X1_from_N = simplify(subs(X1s, U, 0));

Gu = simplify(X1_from_U / U);   % Función de transferencia X1/U
Gn = simplify(X1_from_N / N);   % Función de transferencia X1/N

% --------- Obtener polinomios para uso en tf ---------
[numGu, denGu] = numden(Gu);
[numGn, denGn] = numden(Gn);
D = simplify(lcm(denGu, denGn));            % denominador común
Nu = simplify(expand(numGu * (D / denGu))); % num Gu corregido
Nn = simplify(expand(numGn * (D / denGn))); % num Gn corregido

D  = collect(D, s);
Nu = collect(Nu, s);
Nn = collect(Nn, s);

disp('=== ECUACION ESTANDAR ===');
disp('D(s)*X1(s) = Nu(s)*U(s) + Nn(s)*N(s)');
disp('D(s)  ='); pretty(D);
disp('Nu(s) ='); pretty(Nu);
disp('Nn(s) ='); pretty(Nn);

disp('=== FUNCIONES DE TRANSFERENCIA SIMBOLICAS ===');
disp('Gu(s) = X1(s)/U(s) ='); pretty(simplify(Nu/D));
disp('Gn(s) = X1(s)/N(s) ='); pretty(simplify(Nn/D));

% --------- Valores numéricos (ejemplo) ---------
vals = struct('M', 10, 'B1', 50, 'B2', 50, 'B3', 50, 'K1', 3000, 'K2', 3000, 'K3', 3000);

Gu_num = simplify(subs(Gu, vals));
Gn_num = simplify(subs(Gn, vals));

% Convertir a vectores num/den para función de transferencia
[ngu, dgu] = numden(Gu_num);  ngu = sym2poly(expand(ngu));  dgu = sym2poly(expand(dgu));
[nn , dn ] = numden(Gn_num);  nn  = sym2poly(expand(nn ));  dn  = sym2poly(expand(dn ));

% Crear objetos tf si se tiene la toolbox
try
    Gu_tf = tf(ngu, dgu);
    Gn_tf = tf(nn , dn );
    disp('=== Objetos tf ===');
    disp('Función transferencia Gu:'); Gu_tf
    disp('Función transferencia Gn:'); Gn_tf
catch
    warning('No se detectó la Control System Toolbox. Usa ngu/dgu y nn/dn como polinomios.');
end
