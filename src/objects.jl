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
    c = center(b)
    ccoords = coordinates(c)
    hs = Iterators.flatten(map(enumerate(b.max - c)) do (i, l)
        vec = zero(Vec{embeddim(b),coordtype(b)})
        (HalfSpace(Meshes.setindex(vec, sign, i), sign * ccoords[i] + l) for sign in (-1, 1))
    end)
    reduce(intersect, sdf.(hs), init=BooleanSDF(x -> -Inf))
end
