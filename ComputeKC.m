% given the transformation parameter param, compute the KC value;
function KCVal = ComputeKC(param);
global Scene;
global Model;
global ModelKDE;
global display_it;
global resolution;
global x_range;
global y_range;
global KCVal;

PT = TransformPoint(param,Scene);

MKDE = ComputeKDE(PT);
KCVal = -sum(sum(MKDE.*ModelKDE));



%The following for display purpose only.
if(display_it)
%     subplot(1,2,2); hold off;
    DisplayPoints(Model,PT, xlim, ylim);
%     set(gca,'FontSize',16);
    title(sprintf('KC Registration: KC = %f',-KCVal));
    drawnow;
end;
