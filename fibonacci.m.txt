%%%%%%%%%%%%%%%%%%%%%
%
% fibonacci
%   Aaron Shon & Rajesh Rao, University of Washington
%   16 April 2002
%
% This function is called by tutorial.m
%
% Computes a member of the Fibonacci sequence
%
% PARAMS:
%   i           --      The index we want in the Fibonacci sequence
%
% RETURNS:
%   val         --      Scalar -- the value of the ith member of the
%                                 sequence
%
% * Remember: Do 'help debug' if you need to debug!
function [val] = fibonacci(i)
  if (i == 0) | (i == 1)
    val = 1;
    fprintf('-- At the bottom of the recursion, here''s the call stack:\n');
    dbstack;
    fprintf('-- Now we''re at a breakpoint.  (Type ''dbcont'' to exit debug mode...)');
    keyboard;
    fprintf('-- We''re past the breakpoint.  The function should return from execution soon...\n');
  else
    val = i + fibonacci(i-1);
  end
