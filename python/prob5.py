
from compression import *    

patternCount = 100
chainCount = 16
patternBits = 8


    
# implications = findImplications(combinedPatterns)

# printPatterns(separatedPatterns)

combinedPatterns, separatedPatterns = generatePatterns(chainCount, patternBits, patternCount)

printPatternStatistics(combinedPatterns)
print()

findGraph(combinedPatterns)
print()
