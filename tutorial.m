%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Short MatLab tutorial
%
%   Aaron Shon & Rajesh Rao, University of Washington
%   16 April 2002
%
%
%   * THE 2 MOST IMPORTANT COMMANDS:
%
%     1. help <subject>
%     2. lookfor <subject>
%
%   Other useful commands:
%
%     diary <filename> -- Start writing the diary to <filename>
%     diary off        -- Turn off the diary
%     save <filename>  -- Save all variables in your workspace to <filename>
%     save <filename> x y z -- Save variables x,y,z to <filename>
%     more on          -- Stop output from scrolling by
%     more off         -- Allow output to scroll by

% Comments go after the percent signs

% Set the random number seed
rand('seed',12345);

% Create some vectors and a matrix, and fill them with
% ones.
%
% * Remember: a semicolon at the end of the line
%             suppresses output!
rowVec = ones(1,3);
colVec = ones(5,1);
onesMat = ones(3,5);

% Create a random matrix (5 x 3) whose
% entries are between 0 and 10
randMat = rand(5,3) .* 10;

simpleMat = [[1 2 3]; ...
             [4 5 6]; ...
             [7 8 9]];
fprintf('-- Here''s a matrix:\n');
simpleMat
fprintf('-- And here''s its transpose:\n');
% The transpose operation is given by '
simpleMat'
fprintf('(PAUSED)');
pause;

fprintf('-- Multiplying row by matrix:\n');
rowVec * onesMat

fprintf('-- Multiplying matrix by column:\n');
onesMat * colVec

fprintf('-- Dot product:\n');
rowVec * rowVec'

fprintf('-- Outer product:\n');
rowVec' * rowVec

fprintf('(PAUSED)');
pause;

% We want to make sure we're plotting on figure number 1
figure(1);

% The plot command can take many arugments.  Here we
% use it to plot a sine wave from 0 to 2*pi in increments
% of 0.1 radian
plot(0:0.1:2*pi,sin(0:0.1:2*pi));

% The axis command changes the drawing axes using the format:
%
% axis([minX maxX minY maxY]);
axis([0 2*pi -1 1]);

% xlabel, ylabel, title, and legend give graph labeling.
xlabel('You can use Latex in these labels, too: \Delta \alpha \beta \gamma');
ylabel('Units can go here (\epsilon  / \phi)');
title('Here''s a sample graph');

fprintf('\n\n(PAUSED)');
pause;

% hold on means 'don't replace what's on the figure right now'
hold on;

plotVec = 0:0.1:2*pi;
% Length gets you the length of a vector
N = length(plotVec);
% Size gets you the size of things with multiple dimensions
[numRows numCols] = size(randMat);

for i=1:N
  % Plot one point from a cosine curve using red x symbols
  plot(plotVec(i),cos(plotVec(i)),'rx');
  % Force drawing now
  drawnow;
  % Pause for 0.2 sec
  pause(0.2);
end

legend('First curve (sine wave)','Second curve (cosine wave)');

fprintf('-- Now we''ll clear the figure:\n\n');

% Remove the hold on the current figure
hold off;
% Clear the current figure
clf;

% Let's bring up a new figure
figure(2);
subplot(3,1,1),plot(0:0.1:2*pi,sin(0:0.1:2*pi));
subplot(3,1,1),title('Look familiar?');
subplot(3,1,2),peaks;
binaryMat = rand(100,100)>0.95;
subplot(3,1,3),spy(binaryMat);
subplot(3,1,3),title('Sparsity plot of a binary matrix');
subplot(3,1,3),xlabel('Time (msec)');
subplot(3,1,3),ylabel('Neuron number');

recursionDepth = 10;
% We can also call functions
[fibNum] = fibonacci(recursionDepth);

% frprintf can print strings (%s), integers (%i), or floats (%f)
fprintf('** The result of fibonacci(%i) is %i\n',recursionDepth, ...
fibNum);
