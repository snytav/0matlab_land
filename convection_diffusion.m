function [u]=convection_diffusion(u0_ext,x,t,v,nu) 

%*****************************************************************************80
%
%% example2() demonstrates the use of PDEPE on a scalar PDE.
%
%  Discussion:
%
%    Solve the convection-diffusion equation.
%
%    PDE: 
%      ut + (a(x)*u)x = uxx
%    BC:
%      u(t,-oo) = 0, u(t,+oo) = 0
%    IC:
%      u(0,x) = 1 / (1+(x-5)^2)
%
%    Here, the quantity a(x) is a bit complicated.  It is defined by
%      a(x) = 3 (ubar(x))^2 + 2 * ubar(x)
%    where ubar is defined implicitly by the nonlinear equation
%      1/ubar + log ( abs ( (1-ubar)/ubar ) ) = x
%
%    Ubar(x) is the equilibrium solution to the conservation law
%      ut + (u^3-u^2)x = uxx.
%
%    Although the mathematical problem has boundary conditions at infinity,
%    we approximate this by the interval [-50,+50].
%
%  Licensing:
%
%    This code is distributed under the MIT license.
%
%  Modified:
%
%    29 August 2013
%
%  Author:
%
%    Original formulation by P Howard, 2005.
%    This version by John Burkardt
%
  timestamp ( );
  fprintf ( 1, '\n' );
  fprintf ( 1, 'EXAMPLE2:\n' );
  fprintf ( 1, '  The convection-diffusion equation.\n' );
  fprintf ( 1, '  ut + (a(x)*u)x = uxx\n' );
  fprintf ( 1, '  u(t,-oo) = 0, u(t,+oo) = 0\n' );
  fprintf ( 1, '  u(0,x) = 1 / (1+(x-5)^2)\n' );
%
%  M defines the coordinate system:
%  0: cartesian
%  1: cylindrical
%  2: spherical
%
  m = 0;
%
%  Define the spatial mesh.
%
  %nx = 201;
  nx = size(x,2);
  xmesh =x; % linspace ( -50.0, +50.0, nx );
%
%  Define the time mesh.
%
  nt = size(t,2);
  tspan = t; % linspace ( 0.0, 10.0, nt );
%
%  Call PDEPE() for the solution.
%
  sol = pdepe ( m, @pdefun, u0_ext, @bcfun, xmesh, tspan );
%
%  Even though our solution is "really" a 2D array, PDEPE stores it
%  in a 3D array SOL(:,:,:).  The surf() command needs a 2D array to plot,
%  so let's copy U out of SOL.
%
  u = sol(:,:,1);

  figure ( 1 )
  surf ( xmesh, tspan, u, 'EdgeColor', 'None' );
  title ( 'Example 2: Solution Over Time', 'Fontsize', 16 );
  xlabel ( '<--- X --->' )
  ylabel ( '<--- T --->' );
  zlabel ( '<---U(X,T)--->' );
  filename = 'example2.png';
  print ( '-dpng', filename );
  fprintf ( 1, '\n' );
  fprintf ( 1, '  Saved solution plot in file "%s"\n', filename );
%
%  Plot the initial condition, U at time 0.
%
  figure ( 2 )
  plot ( xmesh, u(1,:), 'LineWidth', 3 );
  grid on
  title ( 'Example 2: Initial Condition', 'Fontsize', 16 );
  xlabel ( '<--- X --->' )
  ylabel ( '<--- U(X,T0) --->' );
  filename = 'example2_ic.png';
  print ( '-dpng', filename );
  fprintf ( 1, '  Saved initial condition plot in file "%s"\n', filename );
%
%  Plot the solution U at a fixed point, with time varying.
%
  figure ( 3 )
  mid = 1 + floor ( 55 * ( nx - 1 ) / 100 );
  plot ( tspan, u(:,mid), 'LineWidth', 3 );
  grid on
  title ( 'Example 2: Time evolution of solution at X=5.0', 'Fontsize', 16 );
  xlabel ( '<--- T --->' )
  ylabel ( '<--- U(5.0,T) --->' );
  filename = 'example2_profile.png';
  print ( '-dpng', filename );
  fprintf ( 1, '  Saved time evolution plot in file "%s"\n', filename );
%
%  Animate the profile.
%  I wish I could also display the running value of time, but it
%  does not seem possible.
%
  figure ( 4 )
  fig = plot ( xmesh, u(1,:) );
  axis ( [-50,+50,0,1] );
  title ( 'Profile animation', 'Fontsize', 16 );
  grid on
  for k = 2 : length ( tspan )
    set ( fig, 'xdata', xmesh, 'ydata', u(k,:) );
    pause ( 0.4 );
  end
%
%  Terminate.
%
  fprintf ( 1, '\n' );
  fprintf ( 1, 'EXAMPLE2:\n' );
  fprintf ( 1, '  Normal end of execution.\n' );
  fprintf ( 1, '\n' );
  timestamp ( );

  return
end
function value = degwave ( x )

%*****************************************************************************80
%
%% degwave() determines the value of UBAR in the equation.
%
%  Discussion:
%
%    MATLAB's zero finder "fzero()" must be called in order to determine
%    the value of UBAR.
%
%  Licensing:
%
%    This code is distributed under the MIT license.
%
%  Modified:
%
%    29 August 2013
%
%  Author:
%
%    John Burkardt
%
%  Input:
%
%    real X, the spatial location.
%
%  Output:
%
%    real VALUE, the value of A(X).
%
  if ( x < -35.0 )
    value = 1.0;
  elseif ( 2.0 < x )
    guess = 1.0 / x;
    value = fzero ( @f, guess, [], x );
  elseif ( -2.5 < x )
    guess = 0.6;
    value = fzero ( @f, guess, [], x );
  else
    guess = 1.0 - exp ( - 2.0 ) * exp ( x );
    value = fzero ( @f, guess, [], x );
  end

  return
end
function value = f ( u, x )

%*****************************************************************************80
%
%% f() evaluates a function, which should be zero if U = UBAR.
%
%  Licensing:
%
%    This code is distributed under the MIT license.
%
%  Modified:
%
%    29 August 2013
%
%  Author:
%
%    John Burkardt
%
%  Input:
%
%    real U, the estimated solution value at X.
%
%    real X, the spatial location.
%
%  Output:
%
%    real VALUE, the function value.
%
  value = ( 1.0 / u ) + log ( ( 1.0 - u ) / u ) - x;

  return
end
function [ c, f, s ] = pdefun ( x, t, u, dudx )

%*****************************************************************************80
%
%% pdefun() defines the components of the PDE.
%
%  Discussion:
%
%    The PDE has the form:
%
%      c * du/dt = x^(-m) d/dx ( x^m f ) + s
%
%    where m is 0, 1 or 2,
%    c, f and s are functions of x, t, u, and dudx, 
%    and most typically, f = dudx.
%
%  Licensing:
%
%    This code is distributed under the MIT license.
%
%  Modified:
%
%    29 August 2013
%
%  Author:
%
%    John Burkardt
%
%  Input:
%
%    real X, the spatial location.
%
%    real T, the current time.
%
%    real U(:,1), the estimated solution at T and X.
%
%    real DUDX(:,1), the estimated spatial derivative of U at T and X.
%
%  Output:
%
%    real C(:,1), the coefficients of du/dt.
%
%    real F(:,1), the flux terms.
%
%    real S(:,1), the source terms.
%
  c = 1.0;
  ubar = degwave ( x );
  f = dudx - ( 3.0 * ubar.^2 - 2.0 * ubar ) * u;
  s = 0.0;

  return
end
function u0 = icfun ( x )

%*****************************************************************************80
%
%% icfun() defines the initial conditions.
%
%  Licensing:
%
%    This code is distributed under the MIT license.
%
%  Modified:
%
%    29 August 2013
%
%  Author:
%
%    John Burkardt
%
%  Input:
%
%    real X, the spatial location.
%
%  Output:
%
%    real U0(:,1), the value of the solution at the initial time, 
%    and location X.
%
  u0 = 0.0;%u0_ext(x);%1.0 ./ ( 1.0 + ( x - 5.0 ).^2 );

  return
end
function [ pl, ql, pr, qr ] = bcfun ( xl, ul, xr, ur, t )

%*****************************************************************************80
%
%% bcfun() defines the boundary conditions.
%
%  Licensing:
%
%    This code is distributed under the MIT license.
%
%  Modified:
%
%    29 August 2013
%
%  Author:
%
%    John Burkardt
%
%  Input:
%
%    real XL, the spatial coordinate of the left boundary.
%
%    real UL(:,1), the solution estimate at the left boundary.
%
%    real XR, the spatial coordinate of the right boundary.
%
%    real UR(:,1), the solution estimate at the right boundary.
%
%  Output:
%
%    real PL(:,1), the Dirichlet portion of the left boundary condition.
%
%    real QL(:,1), the coefficient of the flux portion of the left 
%    boundary condition.
%
%    real PR(:,1), the Dirichlet portion of the right boundary condition.
%
%    real QR(:,1), the coefficient of the flux portion of the right 
%    boundary condition.
%
  pl = ul;
  ql = 0.0;
  pr = ur;
  qr = 0.0;

  return
end
function timestamp ( )

%*****************************************************************************80
%
%% timestamp() prints the current YMDHMS date as a timestamp.
%
%  Licensing:
%
%    This code is distributed under the MIT license.
%
%  Modified:
%
%    14 February 2003
%
%  Author:
%
%    John Burkardt
%
  t = now;
  c = datevec ( t );
  s = datestr ( c, 0 );
  fprintf ( 1, '%s\n', s );

  return
end
