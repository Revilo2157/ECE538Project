clear; format short g

fid = fopen("../outputs/divider_dshift/patterns.txt");
S = textscan(fid, "%s %f");
slack = S{2}(1);
time = S{2}(2);
x = [];
for ind = S{1}(3:end).'
   x = [x str2double(ind{1})];
end
x = x.';
y = S{2}(3:end);

figure(1); clf
plot(x, y)
ylabel("SDQL")
xlabel("Pattern Count")
title(sprintf("SDQL vs Pattern Count (Slack = %d%%, Max Time = %.2f seconds)", slack, time))
saveas(figure(1), "div_patterns.png");