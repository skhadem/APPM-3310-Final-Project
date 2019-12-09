function DisplayPoints(Model, Scene, x_range, y_range);

plot(Model(:,1),Model(:,2),'ko');
hold on;
plot(Scene(:,1),Scene(:,2),'rx');
legend('Target Points', 'Data Points');
grid;
xlim(x_range);
ylim(y_range);
hold off;