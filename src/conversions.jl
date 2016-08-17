const cP_TO_LBPFTSEC = 0.00067196897514;
const FT_TO_IN       = 12.0;
const BLL_TO_CFT     = 5.6145833;
const MIN_TO_SEC     = 60.0; 
const GAL_TO_CFT     = 0.133681;

@show pump_rates_bm = [2; 15];
@show pump_rates_cfts = pump_rates_bm * BLL_TO_CFT / MIN_TO_SEC;

@show annuli_dia_in = [4.5; 20.0];
@show annuli_area_sqin = map(d -> π/4 * ((d + 1.5)^2 - d^2), annuli_dia_in);
@show annuli_area_sqft = annuli_area_sqin / (FT_TO_IN^2);

@show vel_ftps = [pump_rates_cfts[1] / annuli_area_sqft[2]; pump_rates_cfts[2] / annuli_area_sqft[1]];

@show τ_lbpsqft  = [10.0; 100.0];
@show μ_cP       = [10.0; 100.0];
@show μ_lbpftsec = μ_cP * cP_TO_LBPFTSEC;
@show ρ_lbpgal   = [12.0; 18.0];
@show ρ_lbpcft   = ρ_lbpgal / GAL_TO_CFT;
@show ν_sqftpsec = [μ_lbpftsec[1] / ρ_lbpcft[2]; μ_lbpftsec[2] / ρ_lbpcft[1]];

Re(u, L, ν) = u * L / ν;
Bn(τ, L, μ, u) = τ * L / (μ * u);

@show Res = [Re(vel_ftps[1], 0.75 / FT_TO_IN, ν_sqftpsec[2]); Re(vel_ftps[2], 0.75 / FT_TO_IN, ν_sqftpsec[1])];
@show Bns = [Bn(τ_lbpsqft[1], 0.75 / FT_TO_IN, μ_lbpftsec[2], vel_ftps[2]), Bn(τ_lbpsqft[2], 0.75 / FT_TO_IN, μ_lbpftsec[1], vel_ftps[1])];
