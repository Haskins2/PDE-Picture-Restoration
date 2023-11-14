close all
clear 

% Read in the picture
original = double(imread('greece.tif'));

% Read in the magic forcing function
load forcing;

% Read in the corrupted picture which contains holes
load badpicture;

% Read in an indicator picture which is 1 where the
% pixels are missing in badicture
mask = double(imread('badpixels.tif'));

% Please initialise your variables here 
alpha = 0.8;
total_iterations = 2500;

% Initialise your iterations here
restored = badpic;
restored2 = badpic; 
restored_tmp = badpic;
restored_tmp2 = badpic;
rest = zeros(1, total_iterations);
orig = zeros(1, total_iterations);
rest2 = zeros(1, total_iterations);
orig2 = zeros(1, total_iterations);
err = zeros(1, total_iterations);
err2 = zeros(1, total_iterations);

% This displays the original picture in Figure 1
figure(1);
image(original);
title('Original');
colormap(gray(256));
movegui(figure(1), "northwest");

% Display the corrupted picture in Figure 2
figure(2);
image(badpic);
title('Corrupted Picture');
colormap(gray(256));
movegui(figure(2), "northeast");

% Picture iterations (no forcing)
[j, i] = find(mask ~= 0); 

for iteration = 1 : total_iterations
   for k = 1: length(i)
        row1 = restored(j(k) - 1, i(k));
        row2 = restored((j(k) + 1), i(k));
        col1 = restored(j(k), i(k) - 1);
        col2 = restored(j(k), i(k) + 1);

        fix = restored(j(k), i(k));

        error = row1 + row2 + col1 + col2 - 4 * fix;
        restored_tmp(j(k), i(k)) = fix + alpha * error / 4;

        rest(k) = restored(j(k), i(k));
        orig(k) = original(j(k), i(k));

   end

   restored = restored_tmp;

   err(iteration) = std(rest - orig);

   if (iteration == 20)
       restored20 = restored;
   end

end

% Display restored picture in figure 3
figure(3);
image(restored);
title('Restored Picture');
colormap(gray(256));
movegui(figure(3), "southwest");

% Picture iterations (forcing)
for iteration = 1 : total_iterations
  for k = 1: length(i)
        row1 = restored2(j(k) - 1, i(k));
        row2 = restored2((j(k) + 1), i(k));
        col1 = restored2(j(k), i(k) - 1);
        col2 = restored2(j(k), i(k) + 1);

        fix = restored2(j(k), i(k));

        forcing = f(j(k), i(k));

        error = row1 + row2 + col1 + col2 - 4 * fix - forcing;
        restored_tmp2(j(k), i(k)) = fix + alpha * error / 4;

        rest2(k) = restored2(j(k), i(k));
        orig2(k) = original(j(k), i(k));

  end

  restored2 = restored_tmp2;

  err2(iteration) = std(rest2 - orig2);

  if (iteration == 20)
      restored20_2 = restored2;
  end

end

% Display restored image with forcing function in Figure 4
figure(4);
image(restored2);
title('Restored Picture (with F)');
colormap(gray(256));
movegui(figure(4), "south");

% Plot of two error vectors versus iteration
figure(5);
plot((1 : total_iterations), err, 'r-', (1 : total_iterations), err2, ...
    'b-', 'linewidth', 3);
legend('No forcing function', 'With forcing function');
xlabel('Iteration', 'fontsize', 20);
ylabel('Std Error', 'fontsize', 20);
movegui(figure(5), "southeast");

