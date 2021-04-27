import random
from copy import deepcopy as dp

random.seed(0)
prob1 = 2
prob0 = 3

RED =  "\u001b[31m"
GREEN = "\u001b[32m"
BLUE = "\u001b[34m"
END = "\u001b[0m"
EQUAL = GREEN + "EQ" + END
NOT = BLUE + "NT" + END
NONE = "NN"
CONTRADICTION = RED + "CO" + END

def getImplication(a, b):
    if a == "X" or b == "X":
        return NONE
    elif a == b:
        return EQUAL
    else:
        return NOT

def getNextBit():
    num = random.randint(1, 100)

    if num <= prob1:
        return 1
    elif num <= prob1 + prob0:
        return 0
    else:
        return "X"

def printPatterns(patterns):
    for chainIndex in range(len(patterns[0])):
        print("Chain:", "{:3}".format(chainIndex), end="\t")
        for pattern in patterns:
            print(*pattern[chainIndex], end=" ")
            print(end="\t")
        print()

# Dictionaries of Implications
def mergeImplications(a, b):
    merged = {}
    for chain in a:
        if chain not in b:
            merged[chain] = a[chain]
        else:
            if a[chain] == b[chain]:
                merged[chain] = a[chain]
            else:
                merged[chain] = NONE

def findImplication(chain1, chain2):
    implication = NONE 
    for bit1, bit2 in zip(chain1, chain2):
        currentImplication = getImplication(bit1, bit2)
        if not (currentImplication == NONE or implication == CONTRADICTION):
            if implication == NONE:
               implication = currentImplication
            else:
                if not implication == currentImplication:
                    implication = CONTRADICTION
    return implication
                       
def findImplications(patterns):
    implications = {}
    for pattern in patterns:
        implications[pattern] = {}

    for index in patterns:
        scanChain = patterns[index]

        for index2 in patterns:
            if index < index2:
                scanChain2 = patterns[index2]

                implication = findImplication(scanChain, scanChain2)
                implications[index][index2] = implication
                implications[index2][index] = implication
    return implications

def printImplications(implications, table=True):
    separator = " & "
    hline = "\\\\ \\hline\n"
    if not table:
        separator = "\t"
        hline = "\n"

    header = ["{:<6}".format(x) for x in implications]
    print("Chain", *header, sep=separator, end=hline)
    for index in implications:
        relationships = implications[index]
        print("{:6}".format(index), end="")
        for chain in implications:
            print(end=separator)
            if chain in relationships:
                print("{:<6}".format(relationships[chain]), end="")
            else:
                print("%6s" % "", end="")
        print(end=hline)

def countContradictions(implications):
    contradictions = 0
    for index in implications:
        implication = implications[index]

        for index2 in implications:
            if index2 > index:
                if implication[index2] == CONTRADICTION:
                    contradictions += 1
    return contradictions

def getCombinedBit(firstBit, secondBit):
    if firstBit == secondBit:
        return firstBit

    if firstBit == "X":
        return secondBit
    else:
        return getCombinedBit(secondBit, firstBit)


def mergePatterns(firstPattern, secondPattern):
    newPattern = []
    for firstBit, secondBit in zip(firstPattern, secondPattern):
        newPattern.append(getCombinedBit(firstBit, secondBit))
    return newPattern


def invertPattern(pattern):
    newPattern = []
    for bit in pattern:
        if not bit == "X":
            newPattern.append(int(not bit))
        else:
            newPattern.append(bit)
    return newPattern
            

def applyImplication(patterns, firstChain, secondChain, implication):
    if implication == NOT:
        secondPattern = invertPattern(patterns[secondChain])
    else:
        secondPattern = patterns[secondChain]

    newPattern = mergePatterns(patterns[firstChain], secondPattern)

    newPatterns = dp(patterns)
    newPatterns[firstChain] = newPattern
    newPatterns.pop(secondChain)

    newImplicationsList = findImplications(newPatterns)

    return ((firstChain, secondChain, implication, newPatterns, newImplicationsList), countContradictions(newImplicationsList))


def printMergeList(mergeList):
    chains = list(mergeList.keys())

    longestMerge = 0
    for chain in chains:
        longestMerge = max(longestMerge, len(mergeList[chain]))

    chains.sort()
    for index, parentChain in enumerate(chains):
        print(index + 1, "%d %s" % (parentChain, EQUAL), sep=" & ", end="")
        children = mergeList[parentChain]
        children.sort()
        index2 = 0
        for index2, childChain in enumerate(children):
            print(end=" & ")
            print(childChain[0], childChain[1], end="")
        for n in range(index2, longestMerge -1 ):
            print(end=" & ")
        print("\\\\ \\hline")

def byContradiction(item):
    return item[1]


def byNone(item):
    return item[1]

def printChains(chains):
    for chain in chains:
        print(*chain)

def invertImplication(implication):
    if implication == EQUAL:
        return NOT
    else:
        return EQUAL

def invertMerge(mergeList):
    newList = []
    for chain, implication in mergeList:
        newList.append((chain, invertImplication(implication)))
    return newList

def findGraph(patternsDict):
    
    implicationsList = findImplications(patternsDict)
    start = len(patternsDict)
    # printImplications(implicationsList, False)
    print()

    mergeList = {}

    while True:
        trials = []
        for firstChain in implicationsList:
            implications = implicationsList[firstChain]
            for secondChain in implicationsList:
                if secondChain > firstChain:
                    implication = implications[secondChain]
                    if not implication == CONTRADICTION:
                        if implication == NONE:
                            result = applyImplication(patternsDict, firstChain, secondChain, EQUAL)
                            trials.append(result)

                            result = applyImplication(patternsDict, firstChain, secondChain, NOT)
                            trials.append(result)

                        else:   
                            result = applyImplication(patternsDict, firstChain, secondChain, implication)
                            trials.append(result)
        
        trials.sort(key=byNone, reverse=True)
        trials.sort(key=byContradiction)

        if not trials:
            break

        bestTrial = trials[0]
        bestResult = bestTrial[0]
        patternsDict = bestResult[3]
        implicationsList = bestResult[4]

        firstChain = bestResult[0]
        secondChain = bestResult[1]
        implication = bestResult[2]

        if firstChain not in mergeList:
            mergeList[firstChain] = []
        firstMerge = mergeList[firstChain]

        firstMerge.append((secondChain, implication))

        if secondChain in mergeList:
            secondMerge = mergeList.pop(secondChain)

            if implication == EQUAL:
                firstMerge.extend(secondMerge)
            else:
                firstMerge.extend(invertMerge(secondMerge))

        # print("Merged %d with %d as %s" % (firstChain, secondChain, implication))

    print()

    # printChains(patterns)
    for chain in patternsDict:
        if chain not in mergeList:
            mergeList[chain] = []

    printMergeList(mergeList)
    print()
    print(str((1 - len(patternsDict) / start) * 100) + "%" )
    # printImplications(implicationsList, False)
    return len(patternsDict)

def printPatternStatistics(patterns):
    print("Chain", "Zeroes", "Ones", sep=" & ", end="\\\\ \\hline\n")
    for chain in patterns:
        pattern = patterns[chain]
        cares = {}
        for index, bit in enumerate(pattern):
            if not bit == "X":
                if bit not in cares:
                    cares[bit] = []
                cares[bit].append(index)
        print(chain, len(cares[0]), len(cares[1]), sep=" & ", end="\\\\ \\hline\n")     

def generatePatterns(chainCount, chainBits, patternCount):
    combinedPatterns = {}
    for x in range(chainCount):
        combinedPatterns[x] = []

    separatedPatterns = []
    for patternIndex in range(patternCount):
        scanChains = []
        for chainIndex in range(chainCount):
            
            scanChain = []
            for bitIndex in range(chainBits):
                scanChain.append(getNextBit())

            scanChains.append(scanChain)
            combinedPatterns[chainIndex].extend(scanChain)
        separatedPatterns.append(scanChains)
    return combinedPatterns, separatedPatterns

def findConfigurationLayout(patterns):
    cycleConfigs = []
    votes = {}
    for n in range(len(patterns[0])):
        cycleConfigs.append(0)

    for index in patterns:
        scanChain = patterns[index]
        for index2 in patterns:
            scanChain2 = patterns[index2]
            if index < index2:
                scanChain2 = patterns[index2]
                implicationCycles = sortImplications(scanChain, scanChain2)
                
                for cycle in implicationCycles[CONTRADICTION]:
                    if cycle not in votes: 
                        votes[cycle] = [0, 0]
                    votes[cycle][1] += 1

                for cycle in implicationCycles[EQUAL] + implicationCycles[NOT]:
                    if cycle not in votes: 
                        votes[cycle] = [0, 0]
                    votes[cycle][0] += 1
    
    for cycle in votes:
        if votes[cycle][1] > votes[cycle][0]:
            cycleConfigs[cycle] = 1
    return cycleConfigs
                    

def sortImplications(chain1, chain2):
    implications = {CONTRADICTION : [], EQUAL : [], NOT : [], NONE : []} 
    pairImplication = NONE
    for index, (bit1, bit2) in enumerate(zip(chain1, chain2)):
        implication = getImplication(bit1, bit2)

        if not implication == NONE:
            if pairImplication == NONE:
                pairImplication = implication
            else:
                if not implication == pairImplication:
                    implication = CONTRADICTION              
        implications[implication].append(index)
    return implications
        