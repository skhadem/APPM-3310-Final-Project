                                   
% [outliers, noise] = kc_error_sets([], 10, 1, 20, 5, 3);

% plot the average line
% trendLine = [mean(noise(1,:)),mean(noise(2,:)),mean(noise(3,:)),mean(noise(4,:)),mean(noise(5,:)),mean(noise(6,:)),mean(noise(7,:)),mean(noise(8,:)),mean(noise(9,:)),mean(noise(10,:))];
trendLine = mean(noise(:,2:end)');
figure;
plot(noise(:,1), noise(:,2),'b.', 'MarkerSize', 10)
hold
plot(noise(:,1), noise(:,3),'g.', 'MarkerSize', 10)
plot(noise(:,1), noise(:,4),'r.', 'MarkerSize', 10)
plot(noise(:,1), noise(:,5),'c.', 'MarkerSize', 10)
plot(noise(:,1), noise(:,6),'m.', 'MarkerSize', 10)
plot(noise(:,1), trendLine, 'k', 'MarkerSize', 10)
xlabel('Noise')
ylabel('Error')
title('Kernel Correlation Error with Noise')

grid;