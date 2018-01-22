%% Univariate |S2FunHarmonic|
%
%% Defning a |S2FunHarmonic|
%
%%
% *Definition via function values*
%
% At first you need some vertices
nodes = equispacedS2Grid('points', 1e5);
nodes = nodes(:);
%%
% Next you define function values for the vertices
y = smiley(nodes);
%%
% Now the actual command to get |sF1| of type |S2FunHarmonic|
sF1 = interp(nodes, y, 'harmonicApproximation')
%%
% * The |bandwith| propertie shows the maximal polynomial degree of the function.  Internally for a given bandwith there are stored $(\mathrm{bandwidth}+1)^2$ Fourier-coefficients.
% * The |antipodal| flag shows that $f(v) = f(-v)$ holds for all $v\in\bf S^2$.
%
% For the same result you could also run |S2FunHarmonic.approximation(nodes, y)| and give some additional options (<matlab:doc('S2FunHarmonic/approximation') see here>).

%%
% *Definition via function handle*
%
% If you have a function handle for the function you could create a |S2FunHarmonic| via quadrature.
% At first lets define a function handle which takes <matlab:doc(vector3d) |vector3d|> as an argument and returns double:

f = @(v) 0.1*(v.theta+sin(8*v.x).*sin(8*v.y));
%% 
% Now you can call the quadrature command to get |sF2| of type |S2FunHarmonic|
sF2 = S2FunHarmonic.quadrature(f, 'bandwidth', 50)
%%
% * If you would leave the |'bandwidth'| option empty the default bandwidth would be considered, which is 128.
% * The quadrature is faster than the approximation, because it doesn not have to solve a system of equations. But the knowledge of the function handle is also a strong requirement.
% * For more options <matlab:doc('S2FunHarmonic/quadrature') see here>.

%%
% *Definition via Fourier-coefficients*
%
% If you already know the Fourier-coefficients, you can simply hand them as a collumn vector to the constructor of |S2FunHarmonic|
fhat = rand(25, 1);
sF3 = S2FunHarmonic(fhat)

%% Operations
% The idea of |S2Fun| is to calculate with functions like MATLAB(R) does with vectors and matrices.
%
% *Basic arithmecic operations*
%
%%
% addition/subtraction
sF1+sF2; sF1+2;
sF1-sF2; sF2-4;

%%
% multiplication/division
sF1.*sF2; 2.*sF1;
sF1./(sF2+1); 2./sF2; sF2./4;

%%
% power
sF1.^sF2; 2.^sF1; sF2.^4;

%%
% absolute value of a function
abs(sF1);


%%
% *min/max*
%
%%
% calculates the local min/max of a single function
[minvalue, minnodes] = min(sF1);
[maxvalue, maxnodes] = max(sF1);

%%
% * as default |min| or |max| returns the smallest or the biggest value (global optima) with all nodes for which the value is obtained
% * with the option |min(sF1, 'numLocal', n)| the |n| nodes with the belonging biggest or smallest values are returned
% * |min(sF1)| is the same as running <matlab:doc('S2Funharmonic/steepestDescent') |steepestDescent(sF1)|>
%%
% min/max of two functions in the pointwise sense
%
min(sF1, sF2);

%%
% * See all options of min/max <matlab:doc('S2FunHarmonic/min') here>

%%
% *Other operations*
%%
% calculate the $L^2$-norm, which is only the $l^2$-norm of the Fourier-coefficients
norm(sF1);

%%
% calculate the mean value of a function
mean(sF1);

%%
% rotate a function
r = rotation('Euler', [pi/4 0 0]);
rotate(sF1, r);

%%
% symmetrise a given function
cs = crystalSymmetry('6/m');
sFs = symmetrise(sF1, cs);

%%
% * |sFs| is of type <symmetrisedFunction.html |S2FunHarmonicSym|>

%%
% *Gradient*
%%
% Caculate the gradient as a function |G| of type <VectorField.html |S2VectorFieldHarmonic|>
%
G = grad(sF1);

%%
% The direct evaluation of the gradient is faster and returns <matlab:doc(vector3d) |vector3d|>
nodes = vector3d.rand(100);
grad(sF1, nodes);


%% Visualization
% There are different ways to visualize a |S2FunHarmonic|
%
% The default |plot|-command
plot(sF1); 

%%
% * |plot(sF1)| is the same as |contourf(sF1)|

%%
% nonfilled contour plot
contour(sF1, 'LineWidth', 2);

%%
% color plot without contours
pcolor(sF1);

%%
% 3D plot which you can rotate around
plot3d(sF2);

%%
% 3D plot where the radius of the sphere is transformed according to the function values
surf(sF2);

%%
% Plot the intersection of the surf plot with a plane with normal vector |v|
plotSection(sF2, zvector);

%%
% plotting the fourier coefficients
plotSpektra(sF1);
set(gca,'FontSize', 20);