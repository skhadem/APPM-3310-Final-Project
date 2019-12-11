                                   
[outliers, noise] = pca_error_sets([], 10, 1, 20, 5, 3);


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
title('Least Squares Error with Noise')

grid;