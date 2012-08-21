
# Property: a thing that changes how things are drawn.

require("backend.jl")
require("color.jl")
require("measure.jl")

# A bare property.
abstract PropertyType

# A container for one or more properties.
type Property
    specifics::Vector{PropertyType}

    function Property()
        new(PropertyType[])
    end

    function Property(specifics::Vector{PropertyType})
        new(specifics)
    end
end


function copy(a::Property)
    Property(copy(a.specifics))
end


function isempty(a::Property)
    isempty(a.specifics)
end


# Catchall nop method for applying a property that isn't imlpmented on a backend
function draw(backend::Backend, box::NativeBoundingBox, property::Property)
    for p in property.specifics
        draw(backend, box, p)
    end
end


function draw(backend::Backend, box::NativeBoundingBox, property::PropertyType)
    draw(backend, property)
end


function draw(backend::Backend, property::PropertyType)
end


type Fill <: PropertyType
    value::ColorOrNothing

    function Fill(value::ColorOrNothing)
        Property(PropertyType[new(value)])
    end

    Fill() = new()
end


function FillBare(value::ColorOrNothing)
    p = Fill()
    p.value = value
    p
end


type Stroke <: PropertyType
    value::ColorOrNothing

    function Stroke(value::ColorOrNothing)
        Property(PropertyType[new(value)])
    end

    Stroke() = new()
end


function StrokeBare(value::ColorOrNothing)
    p = Stroke()
    p.value = value
    p
end


type LineWidth <: PropertyType
    value::Measure

    function LineWidth(value::MeasureOrNumber)
        Property(PropertyType[new(size_measure(value))])
    end

    LineWidth() = new()
end


function LineWidthBare(value::MeasureOrNumber)
    p = LineWidth()
    p.value = size_measure(value)
    p
end


function draw(backend::Backend, box::NativeBoundingBox, property::LineWidth)
    draw(backend, LineWidthBare(native_measure(property.value, backend)))
end