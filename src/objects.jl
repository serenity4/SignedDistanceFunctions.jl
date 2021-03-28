struct Ellipse{Dim,T} <: Primitive{Dim,T}
    center::Point{Dim,T}
    weights::Point{Dim,T}
    radius::T
end

Ellipse(center::NTuple{Dim,T}, weights::NTuple{Dim,T}, radius::T) where {Dim,T} = Ellipse(Point(center), Point(weights), radius)

struct HalfSpace{Dim,T}
    p::Vec{Dim,T}
    offset::T
end

norm2(x) = sum(map(*, x, x))

sdf(h::HalfSpace) = TrueSDF(x -> sum(coordinates(x) .* h.p) - h.offset)
sdf(e::Ellipse) = TrueSDF(x -> hypot(((e.center - x) ./ coordinates(e.weights))...) - e.radius)
sdf(s::Sphere) = TrueSDF(x -> hypot((s.center - x)...) - s.radius)

function sdf(b::Box)
    function _sdf(x)
        c = center(b)
        radii = b.max - c
        p = x - c
        z = zero(typeof(p))
        q = abs.(p) - radii
        hypot(maximum.(zip(q, z))...) + min(maximum(q), zero(eltype(p)))
    end
    TrueSDF(_sdf)
end
