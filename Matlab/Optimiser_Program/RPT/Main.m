figure()
hold on

yyaxis left
p1 = plot(GK_RS15_01_char_027_2_.TestTime, ...
          GK_RS15_01_char_027_2_.Amps, ...
          'LineWidth', 1.5);
ylabel('Current $(I)$', 'Interpreter', 'latex', 'FontSize', 13)


yyaxis right
p2 = plot(GK_RS15_01_char_027_2_.TestTime, ...
          GK_RS15_01_char_027_2_.Volts, ...
          'LineWidth', 1.5);
ylabel('Terminal Voltage $(V)$', 'Interpreter', 'latex', 'FontSize', 13)

yyaxis left
ax = gca;
ax.YColor = p1.Color;

yyaxis right
ax.YColor = p2.Color;

xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 13)
grid on


set(gca, 'FontName', 'Times', 'FontSize', 12)
