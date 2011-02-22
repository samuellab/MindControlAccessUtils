function plotWorm(mcdf)
hold on;
plot(mcdf.Head(:,1),mcdf.Head(:,2),'o')
plot(mcdf.Tail(:,1),mcdf.Tail(:,2),'^')
end
