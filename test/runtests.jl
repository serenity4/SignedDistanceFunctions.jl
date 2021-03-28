using SignedDistanceFunctions
using Test
using Plots
using Meshes

function Plots.plot(sdf::SignedDistanceFunctions.SDF)
    n = 100
    x = y = range(-10, 10, length=n)
    p = contourf(x, y, (x...) -> sdf(Point(x...)), levels=30, clims=(-10., 10.))
    contour!(p, x, y, (x...) -> sdf(Point(x...)), levels=[0.], c=:cyan)
end

plot(sdf(HalfSpace(Vec(1., 1.), 1.)))
plot(sdf(Sphere((1., 1.), 3.)))
plot(sdf(Ellipse((1., 1.),(0.4, 0.9), 6.)))
plot(sdf(HalfSpace(Vec(0., 1.), 1.)) ∩ sdf(HalfSpace(Vec(1., 0.), 1.)))
plot(sdf(Box((0., 0.), (4., 4.))))
plot(sdf(Box((-6., -6.), (-1., 4.))) ∪ sdf(Box((-2., -6.), (2., 0.))))
plot(sdf(Box((-6., -6.), (-1., 4.))) ∪ sdf(Box((-2., -6.), (2., 0.))) ∪ sdf(Sphere((0., 0.), 3.)))
plot(sdf(Box((-6., -6.), (-1., 4.))) ∪ sdf(Box((-2., -6.), (2., 0.))) - sdf(Sphere((0., 0.), 3.)))
plot(sdf(Sphere((1., 2.), 3.)) ∩ sdf(Sphere((0., 0.), 2.)))
plot(onion(0.2, Sphere((1.,1.),1.)))
plot(round(2., onion(0., sdf(Box((-5.,-5.),(5.,5.))))))
plot(smooth_union(sdf(Box((-6., -6.), (-1., 4.))), sdf(Box((0., -6.), (2., 0.))), 3.))
plot(smooth_union(sdf(Box((-6., -6.), (-1., 4.))), sdf(Sphere((2.,0.), 2.)), 5.))
