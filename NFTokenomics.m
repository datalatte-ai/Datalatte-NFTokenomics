clear all
close all
format longg

%% 

N=40000;    %total number of simulation itteration. Each itteration is completeing a data quest by a randomly chosen NFT

%% Total number of Isa, Iga and Ina is simulation is scaled down to make simulation vector size smaller, more accurate modeling will be done in perhaps more efficient way or another language. This simulation is just to validate few hypothesis we set to kick-off our economic model design.
    
n_dia=1;    %total number of Dia NFTs in simulation                                      
n_isa=10;   %total number of Isa NFTs in simulation  
n_iga=100;  %total number of Iga NFTs in simulation  
n_ina=900;  %total number of Ina NFTs in simulation
n_aid=0;    %total number of Aid NFTs in simulation (Aid is lower than Dia and higher than Isa and changes dynamically)
n_tot=n_dia+n_isa+n_iga+n_ina;  %total number of NFTs in simulation

pie_factor=2*pi;                %In every pie, there is 2*pi! so thats our pie sharing factor!

dia_g=1/(1+1/pie_factor+1/pie_factor+1/pie_factor); %Calculating total shares of the pie for each intelligence level based on giving Isa,iga,ina, Dia's pie divided by 2*pi!
isa_g=dia_g/pie_factor;     %total shares of Isa intelligence level in datalatte's pie
iga_g=dia_g/pie_factor;     %total shares of Iga intelligence level in datalatte's pie
ina_g=dia_g/pie_factor;     %total shares of Ina intelligence level in datalatte's pie


reward_ratio=1/pie_factor;  %Base reward ratio for each NFT data quest acomplisher proportionally to their pie ratio!

dia=dia_g/n_dia;            %Initial share of Dia NFT in datalatte's pie
isa=isa_g/n_isa;            %Initial share of each Isa NFT in datalatte's pie
iga=iga_g/n_iga;            %Initial share of each Iga NFT in datalatte's pie
ina=ina_g/n_ina;            %Initial share of each Ina NFT in datalatte's pie
aid=0;                      %Initial share of each Aid NFT in datalatte's pie

equality=1/n_tot;           %If datalatte's pie is shared farily between all NFT holders, each NFT holder will have equaly a share of 1/n_tot

%% Creating a vector for each NFT individually within AI vector 
ai=zeros(n_tot,N+1);

ai(n_dia,1)=dia;
ai(n_dia+1:n_dia+n_isa,1)=isa;
ai(n_dia+n_isa+1:n_dia+n_isa+n_iga,1)=iga;
ai(n_dia+n_isa+n_iga+1:n_tot,1)=ina;

r_equality=zeros(n_tot,N+1);
v_communize=zeros(n_tot,N+1);
reward=zeros(n_tot,N+1);
v_reward=zeros(n_tot,N+1);

dia_sustainability=0.5;
dia_accomplishing=0.25;

%% Lottory model
lottery=1;          %0: no lottery, 1:with lottery



%%
for i=1:1:N
   
    if ai(1,i)>=dia_accomplishing
    k = randperm(n_tot-1,1)+1;  %Choose a random NFT among 10,100 NFT holders who acomplished a data quest
    else
    k = randperm(n_tot,1);  %Choose a random NFT among 10,101 NFT holders who acomplished a data quest   (including Dia after sometime)
    end 
    
    for j=1:1:n_tot
        if ai(j,i)>equality
            r_equality(j,i)= (ai(j,i)-equality)/equality;
            r_equality(k,i)=0;    %NFT who accomplished a data quest do not contribute to its own reward   
        else
            r_equality(j,i)=0;    %If an NFT holder has less than equality, do not contribute to data quest accomplisher
            r_equality(k,i)=0;    
        end
    end
    
    v_communize(:,i)=r_equality(:,i)/sum(r_equality(:,i));   %normalized communize ratio
    
    reward(k,i)=ai(k,i)*reward_ratio+ai(k,i);                %Calculating data quest reward based on reward ratio (1/2/pi)
    v_reward(:,i)=v_communize(:,i)*reward(k,i);              %Calculating data quest reward contributors based on communize vector
    
    ai(k,i+1)=ai(k,i)+reward(k,i);                              %Adding reward vector the select NFT
    ai(1:k-1,i+1)=ai(1:k-1,i)-v_reward(1:k-1,i);                %Subtracting reward vector from other NFT holders 
    ai(k+1:n_tot,i+1)=ai(k+1:n_tot,i)-v_reward(k+1:n_tot,i);    %Subtracting reward vector from other NFT holders 
    
   %sanitycheck(i)=sum(ai(:,i));
end 


%% plot stuff
figure
box('on');
grid('on');
ylim([0 1])
xlim([1 N])

set(gca, 'YScale', 'log')
ylabel('NFT shares out of one pie','FontName','Arial','FontSize',12);
xlabel('data quest accomplish itteration','FontName','Arial','FontSize',12);

%set(gca, 'XTick', [0 128 256 384 511],'FontName','Arial','FontSize',12);
set(gca, 'YTick', [0 0.001 0.01 0.1 dia_sustainability dia 1],'FontName','Arial','FontSize',12);


hold all
for i=1:1:n_tot
   if       i==n_dia
            color='-b';
            rlinewidth=1;
   elseif   i>n_dia & i<=n_dia+n_isa
            color='-g';
            rlinewidth=0.7;
   elseif   i>n_dia+n_isa & i<=n_dia+n_isa+n_iga
            color='-c';
            rlinewidth=0.6;
   elseif   i>n_dia+n_isa+iga & i<=n_dia+n_isa+n_iga+n_ina
            color='-y';
            rlinewidth=0.5;
   end
    semilogy(ai(i,1:N+1),color,'LineWidth',rlinewidth)
end
hold on
v_equality=ones(1,N+1)*equality;
semilogy(v_equality,'--r','LineWidth',2.0)

v_sustainability=ones(1,N+1)*dia_sustainability;
semilogy(v_sustainability,'--r','LineWidth',2.0)


semilogy([min(find(ai(1,:)<0.5)) min(find(ai(1,:)<0.5))] ,[0.0001 1],'--b','LineWidth',1.5)
text(min(find(ai(1,:)<0.5)),0.8,'\leftarrow after 4 years','FontName','Arial','FontSize',12)


