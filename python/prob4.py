from wrapper_gen import *
import numpy as np

def getMaxLength(list):
    return max([sum(combo[0]) + combo[1] for combo in withInputs])

def calcLength(values, numCores, trial):
    length = 0
    for core in range(numCores):
        length += max(values[trial[core]])
    return length

def generateSOC(values, numBits, numCores):
    coreBits = [2]*numCores
    while sum(coreBits) < numBits:
        trials = []
        for core in range(numCores):
            coreTrialBits = coreBits[:]
            coreTrialBits[core] += 1

            trial = calcLength(values, numCores, coreTrialBits)

            trials.append(trial)
        toIncrease = np.argmin(trials)
        coreBits[toIncrease] += 1

    return coreBits

inputs = 16
outputs = 8
chains = [12, 12, 8, 8]

results = {}
for n in range(2, 7):
    bestCombo = getCombos(chains, n)
    withInputs = applyFlexible(bestCombo, inputs)
    withOutputs = applyFlexible(bestCombo, outputs)
    # printAsTable(withInputs, withOutputs, n)
    results[n] = (getMaxLength(withInputs), getMaxLength(withOutputs))

print(results)

coreBits = generateSOC(results, 36, 8)
print(coreBits)
print(calcLength(results, 8, coreBits))

print("\\begin{table}[H]\n\\centering\n\\begin{tabular}", end="")
print("{", "|l|", *(["c|"]*(8+1)) , "} \\hline")
print("Core", *range(1, 9), sep=" & ", end=" \\\\ \\hline\n")    
print("TAM Bits", *coreBits, sep=" & ", end=" \\\\ \\hline")
print("\\end{tabular}\n\\caption{TAM Bit Configuration for an SOC with %d Identical Cores}\n\\end{table}" % 8)

