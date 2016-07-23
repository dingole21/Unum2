#master lattice list

typealias LatticeNum Union{AbstractFloat, Integer, Symbol}
typealias Lattice Array{LatticeNum, 1}
const __MASTER_LATTICE_LIST = Dict{Symbol, Lattice}()
const __MASTER_PIVOT_LIST = Dict{Symbol, LatticeNum}()

function validate(l::Lattice, p::LatticeNum)
  #makes sure that a lattice has a valid properties.
  #first, the numebr of elements in the lattice must be 2^n, or zero.
  (length(l) == 0) || ispow2(length(l)) || throw(ArgumentError("proposed lattice has invalid: member count must be a power of 2"))

  #next scan the lattice and make sure it obeys ordering properties.
  for idx = 1:length(l)
    (l[idx] == 1) && throw(ArgumentError("proposed lattice is invalid: cannot contain 1"))  #1 is not allowed to be in the lattice.
    (idx > 1) && (floatval(l[idx]) > floatval(l[idx - 1]) || throw(ArgumentError("proposed lattice has invalid structure, $(l[idx]) < $(l[idx - 1])")))
    (idx < length(l)) && (floatval(l[idx]) < floatval(l[idx + 1]) || throw(ArgumentError("proposed lattice has invalid structure, $(l[idx]) > $(l[idx + 1])")))
  end

  #make sure the last number in the lattice is less than the pivot.
  (l[end] < floatval(p)) || throw(ArgumentError("proposed lattice is bigger than the pivot value"))
end

################################################################################

doc"""
  latticebits retrieves the number of bits that the lattice requires
"""
latticebits(lattice) = latticebits(__MASTER_LATTICE_LIST[lattice])

doc"""
  latticemask retrieves the number of bits that the lattice requires
"""
latticemask(epochbits) = (one(UInt64) << (63 - epochbits)) - one(UInt64)

doc"""
  lvalue retrieves the lattice value.
"""
@generated function lvalue{lattice, epochbits}(x::PFloat{lattice, epochbits})
  shift = 63 - latticebits(lattice) - epochbits
  mask = latticemask(epochbits)
  :(((@i x) & $mask) >> $shift)
end

floatval(x::AbstractFloat) = BigFloat(x)
floatval(n::Integer) = BigFloat(n)
#each lattice should implement precompiled value functions which correspond to your
#favorite symbols.
floatval(s::Symbol) = floatval(Val{s})

function describe(n::LatticeNum)
  string(n)
end

pivotvalue(l::Lattice) = floatval(l[end])

function addlattice(name::Symbol, l::Lattice, p::LatticeNum)
  #first, validate the lattice
  if haskey(__MASTER_LATTICE_LIST, name)
    #it's all good if they are the same. 
    if (__MASTER_LATTICE_LIST[name] == l) &&
       (__MASTER_PIVOT_LIST[name] == p)
       return nothing
    end

    throw(ArgumentError("Proposed lattice for symbol $name is already defined."))
  end
  validate(l, p)
  __MASTER_LATTICE_LIST[name] = l
  __MASTER_PIVOT_LIST[name] = p
  nothing
end

function list(l::Lattice)
  println("members of lattice:")
  println(join(l, ", "))
end

function latticebits(l::Lattice)
  (length(l) == 0) && return 1
  trailing_zeros(length(l)) + 2
end

function search_lattice(l::Lattice, v)
  v == 1 && return 0
  for idx = 1:length(l)
    if v == l[idx]
      return idx * 2
    elseif v < l[idx]
      return idx * 2 - 1
    end
  end
  return length(l) + 1
end
