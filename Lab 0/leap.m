function y=leap(n)
% input n: integer (year)
% output y: 1 if year n is a leap year, 0 otherwise
% If n is divisible by 4, but not by 100, or if n is divisible by 400,
% year n is a leap year
if ( ((mod(n,4)==0) && (mod(n,100)~=0)) || (mod(n,400)==0) )
	y=1;
else
	y=0;
end


