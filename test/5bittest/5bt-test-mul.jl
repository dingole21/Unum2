#5bt-test-mul.jl
#testing an multiplication table for the 5 bit PTile.
#this vector doesn't include negative numbers, or zero or inf (which is trivial)
#note the vector looks like this:
#         [1/8]       [1/4]       [1/2]        [1]         [2]         [4]         [8]
# [00001  00010 00011 00100 00101 00110 00111 01000 01001 01010 01011 01100 01101 01110 01111]

btmul5 = [
#                | [1/8]         |               | [1/4]         |               | [1/2]         |               |  [1]          |               | [2]           |               |   [4]         |               | [8]           |
# (0 1/8) * ...
  ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooool)        (ooool → oooll) (ooool → oooll) (ooool → oolol) (ooool → oolol) (ooool → oolll) (ooool → oolll) (ooool → ollll);
# [1/8] * ...
  ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooolo)        ▾(oooll)        ▾(ooloo)        ▾(oolol)        ▾(oollo)        ▾(oolll)        ▾(olooo)        (olool → ollll);
# (1/8 1/4) * ...
  ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooool)        (ooool → oooll) ▾(oooll)        (oooll → oolol) ▾(oolol)        (oolol → oolll) ▾(oolll)        (oolll → olool) ▾(olool)        (olool → ollll);
# [1/4] * ...
  ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooolo)        ▾(oooll)        ▾(ooloo)        ▾(oolol)        ▾(oollo)        ▾(oolll)        ▾(olooo)        ▾(olool)        ▾(ololo)        (ololl → ollll);
# (1/4 1/2) * ...
  ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooool)        (ooool → oooll) ▾(oooll)        (oooll → oolol) ▾(oolol)        (oolol → oolll) ▾(oolll)        (oolll → olool) ▾(olool)        (olool → ololl) ▾(ololl)        (ololl → ollll);
# [1/2] * ...
  ▾(ooool)        ▾(ooool)        ▾(ooool)        ▾(ooolo)        ▾(oooll)        ▾(ooloo)        ▾(oolol)        ▾(oollo)        ▾(oolll)        ▾(olooo)        ▾(olool)        ▾(ololo)        ▾(ololl)        ▾(olloo)        (ollol → ollll);
# (1/2 1) + ...
  ▾(ooool)        ▾(ooool)        (ooool → oooll) ▾(oooll)        (oooll → oolol) ▾(oolol)        (oolol → oolll) ▾(oolll)        (oolll → olool) ▾(olool)        (olool → ololl) ▾(ololl)        (ololl → ollol) ▾(ollol)        (ollol → ollll);
# [1] * ...
  ▾(ooool)        ▾(ooolo)        ▾(oooll)        ▾(ooloo)        ▾(oolol)        ▾(oollo)        ▾(oolll)        ▾(olooo)        ▾(olool)        ▾(ololo)        ▾(ololl)        ▾(olloo)        ▾(ollol)        ▾(olllo)        ▾(ollll);
# (1 2) * ...
  (ooool → oooll) ▾(oooll)        (oooll → oolol) ▾(oolol)        (oolol → oolll) ▾(oolll)        (oolll → olool) ▾(olool)        (olool → ololl) ▾(ololl)        (ololl → ollol) ▾(ollol)        (ollol → ollll) ▾(ollll)        ▾(ollll);
# [2] * ...
  (ooool → oooll) ▾(ooloo)        ▾(oolol)        ▾(oollo)        ▾(oolll)        ▾(olooo)        ▾(olool)        ▾(ololo)        ▾(ololl)        ▾(olloo)        ▾(ollol)        ▾(olllo)        ▾(ollll)        ▾(ollll)        ▾(ollll);
# (2 4) * ...
  (ooool → oolol) ▾(oolol)        (oolol → oolll) ▾(oolll)        (oolll → olool) ▾(olool)        (olool → ololl) ▾(ololl)        (ololl → ollol) ▾(ollol)        (ollol → ollll) ▾(ollll)        ▾(ollll)        ▾(ollll)        ▾(ollll);
# [4] * ...
  (ooool → oolol) ▾(oollo)        ▾(oolll)        ▾(olooo)        ▾(olool)        ▾(ololo)        ▾(ololl)        ▾(olloo)        ▾(ollol)        ▾(olllo)        ▾(ollll)        ▾(ollll)       ▾(ollll)        ▾(ollll)        ▾(ollll);
# (4 8) * ...
  (ooool → oolll) ▾(oolll)        (oolll → olool) ▾(olool)        (olool → ololl) ▾(ololl)        (ololl → ollol) ▾(ollol)        (ollol → ollll) ▾(ollll)        ▾(ollll)        ▾(ollll)       ▾(ollll)        ▾(ollll)        ▾(ollll);
# [8] * ...
  (ooool → oolll) ▾(olooo)        ▾(olool)        ▾(ololo)        ▾(ololl)        ▾(olloo)        ▾(ollol)        ▾(olllo)        ▾(ollll)        ▾(ollll)        ▾(ollll)        ▾(ollll)       ▾(ollll)        ▾(ollll)        ▾(ollll);
  (ooool → ollll) (olool → ollll) (olool → ollll) (ololl → ollll) (ololl → ollll) (ollol → ollll) (ollol → ollll) ▾(ollll)        ▾(ollll)        ▾(ollll)        ▾(ollll)        ▾(ollll)       ▾(ollll)        ▾(ollll)        ▾(ollll);
]
