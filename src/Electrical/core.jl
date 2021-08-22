# Inspired by https://mtk.sciml.ai/dev/tutorials/acausal_components/

# a point in the circuit with a given voltage and current
@connector function Pin(; name)
    sts = @variables v(t)=1.0 i(t)=1.0
    ODESystem(Equation[], t, sts, []; name)
end

# ground pin, where voltage is 0
function Ground(; name)
    @named g = Pin()
    eqs = [g.v ~ 0.]
    compose(ODESystem(eqs, t, [], []; name), g)
end

# abstraction for all 2-pin components
function OnePort(; name)
    # two pins
    @named p = Pin()
    @named n = Pin()
    # component has a voltage across it, and current through
    sts = @variables v(t)=1.0 i(t)=1.0
    eqs = [
        v ~ p.v - n.v    # KVL
        0. ~ p.i + n.i   # KCL
        i ~ p.i          # Current through component is current through +ve pin
    ]
    compose(ODESystem(eqs, t, sts, []; name), p, n)
end

function ModelingToolkit.connect(::Type{Pin}, ps...)
    eqs = [
        0. ~ sum(p->p.i, ps)    # KCL
    ]
    # KVL
    for i in 1:length(ps)-1
        push!(eqs, ps[i].v ~ ps[i+1].v)
    end
    return eqs
end

connect_star(comps...) = connect([comp.n for comp in comps]...)
    
function connect_series(comps...)
    eqs = Equation[]
    for i in 1:length(comps)-1
        eqs = vcat(eqs, connect(comps[i].p, comps[i+1].n))
    end
    return eqs
end

function connect_parallel(comps...)
    return [
        connect((comp.p for comp in comps)...)
        connect((comp.n for comp in comps)...)
    ]
end
