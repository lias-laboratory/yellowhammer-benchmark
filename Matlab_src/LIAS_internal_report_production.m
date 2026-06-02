%% Yellowhammer benchmark - Production of LIAS internal report maps
% The aim here is to provide you with a program that allows you to produce
% maps in the same way as in
%   Alassani A., Ouvrard R., Poinot T., Martin O., 2026. Yellowhammer benchmark presentation. LIAS internal report
% From the GitHub platform https://github.com/lias-laboratory/yellowhammer-benchmark
% Updated on 1st June 2026

clear

%% Fig. 2 Alassani et al. 2026 - Viewing French Breeding Bird Survey map
load('Map_France.mat') % France map 
u = readmatrix('Yellowhammer_2002_2024.csv');   % Yellowhammer dataset
Squares_surveyed=unique(u(:,1));    % Monitored squares

close all
figure, Pos_=get(gcf,'Position'); set(gcf,'Position',[Pos_(1) Pos_(2)/2 Pos_(3)*1.5 Pos_(4)*1.5]),box off,set(gca,'XTicklabel',[]),set(gca,'YTicklabel',[]);
% France map
mapshow(Xfr,Yfr, 'Color', 'black')
% Map of monitored squares 
for i=1:length(Squares_surveyed)    % Loop on squares surveyed
    indice=find(u(:,1)==Squares_surveyed(i));
    X=u(indice(1),4);
    Y=u(indice(1),5);
    mapshow(X,Y,'DisplayType','point','Marker','o','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',3)
end
axis([min(min(Xfr)) max(max(Xfr))+20000 min(min(Yfr))-20000 max(max(Yfr))+20000])
% Saving the figure
exportgraphics(figure(1),'FBBS_map.eps','ContentType','vector');

%%  Figs. B.8-B.9 Alassani et al. 2026 - Viewing observation maps
load('Map_France.mat') % France map 
u = readmatrix('Yellowhammer_2002_2024.csv');   % Yellowhammer dataset

% Colour scale
couleur=colormap(hot(2*max(u(:,2))));
couleur=couleur(1:end/2,:);
couleur=flipud(couleur);

for year=2002:2024 % Loop on years
    close all
    figure, Pos_=get(gcf,'Position'); set(gcf,'Position',[Pos_(1) Pos_(2)/2 Pos_(3)*1.5 Pos_(4)*1.5])
    % France map
    mapshow(Xfr,Yfr, 'Color', 'black')
    text=['title(''$',num2str(year),'$ data'',''FontSize'',30,''Interpreter'',''latex''),box on,set(gca,''XTicklabel'',[]),set(gca,''YTicklabel'',[]);'];
    eval(text)
    % Annual data map
    indice=find(u(:,3)==year);
    X=u(indice,4);
    Y=u(indice,5);
    nb=u(indice,2);
    for i=1:length(nb) % Annual data loop
        if nb(i)==0
            mapshow(X(i),Y(i),'DisplayType','point','Marker','s','MarkerEdgeColor','k','MarkerFaceColor','k')
        else
            mapshow(X(i),Y(i),'DisplayType','point','Marker','o','MarkerEdgeColor',couleur(nb(i),:),'MarkerFaceColor',couleur(nb(i),:),'MarkerSize',nb(i)+1)
        end
    end
    axis([min(min(Xfr)) max(max(Xfr))+20000 min(min(Yfr))-20000 max(max(Yfr))+20000])
    % Saving the figure
    text=['exportgraphics(figure(1),''DataBruant',num2str(year),'.eps'',''ContentType'',''vector'');'];
    eval(text)    
end

%%  Fig. B.10 Alassani et al. 2026 - Viewing maps of the most correlated CLC variables with the Yellowhammer data
% CLC variables of 2012
load('Portions_CLC2012.mat')

% Download latitude and longitude matrices (Mat_lat and Mat_long) and the map of France
load('Indice_CLIM_2002_2024.mat')
load('Map_France.mat') % France map 

% Selection of the most correlated CLC variables
Indices=[2 12 18 20 21 23 24 25 26]; 
name_CLC={'CLC112';'CLC211';'CLC231';'CLC242';'CLC243';'CLC311';'CLC312';'CLC313';'CLC324'};

for i=1:9  % CLC variable loop
    close all
    figure(1), Pos_=get(gcf,'Position'); set(gcf,'Position',[Pos_(1) Pos_(2)/2 Pos_(3)*1.5 Pos_(4)*1.5])
    % CLC variable map
    mapshow(Mat_long,Mat_lat,Portion_CLC(:,:,Indices(i)),'DisplayType', 'texturemap')
    text=['title(''Variable $',cell2mat(name_CLC(i)),'$ in $2012$'',''FontSize'',30,''Interpreter'',''latex''),box on,set(gca,''XTicklabel'',[]),set(gca,''YTicklabel'',[]);'];
    eval(text)
    axis([min(min(Xfr)) max(max(Xfr))+70000 min(min(Yfr))-20000 max(max(Yfr))+20000])
    val_max=max(max(max(Portion_CLC(:,:,Indices(i)))));
    val_min=min(min(min(Portion_CLC(:,:,Indices(i)))));
    caxis([val_min val_max])
    colorbar('east')
    % Saving the figure
    text=['exportgraphics(figure(1),''',cell2mat(name_CLC(i)),'_2012.eps'',''ContentType'',''vector'');'];
    eval(text)    
end

%%  Figs. B.11-B.12 Alassani et al. 2026 - Viewing maps of the climatic prec variable for 2002 to 2024 (idem for tmax and tmin variables)
load('Indice_CLIM_2002_2024.mat')

% Download the map of France
load('Map_France.mat') % France map 

prec_max=max(max(max(prec)));
prec_min=min(min(min(prec)));
for year=2002:2024 % Loop on years
    close all
    figure(1), Pos_=get(gcf,'Position'); set(gcf,'Position',[Pos_(1) Pos_(2)/2 Pos_(3)*1.5 Pos_(4)*1.5])
    % Annual data map
    mapshow(Mat_long,Mat_lat,prec(:,:,year-2001),'DisplayType', 'texturemap')
    text=['title(''Variable $prec$ in $',num2str(year),'$'',''FontSize'',30,''Interpreter'',''latex''),box on,set(gca,''XTicklabel'',[]),set(gca,''YTicklabel'',[]);'];
    eval(text)
    axis([min(min(Xfr)) max(max(Xfr))+70000 min(min(Yfr))-20000 max(max(Yfr))+20000])
    caxis([prec_min prec_max])
    colorbar('east')
    % Saving the figure
    text=['exportgraphics(figure(1),''prec_',num2str(year),'.eps'',''ContentType'',''vector'');'];
    eval(text)    
end

%%  Figs. B.17-B.18 Alassani et al. 2026 - Viewing maps of the bioclimatic BIO1 variable for 2002 to 2024 (idem for BIOx variables)
load('Indice_BIO_2002_2024.mat')

% Download the map of France
load('Map_France.mat') % France map 

bio1_max=max(max(max(bio_1)));
bio1_min=min(min(min(bio_1)));
for year=2002:2024 % Loop on years
    close all
    figure, Pos_=get(gcf,'Position'); set(gcf,'Position',[Pos_(1) Pos_(2)/2 Pos_(3)*1.5 Pos_(4)*1.5])
    % Annual data map
    mapshow(Mat_long,Mat_lat,bio_1(:,:,year-2001),'DisplayType', 'texturemap')
    text=['title(''Variable $BIO1$ in $',num2str(year),'$'',''FontSize'',30,''Interpreter'',''latex''),box on,set(gca,''XTicklabel'',[]),set(gca,''YTicklabel'',[]);'];
    eval(text)
    axis([min(min(Xfr)) max(max(Xfr))+70000 min(min(Yfr))-20000 max(max(Yfr))+20000])
    caxis([bio1_min bio1_max])
    colorbar('east')
    % Saving the figure
    text=['exportgraphics(figure(1),''Bio1_',num2str(year),'.eps'',''ContentType'',''vector'');'];
    eval(text)    
end

%%  Figs. B.21-B.22 Alassani et al. 2026 - Viewing maps of the GLM niche model and real data (+ Fig. 7 - Inter-annual variation)

% Download the coefficients of the GLM model estimated with the R program GLM_final_model_YH_Benchmark.R
data=readtable('Coef_GLM_final_model.txt', 'Delimiter', '\n', 'ReadVariableNames', false);
Coef=table2array(data); % Les noms ici Names_GLM_final_Bruant_dec_2025.txt
% Indices of the variables considered
ind_BIO=[1 2];
ind_CLC=[18 12 20 23 2 21 24 25 29];
% Download the explanatory variables
load('Indice_BIO_2002_2024.mat')
load('Portions_CLC2000.mat')
CLC_2000=Portion_CLC;
load('Portions_CLC2006.mat')
CLC_2006=Portion_CLC;
load('Portions_CLC2012.mat')
CLC_2012=Portion_CLC;
load('Portions_CLC2018.mat')
CLC_2018=Portion_CLC;

% Simulation of the GLM niche model
temp=ones(size(Mat_lat,1),size(Mat_lat,2),23)*Coef(1);  % Intercept
Mat_long_temp=Mat_long;
indices=find(isnan(Mat_long));
Mat_long_temp(indices)=0;
Mat_lat_temp=Mat_lat;
indices=find(isnan(Mat_lat));
Mat_lat_temp(indices)=0;
for i=1:23  % Longitude and Latitude
    temp(:,:,i)=temp(:,:,i)+Coef(2)*Mat_long_temp+Coef(3)*Mat_lat_temp;
end
j=4;
for i=1:length(ind_BIO) % BIO1 and BIO2
    TEXT=['temp=temp+Coef(j)*bio_',num2str(ind_BIO(i)),';'];
    eval(TEXT)
    j=j+1;
end
for i=1:length(ind_BIO) % BIO1^2 and BIO2^2
    TEXT=['temp=temp+Coef(j)*bio_',num2str(ind_BIO(i)),'.^2;'];
    eval(TEXT)
    j=j+1;
end
for i=1:length(ind_CLC) % CLC...
    for ii=1:23
        if ii<5 % Years 2002 to 2005
            TEXT=['temp(:,:,ii)=temp(:,:,ii)+Coef(j)*CLC_2000(:,:,',num2str(ind_CLC(i)),');'];
            eval(TEXT)
        elseif ii<11 % Years 2006 to 2011
            TEXT=['temp(:,:,ii)=temp(:,:,ii)+Coef(j)*CLC_2006(:,:,',num2str(ind_CLC(i)),');'];
            eval(TEXT)
        elseif ii<17 % Years 2012 to 2017
            TEXT=['temp(:,:,ii)=temp(:,:,ii)+Coef(j)*CLC_2012(:,:,',num2str(ind_CLC(i)),');'];
            eval(TEXT)
        else % Years 2018 to 2024
            TEXT=['temp(:,:,ii)=temp(:,:,ii)+Coef(j)*CLC_2018(:,:,',num2str(ind_CLC(i)),');'];
            eval(TEXT)
        end            
    end
    j=j+1;
end
for i=1:length(ind_CLC) % CLC...^2
    for ii=1:23
        if ii<5
            TEXT=['temp(:,:,ii)=temp(:,:,ii)+Coef(j)*CLC_2000(:,:,',num2str(ind_CLC(i)),').^2;'];
            eval(TEXT)
        elseif ii<11
            TEXT=['temp(:,:,ii)=temp(:,:,ii)+Coef(j)*CLC_2006(:,:,',num2str(ind_CLC(i)),').^2;'];
            eval(TEXT)
        elseif ii<17
            TEXT=['temp(:,:,ii)=temp(:,:,ii)+Coef(j)*CLC_2012(:,:,',num2str(ind_CLC(i)),').^2;'];
            eval(TEXT)
        else
            TEXT=['temp(:,:,ii)=temp(:,:,ii)+Coef(j)*CLC_2018(:,:,',num2str(ind_CLC(i)),').^2;'];
            eval(TEXT)
        end            
    end
    j=j+1;
end
for i=1:23  % Year
    temp(:,:,i)=temp(:,:,i)+Coef(j)*(i+2001);
end
u_GLM=exp(temp);    % A log link function

% Verification FIT 
u = readmatrix('Yellowhammer_Clim_Bioclim_CLC_2002_2024.csv');
[FIT_reel,FIT_annee]=Calcul_FIT_data_carto_vs_data_reel_octobre2025(u_GLM,u,long_fr,lat_fr,"estim");

% Figs. B.21-B.22
load('Map_France.mat') % France map
u_max=max(max(max(u_GLM)));
u_min=min(min(min(u_GLM)));
% Colour scale
couleur=colormap(hot(2*max(u(:,2))));
couleur=couleur(1:end/2,:);
couleur=flipud(couleur);
for year=2002:2024 % Loop on years
    close all
    figure(1), Pos_=get(gcf,'Position'); set(gcf,'Position',[Pos_(1) Pos_(2)/2 Pos_(3)*1.5 Pos_(4)*1.5])
    % Annual data map
    mapshow(Mat_long,Mat_lat,u_GLM(:,:,year-2001),'DisplayType', 'texturemap')
    text=['title(''$u_{GLM}$ in $',num2str(year),'$'',''FontSize'',30,''Interpreter'',''latex''),box on,set(gca,''XTicklabel'',[]),set(gca,''YTicklabel'',[]);'];
    eval(text)
    axis([min(min(Xfr)) max(max(Xfr))+70000 min(min(Yfr))-20000 max(max(Yfr))+20000])
    caxis([u_min u_max])
    colorbar('east')
    % Annual data map
    indice=find(u(:,3)==year);
    X=u(indice,4);
    Y=u(indice,5);
    nb=u(indice,2);
    for i=1:length(nb) % Annual data loop
        if nb(i)==0
            mapshow(X(i),Y(i),'DisplayType','point','Marker','s','MarkerEdgeColor','k','MarkerFaceColor','k')
        else
            mapshow(X(i),Y(i),'DisplayType','point','Marker','o','MarkerEdgeColor',couleur(nb(i),:),'MarkerFaceColor',couleur(nb(i),:),'MarkerSize',nb(i)+1)
        end
    end    
    % Saving the figure
    text=['exportgraphics(figure(1),''u_GLM_',num2str(year),'.eps'',''ContentType'',''vector'');'];
    eval(text)    
end

% Fig. 7 - Inter-annual variation in abundance given by the estimated GLM model
close all
trend=sum(sum(u_GLM));
trend=reshape(trend,[23,1]);
trend=trend/trend(1);
figure, Pos_=get(gcf,'Position'); set(gcf,'Position',[Pos_(1) Pos_(2)/2 Pos_(3)*1.5 Pos_(4)*1.5])
plot([2002:1:2024],trend,'o','MarkerSize',8)
grid on
axis([2001 2025 0 1.3])
set(gca,'FontSize',12)
xlabel('Time (years)','Interpreter','latex','FontSize',24);
ylabel('Normalized population trend','Interpreter','latex','FontSize',24);
saveas(gcf,'trend_u_GLM','epsc')