#synthesize puts together a PFloat from three components:  sign, epoch, and lvalue

#note that the lvalue might be flipped based on the epoch and the sign.
@generated function synthesize{lattice, epochbits}(T::Type{PFloat{lattice, epochbits}}, negative::Bool, inverted::Bool, epoch::Integer, lvalue)
  eshift = latticebits(lattice)
  tshift = 63 - latticebits(lattice) - epochbits
  quote
    flipsign = negative $ inverted

    result::UInt64 = @i (((epoch << $eshift) | (lvalue)) * (flipsign ? -1 : 1)) << $tshift

    result &= magmask(T)

    result += sign_mask * negative

    #synthesize epoch + lvalue combination.

    @p result
  end
end

@generated function decompose{lattice, epochbits}(p::PFloat{lattice, epochbits})
  eshift = 63 - epochbits
  tshift = eshift - latticebits(lattice)
  lmask = latticemask(epochbits)
  quote
    ivalue = @i p
    negative = (sign_mask & ivalue) != z64
    inverted = ((inv_mask & ivalue) == z64) $ negative
    tvalue = @i(((negative != inverted) ? -1 : 1) * @s p)
    epoch = (tvalue & magnitude_mask) >> $eshift
    lvalue = (tvalue & $lmask) >> $tshift
    epoch -= (lvalue == z64) * 0x0000_0000_0000_0001

    return (negative, inverted, epoch, lvalue)
  end
end