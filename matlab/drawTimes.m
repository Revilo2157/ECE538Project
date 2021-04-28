clear; format short e

fid = fopen("../outputs/divider_dshift/time.txt");
S = textscan(fid, "%s %f");
patterns = S{2}(2);
slack = S{2}(1);
x = [];
for ind = S{1}(3:end).'
   x = [x str2double(ind{1})];
end
x = x.'
y = S{2}(3:end)

figure(3); clf
plot(x, y)
ylabel("SDQL")
xlabel("Runtime Time (seconds)")
title(sprintf("SDQL vs Runtime (Slack = %d%%, Pattern Count = %d)", slack, patterns))
saveas(figure(3), "div_times.png");