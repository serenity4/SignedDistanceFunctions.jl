module SignedDistanceFunctions

using Meshes

"""
Signed Distance Function. Returns the signed distance between an implicit surface defined as the root of this function, with a positive distance outside and a negative distance inside.
"""
abstract type SDF end

(p::SDF)(x) = p.f(x)

"""
Exact Signed Distance Function, valid outside and inside its implicit surface.
"""
struct TrueSDF <: SDF
    f::Function
    TrueSDF(f::Function) = new(f)
end

"""
Signed Distance Function validly defined outside its implicit surface. Inside the surface, only the sign of the returned value is correct.
"""
struct ExteriorSDF <: SDF
    f::Function
    ExteriorSDF(f::Function) = new(f)
end

struct BooleanSDF <: SDF
    f::Function
    BooleanSDF(f::Function) = new(f)
end

Base.union(sdfs::SDF...) = ExteriorSDF(x -> minimum(sdf.f(x) for sdf in sdfs))
Base.intersect(sdfs::SDF...) = BooleanSDF(x -> maximum(sdf.f(x) for sdf in sdfs))
Base.:-(sdf1::SDF, sdf2::SDF) = BooleanSDF(x -> max(sdf1.f(x), -sdf2.f(x)))

onion(thickness, sdf::SDF) = typeof(sdf)(x -> abs(sdf.f(x)) - thickness)
onion(thickness, obj) = onion(thickness, sdf(obj))
Base.round(radius, sdf::SDF) = typeof(sdf)(x -> sdf.f(x) - radius)

function smooth_union(x, y, factor)
    h = clamp(0.5 + 0.5 * (x - y)/factor, 0., 1.)
    coordinates(Segment(Point(x), Point(y))(h))[1] - factor * h * (1. - h)
end

smooth_union(sdf1::SDF, sdf2::SDF, factor) = BooleanSDF(x -> smooth_union(sdf1.f(x), sdf2.f(x), factor))

include("objects.jl")

export
    TrueSDF,
    ExteriorSDF,
    BooleanSDF,
    sdf,
    onion,
    smooth_union,

    Ellipse,
    HalfSpace


end
