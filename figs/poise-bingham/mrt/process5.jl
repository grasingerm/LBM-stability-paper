using Gadfly

include("/home/clementine/Shared/Dev/lbxflow/inc/LBXFlow.jl");
using LBXFlow

sim = LBXFlow.loadsim_jld("bak.jld")[2];
const i = 16;
const ni, nj = size(sim.msm.rho);
const xs = linspace(-0.5, 0.5, nj);
for k=1:sim.lat.n
  feq = zeros(nj);
  for j=1:nj
    feq[j] = LBXFlow.feq_incomp(sim.lat, sim.msm.rho[i, j], sim.msm.u[:, i, j], 
                                k);
  end
  draw(PNG("feq-$k.png", 5.5inch, 3.inch), 
       plot(x=xs, y=feq, Geom.line, Guide.XLabel("y / H"),
            Guide.YLabel("f<sub>$k</sub><sup>eq</sup>")
            ));
end
