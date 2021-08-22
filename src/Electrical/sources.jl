function DCVoltageSource(; name, V = 1.0)
    @named oneport = OnePort()
    @unpack v = oneport
    ps = @parameters V=V
    eqs = [
        V ~ v
    ]
    extend(ODESystem(eqs, t, [], ps; name), oneport)
end

# V = Vm sin(ωt+ϕ)
function ACVoltageSource(; name, Vm = 1.0, ω = 2π, ϕ = 0)
    @named oneport = OnePort()
    @unpack v, i = oneport
    ps = @parameters Vm=Vm ω=ω ϕ=ϕ
    eqs = [
        v ~ Vm * sin(ω * t + ϕ)
    ]
    extend(ODESystem(eqs, t, [], ps; name), oneport)
end
