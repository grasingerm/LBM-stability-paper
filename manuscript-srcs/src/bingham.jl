using PyPlot;

tau = 4.0e-5;
mu = 0.2;

bingham(x) = tau / x + mu;
papa(x, m) = tau / x * (1 - exp(-m*abs(x))) + mu;

xs = [1e-11; 5e-11; 1e-10; 5e-10; 1e-9; 1e-8; 1e-7; 1e-6; 5e-6; 1e-5; 5e-5; 1e-4; 5e-4; 1e-3; 5e-3; 1e-2; 5e-2; 1e-1; 1];

loglog(xs, map(bingham, xs), "k-", xs, map(x -> papa(x, 1e8), xs), "ks",
     xs, map(x -> papa(x, 1e5), xs), "ko");
legend(["Bingham","\$m = 10^8\$","\$m = 10^5\$"]);
xlabel("\$\\dot\{\\gamma\}\$");
ylabel("\$\\mu_p\$");
show();
