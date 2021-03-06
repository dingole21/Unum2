#xadd.jl - procedures and functions relating to cross-epoch addition and
#subtraction.

#contains:
#  1) functions for counting how many "cells" are required.
#  2) functions for generating subsidiary tables.

################################################################################
# FUNCTINOS FOR COUNTING HOW MANY CELLS ARE NECESSARY
################################################################################

function valuefor{lattice}(idx, ::Type{Val{lattice}})
  if idx == 0
    1
  elseif idx > length(__MASTER_LATTICE_LIST[lattice])
    __MASTER_STRIDE_LIST[lattice]
  else
    __MASTER_LATTICE_LIST[lattice][idx]
  end
end

################################################################################
## checking sub-operations comprehensively for degenerate condition:
## degenerate condition is the situation where the epochs are sufficiently far
## apart, that addition is merely augmenting to the outer ulp.  When these
## additions occur, no table is necessary to yield a result.  Because the
## distances betweeen exacts might not be uniformly distributed, it is necessary
## to do comprehensive checking.

doc"""
  Unum2.check_uninverted_addition(::Type{Val{lattice}}, power)

  returns false if adding numbers from uninverted epoch(n) to epoch(n + power)
  results exclusively in bumping up to the next ulp.  The number of resulting
  powers represents how many additional cell tables are
  necessary for uninverted addition.
"""
function check_uninverted_addition{lattice}(T::Type{Val{lattice}}, power::Integer)
  L = __MASTER_LATTICE_LIST[lattice]
  P = (__MASTER_STRIDE_LIST[lattice]) ^ power
  M = last(L)

  pass = true
  for index = 0:length(L)
    pass &= (P * valuefor(index, T) + M) < (P * valuefor(index + 1, T))
  end
  pass
end

doc"""
  Unum2.check_crossed_addition(::Type{Val{lattice}}, power)

  returns false if adding numbers from uninverted epoch(n) to inverted
  epoch("n - power -1") results exclusively in bumping up to the next ulp. The
  number of resulting powers represents how many additional cell tables are
  necessary for crossed addition.
"""
function check_crossed_addition{lattice}(T::Type{Val{lattice}}, power::Integer)
  L = __MASTER_LATTICE_LIST[lattice]
  P = (__MASTER_STRIDE_LIST[lattice]) ^ power
  M = 1/first(L)

  pass = true
  for index = 0:length(L)
    pass &= (P * valuefor(index, T) + M) < (P * valuefor(index + 1, T))
  end
  pass
end

doc"""
  Unum2.check_inverted_addition(::Type{Val{lattice}}, power)

  returns false if adding numbers from inverted epoch(n + power) to inverted
  epoch(n) results exclusively in bumping up to the next ulp.  The number of
  resulting powers represents how many additional cell tables are necessary for
  inverted addition.
"""
function check_inverted_addition{lattice}(T::Type{Val{lattice}}, power::Integer)
  L = __MASTER_LATTICE_LIST[lattice]
  P = (__MASTER_STRIDE_LIST[lattice]) ^ power
  M = 1/first(L)

  pass = true
  for index = 1:length(L) + 1
    pass &= (P / valuefor(index, T) + M) < (P / valuefor(index - 1, T))
  end
  pass
end

################################################################################
# subtraction

doc"""
  Unum2.check_uninverted_subtraction(::Type{Val{lattice}}, power)

  returns false if subtracting uninverted epoch(n) from epoch(n + power) results
  exclusively in bumping down to the previous ulp.  The number of
  resulting powers represents how many additional cell tables are necessary for
  uninverted subtraction.
"""
function check_uninverted_subtraction{lattice}(T::Type{Val{lattice}}, power::Integer)
  L = __MASTER_LATTICE_LIST[lattice]
  P = (__MASTER_STRIDE_LIST[lattice]) ^ power
  M = last(L)

  #don't forget to check the "last" value for the previous epoch.
  Q = ((__MASTER_STRIDE_LIST[lattice]) ^ (power - 1)) * M

  (P - M <= Q) && return false

  pass = true
  for index = 1:length(L) + 1
    pass &= (P * valuefor(index, T) - M) > (P * valuefor(index - 1, T))
  end
  pass
end

doc"""
  Unum2.check_crossed_subtraction(::Type{Val{lattice}}, power)

  returns false if subtracting inverted epoch("n - 1 - power") from uninverted
  epoch(n) results exclusively in bumping down to the previous ulp.  The number
  of resulting powers represents how many additional cell tables are necessary
  for crossed subtraction.
"""
function check_crossed_subtraction{lattice}(T::Type{Val{lattice}}, power::Integer)
  L = __MASTER_LATTICE_LIST[lattice]
  P = (__MASTER_STRIDE_LIST[lattice]) ^ power
  M = 1/first(L)

  pass = true
  for index = 1:length(L) + 1
    pass &= (P * valuefor(index, T) - M) > (P * valuefor(index - 1, T))
  end
  pass
end

doc"""
  Unum2.check_inverted_subtraction(::Type{Val{lattice}}, power)

  returns false if subtracting inverted epoch(n + power) from uninverted
  epoch(n) results exclusively in bumping down to the previous ulp.  The number
  of resulting powers represents how many additional cell tables are necessary
  for inverted subtraction.
"""
function check_inverted_subtraction{lattice}(T::Type{Val{lattice}}, power::Integer)
  L = __MASTER_LATTICE_LIST[lattice]
  P = (__MASTER_STRIDE_LIST[lattice]) ^ power
  M = 1

  pass = true
  for index = 0:length(L)
    pass &= (P / valuefor(index, T) - M) > (P / valuefor(index + 1, T))
  end
  pass
end

doc"""
  Unum2.count_cell_condition(::Type{Val{lattice}}, f::Function)

  applies a "check_{operation}" function and counts, how many powers require
  additional cell tables.  Ex:

    count_cell_condition(PTile6, check_inverted_addition) ==> 2
"""
function count_cell_condition{lattice}(T::Type{Val{lattice}}, f::Function)
  idx = 1
  while idx < 16  #let's presume that 10 epochs of detail is more than enough
    (!f(T, idx)) || return idx - 1
    idx += 1
  end
  throw(ErrorException("problem, attempting to calculate $f for $T"))
end

#assigning count_cell_condition as a template.
count_uninverted_addition_cells(T) = count_cell_condition(T, check_uninverted_addition)
count_crossed_addition_cells(T) = count_cell_condition(T, check_crossed_addition)
count_inverted_addition_cells(T) = count_cell_condition(T, check_inverted_addition)
count_uninverted_subtraction_cells(T) = count_cell_condition(T, check_uninverted_subtraction)
count_crossed_subtraction_cells(T) = count_cell_condition(T, check_crossed_subtraction)
count_inverted_subtraction_cells(T) = count_cell_condition(T, check_inverted_subtraction)
