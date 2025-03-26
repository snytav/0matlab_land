num_years = load('num_years.txt');
depths_uniform = load('dep.txt');
disp(depths_uniform);
disp(size(depths_uniform));
NY = size(num_years);
disp(num_years);
disp(size(num_years));
%surf()
depths_uniform = reshape(depths_uniform, 34, 36);
disp(depths_uniform);
disp(size(depths_uniform));


distances_uniform = load('dist_unif.txt');
ND = size(distances_uniform);
fig = figure;
%ax = axes(fig, 'Projection', '3d');

x = distances_uniform;
y = num_years;

%X, Y = np.meshgrid(x, y)
z = depths_uniform;
surf(x,y,z);
colorbar;
xlabel ( '<--- X --->' )
ylabel ( '<--- T --->' );

% Your two points
P1 = [0,1965,-1.5];
P2 = [320,1998,-1.5];

% Their vertial concatenation is what you want
pts = [P1; P2];

% Because that's what line() wants to see    
line(pts(:,1), pts(:,2), pts(:,3),'color','red','LineWidth',4);

saveas(gcf,'Ameland_surface_front_line.png')
qq = 0;
