from wrapper_gen import *

chains = [12, 12, 8, 8, 8, 6, 6, 6, 6]

inputs = 8
outputs = 11
bestCombo = getCombos(chains, 4)
withInputs = applyFlexible(bestCombo, inputs)
withOutputs = applyFlexible(bestCombo, outputs)
printAsTable(withInputs, withOutputs, 4)
