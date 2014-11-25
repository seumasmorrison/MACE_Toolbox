function [k,sigma,L,C,Cg,Energy,Energy_flux,Sxx,Syy,ursell,steepness,eta,u,w,ax,az,tseta,epsilon,p] = SmallAmplitude(h,H,T,z,anitime)
% ______________________________________________________
% With this function, you can get the main parameters of a water wave, using
% the Airy's theory or the small amplitude wave theory (linear theory).
%
% Inputs:
%            d = water deep (m)
%            H = wave height (m)
%            T = wave period (s)
%            z = depth below the SWL (m)
%            anitime = time animation (s)
%
% Outputs:
%             k = wave number
%             sigma =  Frecuency
%             L = wave length
%             C = wave phase velocity
%             Cg = wave group velocity
%             Energy = energy density
%             Energy_flux = energy flux
%             Sxx = Radiation stress (onshore)
%             Syy = Radiation stress (longshore)
%             steepness = wave steepness
%             ursell = Ursell parameter
%             eta = wave profile
%             u, w = water particle velocity
%             ax, az = water particle accelerations
%             tseta, epsilon = water particle displacements
%             p = subsurface pressure
%             x = range of x
%
% Syntax:
%              Airy(h,H,T,z,anitime)
%
% Notes: 
%              none.
% 
% Example:
% [k,sigma,L,C,Cg,Energy,Energy_flux,Sxx,Syy,ursell,steepness,eta,u,w,ax,az,tseta,epsilon,p] = SmallAmplitude(50,3,10,5,5);
%
% Referents:
%              CERC. (1984). Shore Protection Manual. CERC. USA.
%              Darlymple, R.G. and Dean R.A. (1999). Water Wave Mechanics
%                      for Engineers and Scientist. World Scientific. Singapure
%              Le Mehuate, Bernard. (1976). An introduction to hidrodynamics 
%                      and water waves. Springer-Verlag. USA.
%              Sarawagi, T. (1995). Coastal Engineering-Waves, Beaches, 
%                      Wave-Structure Interactions. Developments in
%                      Geotechnical Engineering, 78. Elservier. Netherlands.
%
% Programming: Gabriel Ruiz Martinez.
% UNAM 2006.
% _______________________________________________________

%%%%% Variables definition %%%%%
   g = 9.81;
   rho = 1025;
   a =  H/2;
    
%%%%% Getting the value of L %%%%%
con = 1;
	l(con) = 0;
        l(con+1) = 1.56 * T ^ 2;         
        while abs( l(con+1) - l(con) )>0.0001, 
                l(con+2) = ( ( 9.81 * T ^ 2 ) / ( 2 * pi ) ) * tanh( ( 2 * pi * h ) / l(con+1) );
                r = l(con+1) - l(con);
                con = con + 1;
        end
L =  l(con);
    k = ( 2 * pi ) / L;
    
    
%%%%% Parameters in order to get phase angle and other...%%%%%

        sigma = ( 2 * pi ) / T;
        
%%%%% limits for the movie %%%%%%
figure('Menubar' , 'none' , 'Name' , 'Small amplitude wave theory' , 'Numbertitle' , 'off' , ...
            'Toolbar' , 'none');   
limit_x = 3 * L;    
     x = 0:1.5:limit_x;
        t = 0:0.5:anitime;
           prof = 0:1:z;
               time = length(t);
                  z = length(prof);
                         timein = moviein(time);

%%%% Computing the wave Characteristics %%%%%
if ( k * h ) < ( pi / 10 )       % Shallow water
                C = sqrt( g * h );
                Cg = C;
                Energy = ( ( 1 / 8 ) * rho * g * H ^ 2 );
                Energy_flux = ( 1 / 2 ) * rho * g *  a ^ 2 * sqrt( ( g* h ) );
                Sxx = ( 3 / 2 ) * Energy;
                Syy =  (1 / 2 ) * Energy;
                ursell = ( L ^ 2 * H ) / h ^ 3;
                steepness = H / ( g * T ^ 2 );
                for t=0:time
                                 subplot(2,4,1);
                                 eta = a * cos( ( k * x ) - ( sigma * t ) );
                                 plot(x,eta,x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('Sinusoidal Wave Profile', 'Fontsize' , 8); 
                                 ylabel('\eta (m)', 'Fontsize' , 8); xlabel('x (m)', 'Fontsize' , 8);
                                 axis( [ 0 limit_x min(eta)-0.5 max(eta)+0.5 ] );
                                 
                                 subplot(2,4,2);     
                                 u = a * sqrt( ( g / h ) ) * cos( ( k * x ) - ( sigma - t ) );
                                 plot(x,u,'-r',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('U Fluid Velocity'); ylabel('u   (m/s)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(u) max(u) ] );
                                 
                                 subplot(2,4,3);
                                 w = a * sigma * ( 1 + ( z / h ) ) * sin( ( k * x ) - ( sigma * t ) ) ;
                                 plot(x,w,'-g',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('W Fluid Velocity'); ylabel('w   (m/s)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(w) max(w) ] );
                                 
                                 subplot(2,4,4);
                                 ax =  a * sigma * sqrt( g / h ) * sin( ( k * x ) - ( sigma * t ) );
                                 plot(x,ax,'-y',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('\alpha_x Fluid Acceleration'); ylabel('\alpha_x   (m/s2)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(ax) max(ax) ] );
                    
                                 subplot(2,4,5);
                                 az = - a* sigma ^ 2 * ( 1 + ( z / h ) ) * sin( ( k * x ) - ( sigma * t ) );
                                 plot(x,az,'-c',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('\alpha_z Fluid Acceleration'); ylabel('alpha_z   (m/s2)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(az) max(az) ] );    
                                 
                                 subplot(2,4,6);
                                 tseta =  - a * sigma * sqrt( g / h ) * sin( ( k * x ) - ( sigma * t ) );
                                 plot(x,tseta,'-m',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('\zeta Horizontal Displacement'); ylabel('\zeta (m)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(tseta) max(tseta) ] ); 
                                 
                                 subplot(2,4,7);
                                 epsilon = a * ( 1 + ( z / h ) ) * cos( ( k * x ) - (sigma * t ) );
                                 plot(x,epsilon,'-k',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('\xi Vertical Displacement'); ylabel('\xi (m)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(epsilon) max(epsilon) ] );                                    
                    
                                 subplot(2,4,8);
                                 p = -( rho * g * z ) + ( rho * g *eta ) ;
                                 plot(x,p,'-b',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('Subsurface Pressure'); ylabel('\p (m)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(p) max(p) ] ); 
                                
                          drawnow;
                          timein(:,time) = getframe;                                   
                end
    elseif ( ( k * h ) > ( pi / 10 ) ) && ( ( k * h ) >pi )     % Transitional water
                C = ( ( g * T ) / ( 2 * pi ) ) * tanh( k * h );
                Cg = ( ( C / 2 ) * ( 1 + ( ( 2 * k * h ) / sinh( 2 * k * h ) ) ) );
                Energy = ( (1 / 8 ) * rho * g * H ^ 2 ) * ( sigma / k ) * ( ( 1 / 2 ) * ( 1 + ( ( 2 * k * h ) / sinh( 2 * k * h ) ) ) );
                Energy_flux = ( 1 / 4 ) * rho * g * a ^ 2 * C * ( 1 +  ( ( 2 * ( k * x ) * h ) / ( sinh( 2 * ( k * x ) * h ) ) ) );
                Sxx = Energy * ( ( 1 / 2 ) + ( 2 * ( k * x ) * h ) / ( sinh( 2 * ( k * x ) * h ) ) );
                Syy = Energy * ( ( ( k * x ) * h ) / ( sinh( 2 * ( k * x ) * h ) ) ); 
                ursell = ( L ^ 2 * H ) / d ^ 3;
                steepness = H / ( g * T ^ 2 );
                for t=0:time
                                 subplot(2,4,1);
                                 eta = a * cos( ( k * x ) - ( sigma * t ) );               
                                 plot(x,eta,x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('Sinusoidal Wave Profile', 'Fontsize' , 8); 
                                 ylabel('\eta  (m)', 'Fontsize' , 8); xlabel('x (m)', 'Fontsize' , 8);
                                 axis( [ 0 limit_x min(eta)-0.5 max(eta)+0.5 ] );
                    
                                subplot(2,4,2);
                                u = ( ( a * g * k ) / sigma ) * ( ( cosh( k * ( h + z ) ) ) / cosh( k * h ) ) * cos( ( k * x ) - ( sigma - t ) ) ;             
                                plot(x,u,'-r',x,0);
                                set(gca, 'Fontsize' , 8);
                                title('U Fluid Velocity'); ylabel('u   (m/s)'); xlabel('x (m)');
                                axis( [ 0 limit_x min(u) max(u) ] );
                    
                                subplot(2,4,3);
                                w = ( ( a * g * k ) / sigma ) * ( ( sinh( k * ( h + z ) ) ) / cosh( k * h ) ) * sin( ( k * x ) - ( sigma - t ) );
                                plot(x,w,'-g',x,0);
                                set(gca, 'Fontsize' , 8);
                                title('W Fluid Velocity'); ylabel('w   (m/s)'); xlabel('x (m)');
                                axis( [ 0 limit_x min(w) max(w) ] );
                    
                                subplot(2,4,4);  
                                ax =  ( a * g * k )  * ( ( cosh( k * ( h + z ) ) ) / cosh( k * h ) ) * sin( ( k * x ) - ( sigma - t ) );
                                plot(x,ax,'-y',x,0);
                                set(gca, 'Fontsize' , 8);
                                title('\alpha_x Fluid Acceleration'); ylabel('\alpha_x   (m/s2)'); xlabel('x (m)');
                                axis( [ 0 limit_x min(ax) max(ax) ] );
                                
                                subplot(2,4,5);
                                az =  - ( a * g * k )  * ( ( sinh( k * ( h + z ) ) ) / cosh( k * h ) ) * sin( ( k * x ) - ( sigma - t ) );
                                plot(x,az,'-c',x,0);
                                set(gca, 'Fontsize' , 8);
                                title('\alpha_z Fluid Acceleration'); ylabel('\alpha_z   (m/s2)'); xlabel('x (m)');
                                axis( [ 0 limit_x min(az) max(az) ] );  
                                 
                                 subplot(2,4,6);
                                 tseta = ( - ( a * g * k ) / sigma ^ 2 ) * ( ( cosh( k * ( h + z ) ) ) / cosh( k * h ) ) * sin( ( k * x ) - ( sigma - t ) );
                                 plot(x,tseta,'-m',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('\zeta Horizontal Displacement'); ylabel('\zeta   (m)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(tseta) max(tseta) ] ); 
                                 
                                 subplot(2,4,7);
                                 epsilon = ( ( a * g * k ) / sigma ^ 2 ) * ( ( sinh( k * ( h + z ) ) ) / cosh( k * h ) ) * cos( ( k * x ) - ( sigma - t ) );
                                 plot(x,epsilon,'-k',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('\xi Vertical Displacement'); ylabel('\xi   (m)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(epsilon) max(epsilon) ] );    
                                 
                                 subplot(2,4,8);
                                 p = - ( rho * g * z ) + ( rho * g * a * ( ( cosh( k * ( h + z ) ) ) / cosh( k * h ) ) * cos( ( k * x ) - ( sigma - t ) ) );
                                 plot(x,p,'-b',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('Subsurface Pressure'); ylabel('\p   (m of water)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(p) max(p) ] ); 
                                
                          drawnow;
                          timein(:,time) = getframe;                    
                end
else       % Deep water
                C = ( ( g * T ) / ( 2 * pi ) );
                Cg = C/2; 
                Energy = ( (1 / 8 ) * rho * g * H ^ 2 ) * ( 1 / 2 ) * C;
                Energy_flux = ( 1 / 4 ) * rho * g * a ^ 2 * ( ( g * T ) / ( 2 * pi ) );
                Sxx = ( 1 / 2 ) * Energy;
                Syy = 0;
                ursell = ( L ^ 2 * H ) / h ^ 3;
                steepness = H / ( g * T ^ 2 );
                for t=0:time
                                 subplot(2,4,1);
                                 eta = a * cos( ( k * x ) - ( sigma * t ) );
                                 plot(x,eta,x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('Sinusoidal Wave Profile', 'Fontsize' , 8); 
                                 ylabel('\eta (m)', 'Fontsize' , 8); xlabel('x (m)', 'Fontsize' , 8);
                                 axis( [ 0 limit_x min(eta)-0.5 max(eta)+0.5 ] );
                                 
                                 subplot(2,4,2); 
                                 u = a * sigma * exp( k * z ) * cos( ( k * x ) - ( sigma - t ) );
                                 plot(x,u,'-r',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('U Fluid Velocity'); ylabel('u   (m/s)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(u) max(u) ] );
                                 
                                 subplot(2,4,3);
                                 w = a * sigma * exp( k * z ) * sin( ( k * x ) - ( sigma - t ) );
                                 plot(x,w,'-g',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('W Fluid Velocity'); ylabel('w   (m/s)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(w) max(w) ] );
                                 
                                 subplot(2,4,4);
                                 ax = a * sigma ^ 2 * exp( k * z ) * sin( ( k * x ) - ( sigma - t ) );
                                 plot(x,ax,'-y',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('\alpha_x Fluid Acceleration'); ylabel('\alpha_x   (m/s2)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(ax) max(ax) ] );
                    
                                 subplot(2,4,5);
                                 az = - a * sigma ^ 2 * exp( k * z ) * cos( ( k * x ) - ( sigma - t ) );
                                 plot(x,az,'-c',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('\alphaz Fluid Acceleration'); ylabel('\alpha_z   (m/s2)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(az) max(az) ] );
                                 
                                 subplot(2,4,6);
                                 tseta = a * exp( k * z ) * sin( ( k * x ) - ( sigma - t ) );
                                 plot(x,tseta,'-m',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('\zeta Horizontal Displacement'); ylabel('\zeta   (m)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(tseta) max(tseta) ] );
                                 
                                 subplot(2,4,7);
                                 epsilon = a * exp( k * z ) * cos( ( k * x ) - ( sigma - t ) );
                                 plot(x,epsilon,'-k',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('\xi Vertical Displacement'); ylabel('\xi   (m)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(epsilon) max(epsilon) ] );
                                 
                                 subplot(2,4,8);
                                 p = - ( rho * g * z ) + ( 2 * rho * g * eta * exp( k * z ) );
                                 plot(x,p,'-b',x,0);
                                 set(gca, 'Fontsize' , 8);
                                 title('Subsurface Pressure'); ylabel('p   (m of water)'); xlabel('x (m)');
                                 axis( [ 0 limit_x min(p) max(p) ] ); 
                                
                          drawnow;
                          timein(:,time) = getframe;
                end
end
