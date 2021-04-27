from compression import *

patternCount = 1000
chainCount = 16
patternBits = 8
combinedPatterns, separatedPatterns = generatePatterns(chainCount, patternBits, patternCount)

# printPatterns(separatedPatterns)

implications = findImplications(combinedPatterns)
printImplications(implications, False)
cycleConfigs = findConfigurationLayout(combinedPatterns)
print()

findGraph(combinedPatterns)

patterns1 = {}
for x in range(chainCount):
    patterns1[x] = []

patterns2 = {}
for x in range(chainCount):
    patterns2[x] = []

for index, config in enumerate(cycleConfigs):
    if config:
        for pattern in combinedPatterns:
            patterns1[pattern].append(combinedPatterns[pattern][index])
    else:
        for pattern in combinedPatterns:
            patterns2[pattern].append(combinedPatterns[pattern][index])

reduction1 = findGraph(patterns1)
print()
reduction2 = findGraph(patterns2)

inputs = 1 + max(reduction1, reduction2)
compression = inputs / chainCount
print("Compression = %.2f%%" % ((1-compression) * 100))