using DataFrames, Gadfly

names = Dict("epsilon" => "ϵ", "qx" => "q<sub>x</sub>", "qy" => "q<sub>y</sub>");
tests = Dict("bgk-5" => "BGK, m = 10<sup>5</sup>", 
             "bgk-8" => "BGK, m = 10<sup>8</sup>",
             "bgk-fltr" => "BGK, filtered",
             "mrt" => "MRT, m = 10<sup>8</sup>");

for (name, var) in names
  df = DataFrame(x = Float64[], y = Float64[], Series = AbstractString[]);
  cf = DataFrame(x = Float64[], y = Float64[], Series = AbstractString[]);
  for (d, label)  in tests
    #const x = (d in ["bgk-5", "mrt"] || (name == "qx" && d == "bgk-8")) ? collect(0:62) * 400.0 : collect(0:125) * 200.0;
    const x = collect(0:250) * 100.0;
    val    =   readdlm("$d/$name.dsv", ','); 
    valeq  =   readdlm("$d/$(name)_eq.dsv", ',');

    #=y = if d in ["bgk-5", "mrt"] || (name == "qx" && d == "bgk-8")
          map(i -> norm(val[i, :] - valeq[i, :], 2) / norm(valeq[i, :], 2), 1:4:251);
        else
          map(i -> norm(val[i, :] - valeq[i, :], 2) / norm(valeq[i, :], 2), 1:2:251);
        end=#
    y = map(i -> norm(val[i, :] - valeq[i, :], 2), 1:251);
    y2 = zeros(251); y2[1] = y[1] * 100;
    for i=2:251; y2[i] = y[i] * 100 + y2[i-1];  end
    df = vcat(df, DataFrame(x=x, y=y, Series=fill(label, length(x))));
    cf = vcat(cf, DataFrame(x=x, y=y2, Series=fill(label, length(x))));
  end
  draw(PNG("$name-abs.png", 5.5inch, 3inch),
       plot(df, x=:x, y=:y, color=:Series,
       Geom.line,
       Guide.XLabel("Time (sec)"),
       Guide.YLabel("L<sub>2</sub>, $var<sup>neq</sup>")
       ));
  draw(PNG("$(name)-abs_cumulative.png", 5.5inch, 3inch),
       plot(cf, x=:x, y=:y, color=:Series,
       Geom.line,
       Guide.XLabel("Time (sec)"),
       Guide.YLabel("Rel. L<sub>2</sub>, $var<sup>neq</sup>")
       ));
end
