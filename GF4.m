% Definir funciones de transferencia (ejemplo)
numG1 = [1 105 900];
denG1 = [10 1075 15000 90000 0];
numG2 = [-1 -240 -3600];
denG2 = [40 4300 60000 360000 0];

G1 = tf(numG1, denG1);
G2 = tf(numG2, denG2);

% Vector de tiempo total
t_total = 0:0.01:20;  % 

% Entradas
u1_full = ones(size(t_total));  % Escalón unitario
u1 = zeros(size(t_total));
u1(t_total <= 1) = u1_full(t_total <= 1);  % Aplica escalón solo hasta t=10s

u2_full = t_total;              % Rampa unitaria
u2 = zeros(size(t_total));
u2(t_total <= 1) = u2_full(t_total <= 1);  % Aplica rampa solo hasta t=10s

% Simular respuesta de cada entrada con lsim
y1 = lsim(G1, u1, t_total);
y2 = lsim(G2, u2, t_total);

% Respuesta total
y_total = y1 + y2;

% Graficar resultados
figure;

subplot(2,1,1);
plot(t_total, u1, 'b', 'LineWidth', 1.2); hold on;
plot(t_total, u2, 'r', 'LineWidth', 1.2);
xlabel('Tiempo (s)');
ylabel('Entradas');
legend('Escalón unitario (hasta 10s)', 'Rampa unitaria (hasta 10s)');
title('Entradas aplicadas');
grid on;

subplot(2,1,2);
plot(t_total, y_total, 'w', 'LineWidth', 1.5);
xlabel('Tiempo (s)');
ylabel('Respuesta del sistema');
title('Respuesta total del sistema');
grid on;
