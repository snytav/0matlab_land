  clear all;
  nx = 21;
  xmesh = linspace ( 0.0, 1.0, nx );

  nt = 11;
  tspan = linspace ( 0.0, 2.0, nt );


  x = xmesh;
  D = 1.0;
  u0 = @(x) 2.0 * x ./ ( 1.0 + x.^2 );
  % u0 = ;
  V = zeros(size(x));
  D = 0.1*ones(size(x));
  u = convection_diffusion(u0,xmesh,tspan,V,D);
  u = sol(:,:,1);

  figure ( 1 )
  surf ( x, t,u );
  title ( 'Example 1: Solution Over Time', 'Fontsize', 16 );
  xlabel ( '<--- X --->' )
  ylabel ( '<--- T --->' );
  zlabel ( '<---U(X,T)--->' );
  filename = 'example1.png';
  print ( '-dpng', filename );
  fprintf ( 1, '\n' );
  fprintf ( 1, '  Saved solution plot in file "%s"\n', filename );