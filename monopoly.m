% This script finds the probabilities of landing on each 
% Site in Monopoly using Eigenvalue of a Markov matrix
% Guy Walker 2013

SiteLabels={'Go','Old Kent Road','Community Chest 1','Whitechapel Road','Income Tax','Kings Cross Station','Angel Islington','Chance 1','Euston Road','Pentonville Road','Just Visiting','Pall Mall','Electric Company','Whitehall','Northumberland Avenue','Marylebone Station','Bow Street','Community Chest 2','Marlborough Street','Vine Street','Free Parking','Strand','Chance 2','Fleet Street','Trafalgar Square','Fenchurch Street Station','Leicester Square','Coventry Street','Water Works','Piccadilly','Go To Jail','Regent Street','Oxford Street','Community Chest 3','Bond Street','Liverpool Street Station','Chance 3','Park Lane','Super Tax','Mayfair','Jail'};
ProbSite=zeros(41,41);
% Calculate standard probabilities of rolling two dice
dieroll=zeros(12,1);
for (i=2:12);
    dieroll(i,1)=(i-1)/36;
    if (i>7)
        dieroll(i,1)=dieroll(14-i,1);
    end    
end
% Assign raw probabilities for all sites on Board (ex Jail)
% Need to adjust standard probabilities for rolling three doubles
for (i=1:40);
    for j=(2:12);    
        ProbSite(mod(i+j-1,40)+1,i)=dieroll(j,1);
    end
end
ProbSite=ProbSite*215/216;
% Probability of Going to Jail by rolling three consecutive doubles
ProbSite(41,1:40)=1/216;
% Set Go To Jail site as automatic In Jail
ProbSite(:,31)=zeros(41,1);
ProbSite(41,:)=ProbSite(41,:)+ProbSite(31,:);
ProbSite(31,:)=zeros(1,41);
% When in Jail assume wait for 3rd turn or double to get out.
% The distribution therefore favours doubles with Bow Street and
% Marlborough Street most likely
probdouble=1/6+5/36+25/216;
outofjailroll=zeros(12,1);
for (i=2:12);
    if (mod(i,2)==0);        
        outofjailroll(i)=((1/36)/(1/6))*probdouble+((dieroll(i)-1/36)/(5/6))*(1-probdouble);
    else
        outofjailroll(i)=(dieroll(i)/(5/6))*(1-probdouble);
    end        
end
ProbSite(13:23,41)=outofjailroll(2:12,1);
answer=[answer,ProbSite(:,qcol)];
% Adjust probabilities for landing on Community Chest (site=3,18 and 34)
% note 16 CC, of which 3 lead to movement to another Site
Chest(1)=3;
Chest(2)=18;
Chest(3)=34;
for (j=1:3);
    for (i=1:41);
        if (ProbSite(Chest(j),i) ~=0);
            OldProb=ProbSite(Chest(j),i);
            ProbSite(Chest(j),i)=13*OldProb/16;
            % adjust Go site
            ProbSite(1,i)=ProbSite(1,i)+(OldProb/16);
            % adjust Old Kent Road
            ProbSite(2,i)=ProbSite(2,i)+(OldProb/16);
            % adjust Go To Jail
            ProbSite(41,i)=ProbSite(41,i)+(OldProb/16);
        end
    end
end
% Adjust probabilities for landing on Chance (site=8,23 and 37)
% There are 16 Chance, of which 7 lead to movement to another Site
% hence reason why Chance sites are least likely site to end turn on, you
% are moved on in nearly 50% of cases
Chance(1)=8;
Chance(2)=23;
Chance(3)=37;
for (j=1:3);
    for (i=1:41);
        if (ProbSite(Chance(j),i) ~=0);
            OldProb=ProbSite(Chance(j),i);
            ProbSite(Chance(j),i)=9*OldProb/16;
            % adjust Go site
            ProbSite(1,i)=ProbSite(1,i)+(OldProb/16);
            % adjust Pall Mall
            ProbSite(12,i)=ProbSite(12,i)+(OldProb/16);
            % adjust Marylebone Station
            ProbSite(16,i)=ProbSite(16,i)+(OldProb/16);            
            % adjust Trafalgar Square
            ProbSite(25,i)=ProbSite(25,i)+(OldProb/16);
            % adjust Mayfair site
            ProbSite(40,i)=ProbSite(40,i)+(OldProb/16);
            % adjust Go To Jail
            ProbSite(41,i)=ProbSite(41,i)+(OldProb/16);
            % adjust Go Back Three Spaces
            ProbSite(Chance(j)-3,i)=ProbSite(Chance(j)-3,i)+(OldProb/16);
        end
    end
end
answer=[answer,ProbSite(:,qcol)];
% Solve for Eigenvalues, need to normalised Eigenvalues to sum to 1
[V,D]=eig(ProbSite);
Probs=real(V(:,1)/sum(V(:,1)));
ProbSite(:,43)=Probs;
% Write ProbSitematrix to csv file
csvwrite('/home/fred/Documents/outputprobs.csv',ProbSite);
plot(transpose(Probs))

