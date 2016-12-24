function [ leapYearCount ] = numLeaps( yearA, yearB )

if yearA > yearB
    year2 = yearA;
    year1 = yearB;
else
    year2 = yearB;
    year1 = yearA;
end

fourhundreds = floor((year2-year1+1)/400);

fourHundredIndexedYear2 = year2-(floor(year1/400)+fourhundreds)*400;
fourHundredIndexedYear1 = mod(year1,400);
crosses400threshold = fourHundredIndexedYear2/400 >= 1;
onehundreds = floor((fourHundredIndexedYear2-fourHundredIndexedYear1+1)/100);

oneHundredIndexedYear2 = fourHundredIndexedYear2-(floor(fourHundredIndexedYear1/100)+onehundreds)*100;
oneHundredIndexedYear1 = mod(fourHundredIndexedYear1,100);
crosses100threshold = oneHundredIndexedYear2/100 >= 1;
fours = floor((oneHundredIndexedYear2-oneHundredIndexedYear1+1)/4);

leapYearCount = fourhundreds*(3*24+1*25) + crosses400threshold + onehundreds*24 - crosses100threshold + fours*1;

end

