#pbound.jl - type definition for pbounds

#create a series of symbols which are effectively flags.
const PFLOAT_NULLSET   = 0x0000 #no values
const PFLOAT_SINGLETON = 0x0001 #a single value
const PFLOAT_STDBOUND  = 0x0002 #two values in a standard bound
const PFLOAT_ALLPREALS = 0x0004 #all projective reals

type PBound{lattice, epochbits} <: AbstractFloat
  lower::PFloat{lattice, epochbits}
  upper::PFloat{lattice, epochbits}
  flags::UInt16
end

function PBound{lattice, epochbits}(lower::PFloat{lattice, epochbits}, upper::PFloat{lattice, epochbits})
  if (lower == upper)
    PBound{lattice, epochbits}(lower, zero(PFloat{lattice, epochbits}), PFLOAT_SINGLETON)
  else
    PBound{lattice, epochbits}(lower, upper, PFLOAT_STDBOUND)
  end
end

PBound{lattice, epochbits}(x::PFloat{lattice, epochbits}) = PBound{lattice, epochbits}(x, zero(PFloat{lattice, epochbits}), PFLOAT_SINGLETON)
PBound{lattice, epochbits}(T::Type{PFloat{lattice, epochbits}}) = PBound{lattice, epochbits}
# COOL SYMBOLS FOR PBOUNDS

function →{lattice, epochbits}(lower::PFloat{lattice, epochbits}, upper::PFloat{lattice, epochbits})
  (lower == upper) && throw(ArgumentError("→ cannot take identical ubounds"))
  PBound{lattice, epochbits}(lower, upper, PFLOAT_STDBOUND)
end

▾{lattice, epochbits}(x::PFloat{lattice, epochbits}) = PBound{lattice, epochbits}(x, zero(PFloat{lattice, epochbits}), PFLOAT_SINGLETON)

∅{lattice, epochbits}(::Type{PBound{lattice, epochbits}}) = emptyset(PBound{lattice, epochbits})

ℝ{lattice, epochbits}(::Type{PBound{lattice, epochbits}}) = PBound{lattice,epochbits}(neg_many(PFloat{lattice, epochbits}), pos_many(PFloat{lattice, epochbits}))

ℝᵖ{lattice, epochbits}(::Type{PBound{lattice, epochbits}}) = allprojectivereals(PBound{lattice, epochbits})

export PBound, →, ▾, ∅, ℝ, ℝᵖ
