using Winston

names = Dict("epsilon" => "ϵ", "qx" => "q_x", "qy" => "q_y");

tests = ["bgk-5","bgk-8","bgk-fltr","mrt"];
labels = ["BGK, m = 10^5","BGK, m = 10^8","BGK, filtered","MRT, m = 10^8"];
#props = ["k-o","k--<","k-.>","k:^"];
props = ["k","k","k","k"];
linetypes = ["dotted","longdashed","solid","dotdotdotdashed"];
#linetypes = ["k:","k-.","k-","k--"];

for (name, var) in names
  args1 = [];
  args2 = [];
  for (prop, d) in zip(props, tests)
    #const x = (d in ["bgk-5", "mrt"] || (name == "qx" && d == "bgk-8")) ? collect(0:62) * 400.0 : collect(0:125) * 200.0;
    const x = collect(0:250) * 100.0;
    val    =   readdlm("$d/$name.dsv", ','); 
    valeq  =   readdlm("$d/$(name)_eq.dsv", ',');

    #=y = if d in ["bgk-5", "mrt"] || (name == "qx" && d == "bgk-8")
          map(i -> norm(val[i, :] - valeq[i, :], 2) / norm(valeq[i, :], 2), 1:4:251);
        else
          map(i -> norm(val[i, :] - valeq[i, :], 2) / norm(valeq[i, :], 2), 1:2:251);
        end=#
    y = map(i -> norm(val[i, :] - valeq[i, :], 2) / norm(valeq[i, :], 2), 1:251);
    y2 = zeros(251); y2[1] = 100 * y[1];
    for i=2:251; y2[i] = 100 * y[i] + y2[i-1]; end
    #args1 = vcat(args1, Vector[x, y], [prop]);
    push!(args1, (x, y));
    push!(args2, (x, y2));
  end
  #=
  draw(PNG("$name.png", 5.5inch, 3inch),
       plot(df, x=:x, y=:y, color=:Series,
       Geom.line,
       Guide.XLabel("Time (sec)"),
       Guide.YLabel("Relative L<sub>2</sub>, $var<sup>neq</sup>")
       ));
  draw(PNG("$(name)_cumulative.png", 5.5inch, 3inch),
       plot(cf, x=:x, y=:y, color=:Series,
       Geom.line,
       Guide.XLabel("Time (sec)"),
       Guide.YLabel("Cumulative Rel. L<sub>2</sub>, $var<sup>neq</sup>")
       ));
       =#
  p = FramedPlot()
  for (i, a1) in enumerate(args1)
    plot(p, a1[1], a1[2], linecolor="black", linetype=linetypes[i]);
  end
  xlabel("Time (sec)");
  ylabel("Relative L_2, $var^{neq}");
  if name != "qx"
    legend(labels);
  else
    legend(labels, 0.7, 0.92);
  end
  savefig("$name.png", height=640, width=1080);

  p = FramedPlot()
  for (i, a2) in enumerate(args2)
    plot(p, a2[1], a2[2], linecolor="black", linetype=linetypes[i]);
  end
  xlabel("Time (sec)");
  ylabel("Cumulative Rel. L_2, $var^{neq}");
  legend(labels);
  savefig("$(name)_cumulative.png", height=640, width=1080);
end

