%This function determines by the Neonate number which excel sheet has to be called for the annotations, 
%which lead has to be choosen for the ECG signal, 
%and whcih sample frequency results from that


function [sheet,lead,FS]=callingSheetsLeadsandFS(Neonate)

if     Neonate == 3
                 sheet=2; % annotation sheet
                 lead=17; %13 or 17 %ECG lead can be 12-18
         elseif Neonate == 4
                 sheet=3;
                 lead=17; %13 or 17
         elseif Neonate == 5
                 sheet=4;
                 lead=16; %16
         elseif Neonate == 6
                 sheet=5;
                 lead=14; %13 or 14
         elseif Neonate == 7
                 sheet=6; 
                 lead=17; %13 or 17
         elseif Neonate == 9
                 sheet=7;
                 lead=18; %18
         elseif Neonate == 10
                 sheet=8;
                 lead=18; %18
         elseif Neonate == 13
                 sheet=9;
                 lead=15; %15 
         elseif Neonate == 15   
                 sheet=10;
                 lead=17; % 13 or 17
         end
         %sheets: N3=2 N4=3 N5(11,12,13)=4 N6=5 N7=6 N9=7 N10=8 N13=9 N15=10

        % FS depends on lead
         if lead == 13
             FS=250;
         elseif lead==14
             FS=500;
         elseif lead==15
             FS=250;
         elseif lead==16
             FS=500;
         elseif lead==17
             FS=500;
         elseif lead==18
             FS=500;
         end
end