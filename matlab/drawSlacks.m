clear; format short g

fid = fopen("../outputs/divider_dshift/slacks.txt");
S = textscan(fid, "%s %f");
patterns = S{2}(1);
time = S{2}(2);
x = [];
for ind = S{1}(3:end).'
   x = [x str2double(ind{1})];
end
x = x.';
y = S{2}(3:end);

figure(2); clf
plot(x, y)
ylabel("SDQL")
xlabel("Slack (%)")
title(sprintf("SDQL vs Slack (Pattern Count = %d, Max Time = %.2f seconds)", patterns, time))
saveas(figure(2), "div_slacks.png");